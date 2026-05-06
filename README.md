# Survey Dataset — Data Cleaning & Standardization in SQL Server

A end-to-end data cleaning and standardization project built on SQL Server, using a messy customer satisfaction survey dataset as the source. The project covers raw data ingestion, profiling, multi-step cleaning, transformation, and a production-ready output table with downstream reporting support.

---

## Project Overview

This project simulates a real-world data cleaning pipeline where raw survey responses are loaded into SQL Server as-is and then cleaned, standardized, and transformed into a production-ready table for downstream reporting and analytics.

The source dataset contains 106 rows of customer satisfaction survey data with a range of common data quality issues — exact duplicates, inconsistent date formats, mixed casing, NULL values, and whitespace noise. The goal is to resolve all of these issues systematically using T-SQL, with full auditability and no silent modifications.

---

## Problem Statement

Raw survey data collected from multiple input channels arrives with inconsistent formatting, duplicate submissions, and missing values. Before this data can be used for reporting, KPI dashboards, or trend analysis, it needs to go through a structured cleaning pipeline that:

- Removes exact duplicate rows without affecting legitimate repeat visits
- Standardizes inconsistent categorical values to a controlled vocabulary
- Normalizes mixed date formats to a single standard type
- Handles NULL values with a documented imputation strategy
- Strips whitespace noise from free-text fields
- Keeps the raw source table as the audit and recovery layer

---

## Dataset Description

The source dataset is a customer satisfaction survey with 106 rows and 13 columns.

| Column | Description |
|---|---|
| `customer_id` | Unique customer identifier |
| `email` | Customer email address (nullable) |
| `phone` | Customer phone number (nullable) |
| `address` | Customer address |
| `rewards_member` | Whether the customer is a rewards member |
| `survey_date` | Date of survey submission |
| `survey_time` | Time of survey submission |
| `satisfaction_rating` | Overall satisfaction score (1–5 scale) |
| `service_feedback` | Free-form service rating category |
| `product_quality` | Product quality rating (High / Medium / Low) |
| `visit_frequency` | How often the customer visits (1–4 scale) |
| `recommend_to_friend` | Whether the customer would recommend |
| `freetext_response` | Open-ended customer comment |

---

## Data Quality Issues Found

**Exact duplicate rows**
Three customer_ids (8, 25, 71) each had a fully identical duplicate row — same date, same time, same content. These are system re-submission errors, not genuine repeat visits, and need to be removed.

**Inconsistent date formats**
`survey_date` was stored as VARCHAR and contained three different formats across the 106 rows: `YYYY-MM-DD` (standard, 103 rows), `YYYY/MM/DD` (slash separator, 2 rows), and `DD-MM-YYYY` (day-first, 1 row). A direct CAST without format handling would silently misparse the day-first format.

**Mixed casing in `rewards_member`**
The same Yes/No values appeared in six variants: `Yes`, `YES`, `yes`, `No`, `NO`, `no`. These need to be collapsed to a single consistent casing before any GROUP BY or filter on this column works reliably.

**Inconsistent `service_feedback` values**
The same feedback categories appeared with different casing, punctuation, and phrasing — `Good service`, `good service`, `Good Service`, `Great service`, `Excellent`, `Excellent!`, `average service`, `Average`, `Average service`, `Poor service`, `Poor service` (with trailing space). This makes aggregation completely unreliable without standardization.

**NULL values in `satisfaction_rating`**
Two rows had no rating at all. These were imputed using the dataset median (3), which is the appropriate strategy for an ordinal scale because it is not distorted by extreme values at either end. Imputed rows are flagged with a dedicated `satisfaction_imputed` column for transparency.

**Leading and trailing whitespace in `freetext_response`**
Several rows had multi-space padding at the start of the free-text field (e.g. `"        Loved the latte"`). These are invisible in most UI views but cause string comparison failures in downstream processing.

**Contact info sparsity**
52 of 106 rows had no email and 64 had no phone. This is not a data error — customers provided one or the other. These columns are retained as nullable with no imputation.

---

## Cleaning & Transformation Steps

### Step 0 — Data Profiling
Before any modifications, a set of exploratory SELECT queries profile the raw table: total row count, duplicate group identification, distinct value distributions for categorical columns, date format variants, NULL counts, and whitespace detection. This step establishes a documented baseline of what is wrong before anything is fixed.

### Step 1 — Clean Table Creation
A new target table `dbo.survey_clean` is created with proper data types — `DATE` for `survey_date`, `TIME` for `survey_time`, `TINYINT` for ratings, `BIT` for the imputation flag, and tighter VARCHAR lengths for all categorical columns. The raw table `dbo.survey_raw` is kept as the source layer and only touched for the date format fix in Step 3 — all other cleaning happens in the INSERT SELECT in Step 4.

### Step 2 — Exact Duplicate Removal
Exact duplicates are identified and removed using a CTE with `ROW_NUMBER()` partitioned across all data columns. This approach allows precise targeting of the duplicate copy (the higher `survey_id`) while leaving legitimate repeat visits — where the same customer submitted at a different time on the same day — completely untouched. A plain `DELETE DISTINCT` is not possible in SQL Server, making this the standard production approach.

### Step 3 — Date Format Normalization
The two non-standard date formats are fixed with targeted UPDATE statements before the main INSERT. `YYYY/MM/DD` is corrected with a `REPLACE()` on the slash separator. `DD-MM-YYYY` is reconstructed using `SUBSTRING()` to extract and reorder the day, month, and year components. A verification query confirms zero non-standard dates remain before proceeding.

### Step 4 — Main Transformation INSERT
All remaining cleaning logic is applied inline within a single INSERT...SELECT from the raw table:

- `email`, `phone`, and `freetext_response` receive `LTRIM + RTRIM` and `NULLIF` to strip whitespace and convert empty strings to NULL
- `rewards_member` is normalized via `CASE UPPER(...)` to collapse all six casing variants into `Yes` / `No`
- `survey_date` is converted from VARCHAR to DATE using `CONVERT(..., 120)`
- `survey_time` is cast from VARCHAR to TIME
- `satisfaction_rating` NULL values are filled using `COALESCE(..., 3)` (median imputation)
- `satisfaction_imputed` flag is set to 1 for any row where the original rating was NULL
- `service_feedback` is mapped to a four-value controlled vocabulary (`Poor`, `Average`, `Good`, `Excellent`) using `CASE LOWER(LTRIM(RTRIM(...))) LIKE` pattern matching

### Step 5 — Post-Load Verification
Ten verification queries run against `dbo.survey_clean` after the INSERT to confirm every transformation succeeded: row count, categorical value distributions, NULL counts, empty string checks, whitespace checks, imputation count, and a satisfaction rating distribution with percentages.

---

## Schema Design

### `dbo.survey_raw` — Source / Raw Layer

Stores the original 106 rows exactly as loaded from the CSV. The `survey_date` column is updated in Step 3 to normalize date formats before the main INSERT. Kept as the audit and recovery layer.

```
survey_raw
├── survey_id           INT IDENTITY PK
├── customer_id         INT
├── email               VARCHAR(100)
├── phone               VARCHAR(20)
├── address             VARCHAR(100)
├── rewards_member      VARCHAR(10)
├── survey_date         VARCHAR(20)      ← raw, mixed formats
├── survey_time         VARCHAR(10)
├── satisfaction_rating TINYINT
├── service_feedback    VARCHAR(50)
├── product_quality     VARCHAR(10)
├── visit_frequency     TINYINT
├── recommend_to_friend VARCHAR(5)
└── freetext_response   VARCHAR(200)
```

### `dbo.survey_clean` — Clean / Serving Layer

Production-ready output table with proper types, standardized values, and the imputation flag. This is the table that feeds reporting and analytics.

```
survey_clean
├── survey_id               INT PK         ← links back to survey_raw
├── customer_id             INT NOT NULL
├── email                   VARCHAR(100)   ← nullable
├── phone                   VARCHAR(20)    ← nullable
├── address                 VARCHAR(100)   NOT NULL
├── rewards_member          VARCHAR(3)     NOT NULL  ← 'Yes' / 'No' only
├── survey_date             DATE           NOT NULL  ← proper DATE type
├── survey_time             TIME           NOT NULL  ← proper TIME type
├── satisfaction_rating     TINYINT        NULL   ← median-imputed where NULL
├── satisfaction_imputed    BIT            NOT NULL  ← 1 = was imputed
├── service_feedback        VARCHAR(30)    NOT NULL  ← 4-value vocab
├── product_quality         VARCHAR(10)    NOT NULL
├── visit_frequency         TINYINT        NOT NULL
├── recommend_to_friend     VARCHAR(3)     NOT NULL
└── freetext_response       VARCHAR(200)   ← nullable, whitespace stripped
```
---

## Tech Stack

| Tool | Purpose |
|---|---|
| SQL Server (T-SQL) | All data cleaning, transformation, and schema work |
| SSMS | Query execution and result validation |
| GitHub | Version control and project documentation |

---

## Results

| Metric | Raw | Clean |
|---|---|---|
| Total rows | 106 | 103 |
| Exact duplicates | 3 pairs | 0 |
| Date format variants | 3 | 1 (DATE type) |
| `rewards_member` value variants | 6 | 2 (Yes / No) |
| `service_feedback` value variants | 11 | 4 (controlled vocab) |
| NULL `satisfaction_rating` | 2 | 0 (median-imputed, flagged) |
| Rows with whitespace noise | 10+ | 0 |
| Proper data types (date, time) | No | Yes |
