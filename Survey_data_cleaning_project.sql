CREATE DATABASE SurveyDB

-- ============================================================
-- survey_raw_setup.sql
-- Step 1: Raw table creation + data load
-- All data loaded as-is (dirty) — cleaning handled separately
-- ============================================================

USE SurveyDB;
GO

IF OBJECT_ID('dbo.survey_raw', 'U') IS NOT NULL
    DROP TABLE dbo.survey_raw;
GO

CREATE TABLE dbo.survey_raw (
    survey_id           INT IDENTITY(1,1) PRIMARY KEY,
    customer_id         INT,
    email               VARCHAR(100),
    phone               VARCHAR(20),
    address             VARCHAR(100),
    rewards_member      VARCHAR(10),
    survey_date         VARCHAR(20),        -- kept as VARCHAR intentionally; mixed formats present
    survey_time         VARCHAR(10),
    satisfaction_rating TINYINT,
    service_feedback    VARCHAR(50),
    product_quality     VARCHAR(10),
    visit_frequency     TINYINT,
    recommend_to_friend VARCHAR(5),
    freetext_response   VARCHAR(200)
);
GO

-- ============================================================
-- INSERT STATEMENTS
-- 106 rows loaded in 6 batches of ~20
-- ============================================================

-- Rows 1–20
INSERT INTO dbo.survey_raw (customer_id, email, phone, address, rewards_member, survey_date, survey_time, satisfaction_rating, service_feedback, product_quality, visit_frequency, recommend_to_friend, freetext_response)
VALUES
(1,  'jane.smith@email.com',    NULL,           '123 Main St, Springfield, IL',       'Yes', '2026-01-03', '08:30', 4,    'Good service',     'High',   3, 'Yes', '        Loved the latte'),
(1,  'jane.smith@email.com',    NULL,           '123 Main St, Springfield, IL',       'Yes', '2026-01-03', '15:45', 5,    'Excellent',         'High',   3, 'Yes', '  Even better later'),
(2,  NULL,                      '555-123-4567', '456 Elm St, Shelbyville, IL',         'No',  '2026/01/05', '10:15', 3,   'average service',   'Medium', 2, 'No',  '  Crowded'),
(2,  NULL,                      '555-123-4567', '456 Elm St, Shelbyville, IL',         'No',  '2026/01/05', '18:00', 4,   'Good service',      'Medium', 2, 'No',  'Improved later'),
(3,  'bob@email.com',           '555-221-1111', '789 Oak St, Ogdenville, IL',          'Yes', '01-06-2026', '09:00', 5,   'Excellent!',        'High',   4, 'Yes', 'Great place'),
(4,  NULL,                      NULL,           '101 Maple Ave, Capital City, IL',     'Yes', '2026-01-07', '11:00', 2,   'Poor service ',     'Low',    1, 'No',  'Long wait'),
(5,  'sara@email.com',          NULL,           '202 Pine Rd, Springfield, IL',        'YES', '2026-01-07', '13:30', 4,   'good service',      'High',   3, 'Yes', 'Friendly staff'),
(6,  NULL,                      '555-999-8888', '303 Birch Blvd, Shelbyville, IL',     'No',  '2026-01-08', '08:45', 1,   'Poor service',      'Low',    1, 'No',  '  Not happy'),
(7,  'mike@email.com',          NULL,           '444 Cedar St, Ogdenville, IL',        'Yes', '2026-01-08', '17:00', NULL, 'Average',          'Medium', 2, 'Yes', 'It was fine'),
(8,  NULL,                      '555-333-2222', '505 Walnut St, Capital City, IL',     'No',  '2026-01-09', '12:00', 3,   'average service',   'Medium', 2, 'No',  'Nothing special'),
(8,  NULL,                      '555-333-2222', '505 Walnut St, Capital City, IL',     'No',  '2026-01-09', '12:00', 3,   'average service',   'Medium', 2, 'No',  'Nothing special'),  -- duplicate
(9,  'lisa@email.com',          NULL,           '606 Chestnut Ave, Springfield, IL',   'Yes', '2026-01-09', '14:00', 5,   'Excellent',         'High',   4, 'Yes', '  Amazing'),
(10, NULL,                      NULL,           '707 Spruce Ln, Shelbyville, IL',       'No',  '2026-01-10', '09:30', 2,   'Poor service',      'Low',    1, 'No',  'Slow service'),
(11, 'jane@email.com',          NULL,           '321 Lane St, Springfield, IL',        'Yes', '2026-01-11', '08:10', 5,   'Excellent',         'High',   3, 'Yes', '  Still great'),
(12, NULL,                      '555-321-7645', '745 Oak St, Shelbyville, IL',          'No',  '2026-01-11', '10:20', 3,   'Average service',   'Medium', 2, 'No',  'Busy again'),
(13, 'robert@email.com',        '555-444-1111', '123 Test Ln, Ogdenville, IL',          'Yes', '2026-01-12', '09:05', 4,   'Good Service',      'High',   4, 'Yes', '  Consistent'),
(14, NULL,                      NULL,           '100 Maple Ave, Capital City, IL',     'Yes', '2026-01-12', '11:45', NULL, 'Poor service',     'Low',    1, 'No',  'Still slow'),
(15, 'sara.johnson@email.com',  NULL,           '202 Pinecone Rd, Springfield, IL',    'Yes', '2026-01-13', '13:15', 4,   'good service',      'High',   3, 'Yes', 'Nice visit'),
(16, NULL,                      '555-999-9999', '300 Birch Blvd, Shelbyville, IL',     'No',  '2026-01-13', '08:40', 2,   'Poor service',      'Low',    1, 'No',  'Not improving'),
(17, 'john@email.com',          NULL,           '404 Cedar St, Ogdenville, IL',        'Yes', '2026-01-14', '17:20', 3,   'Average',           'Medium', 2, 'Yes', 'Okay');

-- Rows 21–40
INSERT INTO dbo.survey_raw (customer_id, email, phone, address, rewards_member, survey_date, survey_time, satisfaction_rating, service_feedback, product_quality, visit_frequency, recommend_to_friend, freetext_response)
VALUES
(18, NULL,                      '555-321-2222', '505 Pine St, Capital City, IL',       'No',  '2026-01-14', '12:30', 3,   'average service',   'Medium', 2, 'No',  'Same'),
(19, 'alex@email.com',          NULL,           '606 Rose Ave, Springfield, IL',       'Yes', '2026-01-15', '14:10', 5,   'Excellent',         'High',   4, 'Yes', 'Love it'),
(20, NULL,                      NULL,           '707 Sycamore Ln, Shelbyville, IL',     'No',  '2026-01-15', '09:25', 1,   'Poor service',      'Low',    1, 'No',  'Worst visit'),
(21, 'sally.smith@email.com',   NULL,           '987 General Ln, Springfield, IL',     'Yes', '2026-01-16', '08:35', 4,   'Good service',      'High',   3, 'Yes', 'Good again'),
(22, NULL,                      '555-222-2222', '543 Birch St, Shelbyville, IL',        'No',  '2026-01-16', '10:10', 3,   'average service',   'Medium', 2, 'No',  'Okay'),
(23, 'bob123@email.com',        '555-123-1111', '9876 Center St, Ogdenville, IL',       'Yes', '2026-01-17', '09:15', 5,   'Excellent',         'High',   4, 'Yes', '  Perfect'),
(24, NULL,                      NULL,           '500 Middle Ave, Capital City, IL',    'Yes', '2026-01-17', '11:30', 2,   'Poor service',      'Low',    1, 'No',  'Long wait'),
(25, 'sara91@email.com',        NULL,           '123 Eagle Rd, Springfield, IL',       'YES', '2026-01-18', '13:45', 4,   'good service',      'High',   3, 'Yes', ' Nice'),
(25, 'sara91@email.com',        NULL,           '123 Eagle Rd, Springfield, IL',       'YES', '2026-01-18', '13:45', 4,   'good service',      'High',   3, 'Yes', ' Nice'),  -- duplicate
(26, NULL,                      '555-987-8888', '305 Birch Blvd, Shelbyville, IL',     'No',  '2026-01-18', '08:50', 1,   'Poor service',      'Low',    1, 'No',  'Bad'),
(27, 'michael@email.com',       NULL,           '200 Cedar Rd, Ogdenville, IL',        'Yes', '2026-01-19', '17:10', 3,   'Average',           'Medium', 2, 'Yes', 'Okay'),
(28, NULL,                      '555-777-2222', '505 Pine Ln, Capital City, IL',       'no',  '2026-01-19', '12:05', 3,   'average service',   'Medium', 2, 'No',  'Same'),
(29, 'leslie@email.com',        NULL,           '700 Chestnut Ave, Springfield, IL',   'Yes', '2026-01-20', '14:20', 5,   'Excellent',         'High',   4, 'Yes', 'Great'),
(30, NULL,                      NULL,           '707 Swift Ln, Shelbyville, IL',        'No',  '2026-01-20', '09:40', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(31, 'hr364@email.com',         NULL,           '202 Main St, Springfield, IL',        'Yes', '2026-01-21', '08:30', 4,   'Good service',      'High',   3, 'Yes', 'Good'),
(32, NULL,                      '555-123-7654', '456 Book St, Shelbyville, IL',         'No',  '2026-01-21', '10:15', 3,   'average service',   'Medium', 2, 'No',  'Crowded'),
(33, 'username01@email.com',    '555-333-1111', '345 Rose Ln, Ogdenville, IL',          'Yes', '2026-01-22', '09:00', 5,   'Excellent',         'High',   4, 'Yes', 'Loved it'),
(34, NULL,                      NULL,           '200 Spruce Ln, Capital City, IL',     'Yes', '2026-01-22', '11:00', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(35, 'michelle@email.com',      NULL,           '367 Pine Ct, Springfield, IL',        'Yes', '2026-01-23', '13:00', 4,   'good service',      'High',   3, 'Yes', 'Nice'),
(36, NULL,                      '555-123-8888', '300 Main Blvd, Shelbyville, IL',      'No',  '2026-01-23', '08:45', 1,   'Poor service',      'Low',    1, 'No',  'Bad');

-- Rows 41–60
INSERT INTO dbo.survey_raw (customer_id, email, phone, address, rewards_member, survey_date, survey_time, satisfaction_rating, service_feedback, product_quality, visit_frequency, recommend_to_friend, freetext_response)
VALUES
(37, 'mike2@email.com',         NULL,           '400 Cedar St, Ogdenville, IL',        'Yes', '2026-01-24', '17:30', 3,   'Average',           'Medium', 2, 'Yes', 'Okay'),
(38, NULL,                      '555-221-2222', '400 Walnut St, Capital City, IL',     'No',  '2026-01-24', '12:30', 3,   'average service',   'Medium', 2, 'No',  'Same'),
(39, 'lisa75@email.com',        NULL,           '600 Chestnut Ave, Springfield, IL',   'Yes', '2026-01-25', '14:10', 5,   'Excellent',         'High',   4, 'Yes', 'Great'),
(40, NULL,                      NULL,           '789 Magnolia Ln, Shelbyville, IL',     'No',  '2026-01-25', '09:20', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(41, 'jane123@email.com',       NULL,           '456 Main St, Springfield, IL',        'Yes', '2026-01-26', '08:30', 4,   'Good service',      'High',   3, 'Yes', 'Good'),
(42, NULL,                      '555-555-1234', '357 Elm St, Shelbyville, IL',          'No',  '2026-01-26', '10:15', 3,   'average service',   'Medium', 2, 'No',  'Crowded'),
(43, 'bob23@email.com',         '555-222-4321', '300 Oak St, Ogdenville, IL',           'Yes', '2026-01-27', '09:00', 5,   'Excellent',         'High',   4, 'Yes', 'Perfect'),
(44, NULL,                      NULL,           '100 Willow St, Capital City, IL',     'Yes', '2026-01-27', '11:00', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(45, 'ava@email.com',           NULL,           '202 Maple Rd, Springfield, IL',       'Yes', '2026-01-28', '13:00', 4,   'good service',      'High',   3, 'Yes', 'Nice'),
(46, NULL,                      '555-888-8888', '303 Coconut Blvd, Shelbyville, IL',   'No',  '2026-01-28', '08:45', 1,   'Poor service',      'Low',    1, 'No',  'Bad'),
(47, 'bill@email.com',          NULL,           '404 Olive St, Ogdenville, IL',        'yes', '2026-01-29', '17:30', 3,   'Average',           'Medium', 2, 'Yes', 'Okay'),
(48, NULL,                      '555-2222-2222','505 Willow St, Capital City, IL',     'No',  '2026-01-29', '12:30', 3,   'average service',   'Medium', 2, 'No',  'Same'),
(49, 'user123@email.com',       NULL,           '600 Magnolia Ave, Springfield, IL',   'Yes', '2026-01-30', '14:10', 5,   'Excellent',         'High',   4, 'Yes', 'Great'),
(50, NULL,                      NULL,           '707 Center Ln, Shelbyville, IL',       'No',  '2026-01-30', '09:20', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(51, 'jennifer.smith@email.com',NULL,           '123 Olive St, Springfield, IL',       'Yes', '2026-01-31', '08:30', 4,   'Good service',      'High',   3, 'Yes', 'Good'),
(51, 'jennifer.smith@email.com',NULL,           '123 Olive St, Springfield, IL',       'Yes', '2026-01-31', '10:30', 5,   'Great service',     'High',   3, 'Yes', 'Good'),  -- legit repeat visit
(52, NULL,                      '555-321-4567', '500 Center Rd, Shelbyville, IL',       'No',  '2026-01-31', '10:15', 3,   'average service',   'Medium', 2, 'No',  'Crowded'),
(53, 'bob101@email.com',        '555-111-1111', '300 Spruce Ln, Ogdenville, IL',        'Yes', '2026-01-31', '15:00', 5,   'Excellent',         'High',   4, 'Yes', 'Perfect'),
(54, NULL,                      NULL,           '505 Magnolia Ave, Capital City, IL',  'Yes', '2026-01-31', '16:30', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(55, 'jessie@email.com',        NULL,           '202 Cedar Rd, Springfield, IL',       'Yes', '2026-01-31', '17:45', 4,   'good service',      'High',   3, 'Yes', 'Nice');

-- Rows 61–80
INSERT INTO dbo.survey_raw (customer_id, email, phone, address, rewards_member, survey_date, survey_time, satisfaction_rating, service_feedback, product_quality, visit_frequency, recommend_to_friend, freetext_response)
VALUES
(56, NULL,                      '555-999-7777', '200 Bluebird Blvd, Shelbyville, IL',  'No',  '2026-01-31', '18:10', 1,   'Poor service',      'Low',    1, 'No',  'Bad'),
(57, 'matt@email.com',          NULL,           '505 Olive St, Ogdenville, IL',        'Yes', '2026-01-31', '18:30', 3,   'Average',           'Medium', 2, 'Yes', 'Okay'),
(58, NULL,                      '555-555-2222', '505 Main St, Capital City, IL',       'no',  '2026-01-31', '19:00', 3,   'average service',   'Medium', 2, 'No',  'Same'),
(59, 'lise@email.com',          NULL,           '100 Chestnut Ave, Springfield, IL',   'Yes', '2026-01-31', '19:30', 5,   'Excellent',         'High',   4, 'Yes', 'Great'),
(60, NULL,                      NULL,           '7100 Spruce Ln, Shelbyville, IL',      'No',  '2026-01-31', '20:00', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(61, 'jane.doe@email.com',      NULL,           '123 Upland St, Springfield, IL',      'Yes', '2026-02-01', '08:30', 4,   'Good service',      'High',   3, 'Yes', 'Good'),
(62, NULL,                      '555-555-4567', '456 Magnolia St, Shelbyville, IL',    'No',  '2026-02-01', '10:15', 3,   'average service',   'Medium', 2, 'No',  'Crowded'),
(63, 'bob32@email.com',         '555-222-1111', '789 Birch St, Ogdenville, IL',         'Yes', '2026-02-01', '15:00', 5,   'Excellent',         'High',   4, 'Yes', 'Perfect'),
(64, NULL,                      NULL,           '101 Paper Ave, Capital City, IL',     'Yes', '2026-02-01', '16:30', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(65, 'sara@email.com',          NULL,           '101 Pine Rd, Springfield, IL',        'Yes', '2026-02-01', '17:45', 4,   'good service',      'High',   3, 'Yes', 'Nice'),
(66, NULL,                      '555-111-7777', '303 Bluebird Blvd, Shelbyville, IL',  'No',  '2026-02-01', '18:10', 1,   'Poor service',      'Low',    1, 'No',  'Bad'),
(67, 'mike@email.com',          NULL,           '123 Cedar St, Ogdenville, IL',        'Yes', '2026-02-01', '18:30', 3,   'Average',           'Medium', 2, 'Yes', 'Okay'),
(68, NULL,                      '555-999-2222', '505 Bronze St, Capital City, IL',     'No',  '2026-02-01', '19:00', 3,   'average service',   'Medium', 2, 'No',  'Same'),
(69, 'lisa@email.com',          NULL,           '606 Spruce Ave, Springfield, IL',     'Yes', '2026-02-01', '19:30', 5,   'Excellent',         'High',   4, 'Yes', 'Great'),
(70, NULL,                      NULL,           '707 Olive Ln, Shelbyville, IL',        'No',  '2026-02-01', '20:00', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(71, 'jdoe@email.com',          NULL,           '987 Book Ln, Springfield, IL',        'Yes', '2026-02-02', '08:30', 4,   'Good service',      'High',   3, 'Yes', 'Good'),
(71, 'jdoe@email.com',          NULL,           '987 Book Ln, Springfield, IL',        'Yes', '2026-02-02', '08:30', 4,   'Good service',      'High',   3, 'Yes', 'Good'),  -- duplicate
(72, NULL,                      '555-555-4444', '111 Elm St, Shelbyville, IL',          'No',  '2026-02-02', '10:15', 3,   'average service',   'Medium', 2, 'No',  'Crowded'),
(73, 'victor@email.com',        '555-123-2222', '123 Oak St, Ogdenville, IL',           'Yes', '2026-02-02', '15:00', 5,   'Excellent',         'High',   4, 'Yes', 'Perfect'),
(74, NULL,                      NULL,           '202 Maple Ln, Capital City, IL',      'Yes', '2026-02-02', '16:30', 2,   'Poor service',      'Low',    1, 'No',  'Slow');

-- Rows 81–100
INSERT INTO dbo.survey_raw (customer_id, email, phone, address, rewards_member, survey_date, survey_time, satisfaction_rating, service_feedback, product_quality, visit_frequency, recommend_to_friend, freetext_response)
VALUES
(75, 'emily95@email.com',       NULL,           '400 Coconut Rd, Springfield, IL',     'Yes', '2026-02-02', '17:45', 4,   'good service',      'High',   3, 'Yes', 'Nice'),
(76, NULL,                      '555-999-9876', '303 Spruce Blvd, Shelbyville, IL',    'No',  '2026-02-02', '18:10', 1,   'Poor service',      'Low',    1, 'No',  'Bad'),
(77, 'elle@email.com',          NULL,           '505 Rose Ave, Ogdenville, IL',        'Yes', '2026-02-02', '18:30', 3,   'Average',           'Medium', 2, 'Yes', 'Okay'),
(78, NULL,                      '555-888-2222', '101 Walnut St, Capital City, IL',     'no',  '2026-02-02', '19:00', 3,   'average service',   'Medium', 2, 'No',  'Same'),
(79, 'jackie@email.com',        NULL,           '700 Sycamore Ave, Springfield, IL',   'Yes', '2026-02-02', '19:30', 5,   'Excellent',         'High',   4, 'Yes', 'Great'),
(80, NULL,                      NULL,           '300 Success Ln, Shelbyville, IL',     'No',  '2026-02-02', '20:00', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(81, 'j6555@email.com',         NULL,           '123 Center St, Springfield, IL',      'Yes', '2026-02-03', '08:30', 4,   'Good service',      'High',   3, 'Yes', 'Good'),
(82, NULL,                      '555-123-5555', '456 Sycamore St, Shelbyville, IL',    'No',  '2026-02-03', '10:15', 3,   'average service',   'Medium', 2, 'No',  'Crowded'),
(83, 'marty@email.com',         '555-321-1111', '789 Olive St, Ogdenville, IL',         'Yes', '2026-02-03', '15:00', 5,   'Excellent',         'High',   4, 'Yes', 'Perfect'),
(84, NULL,                      NULL,           '505 Service Ave, Capital City, IL',   'Yes', '2026-02-03', '16:30', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(85, 'katiel@email.com',        NULL,           '202 Clove Rd, Springfield, IL',       'Yes', '2026-02-03', '17:45', 4,   'good service',      'High',   3, 'Yes', 'Nice'),
(86, NULL,                      '555-555-7777', '303 Silver Blvd, Shelbyville, IL',    'NO',  '2026-02-03', '18:10', 1,   'Poor service',      'Low',    1, 'No',  'Bad'),
(87, 'eddie@email.com',         NULL,           '321 Olive St, Ogdenville, IL',        'YES', '2026-02-03', '18:30', 3,   'Average',           'Medium', 2, 'Yes', 'Okay'),
(88, NULL,                      '555-111-2222', '505 Dragon St, Capital City, IL',     'No',  '2026-02-03', '19:00', 3,   'average service',   'Medium', 2, 'No',  'Same'),
(89, 'marcie.smith@email.com',  NULL,           '201 Chestnut Ave, Springfield, IL',   'Yes', '2026-02-03', '19:30', 5,   'Excellent',         'High',   4, 'Yes', 'Great'),
(90, NULL,                      NULL,           '707 Silver Ln, Shelbyville, IL',       'No',  '2026-02-03', '20:00', 2,   'Poor service',      'Low',    1, 'No',  'Slow'),
(91, 'jjohne@email.com',        NULL,           '345 Main St, Springfield, IL',        'Yes', '2026-02-04', '08:30', 4,   'Good service',      'High',   3, 'Yes', 'Good'),
(92, NULL,                      '555-321-1234', '123 Elm St, Shelbyville, IL',          'No',  '2026-02-04', '10:15', 3,   'average service',   'Medium', 2, 'No',  'Crowded'),
(93, 'john@email.com',          '555-555-1111', '987 Spruce St, Ogdenville, IL',        'Yes', '2026-02-04', '15:00', 5,   'Excellent',         'High',   4, 'Yes', 'Perfect'),
(94, NULL,                      NULL,           '101 Sycamore Ave, Capital City, IL',  'Yes', '2026-02-04', '16:30', 2,   'Poor service',      'Low',    1, 'No',  'Slow');

-- Rows 101–106
INSERT INTO dbo.survey_raw (customer_id, email, phone, address, rewards_member, survey_date, survey_time, satisfaction_rating, service_feedback, product_quality, visit_frequency, recommend_to_friend, freetext_response)
VALUES
(95,  'member123@email.com',    NULL,           '202 Pecan Rd, Springfield, IL',       'Yes', '2026-02-04', '17:45', 4,   'good service',      'High',   3, 'Yes', 'Nice'),
(96,  NULL,                     '555-111-8888', '400 Birch Blvd, Shelbyville, IL',     'No',  '2026-02-04', '18:10', 1,   'Poor service',      'Low',    1, 'No',  'Bad'),
(97,  'mikie@email.com',        NULL,           '123 Olive St, Ogdenville, IL',        'yes', '2026-02-04', '18:30', 3,   'Average',           'Medium', 2, 'Yes', 'Okay'),
(98,  NULL,                     '555-444-2222', '900 Walnut St, Capital City, IL',     'No',  '2026-02-04', '19:00', 3,   'average service',   'Medium', 2, 'No',  'Same'),
(99,  'laurenw@email.com',      NULL,           '606 Walnut Ave, Springfield, IL',     'Yes', '2026-02-04', '19:30', 5,   'Excellent',         'High',   4, 'Yes', 'Great'),
(100, NULL,                     NULL,           '765 Penny Ln, Shelbyville, IL',        'No',  '2026-02-04', '20:00', 2,   'Poor service',      'Low',    1, 'No',  'Slow');

-- ============================================================
-- Quick sanity check after load
-- ============================================================
SELECT * FROM survey_raw;


USE SurveyDB; 
GO

-- ============================================================
-- STEP 0 — EXPLORATORY CHECKS ON THE RAW TABLE
-- ------------------------------------------------------------
-- Run these SELECT statements first to understand the state of
-- the raw data before touching anything. This is the equivalent
-- of a data profiling pass — good practice before any cleaning.
-- ============================================================

-- 0a. Total row count — expecting 106
SELECT COUNT(*) AS total_rows FROM dbo.survey_raw;

-- 0b. Count of fully identical duplicate rows
-- These are rows where every single column matches another row.
-- We identify them here so we know exactly how many to expect to be removed in Step 2.
SELECT
    customer_id, email, phone, address, rewards_member,
    survey_date, survey_time, satisfaction_rating,
    service_feedback, product_quality, visit_frequency,
    recommend_to_friend, freetext_response,
    COUNT(*) AS occurrence_count
FROM dbo.survey_raw
GROUP BY
    customer_id, email, phone, address, rewards_member,
    survey_date, survey_time, satisfaction_rating,
    service_feedback, product_quality, visit_frequency,
    recommend_to_friend, freetext_response
HAVING COUNT(*) > 1;

-- 0c. Check all distinct values in rewards_member
-- This reveals the casing inconsistency (Yes/YES/yes/No/NO/no)
SELECT rewards_member, COUNT(*) AS cnt
FROM dbo.survey_raw
GROUP BY rewards_member
ORDER BY cnt DESC;

-- 0d. Check all distinct values in service_feedback
-- This reveals mixed casing and trailing punctuation issues
SELECT service_feedback, COUNT(*) AS cnt
FROM dbo.survey_raw
GROUP BY service_feedback
ORDER BY cnt DESC;

-- 0e. Check the 3 different date formats present in survey_date
-- YYYY-MM-DD (standard), YYYY/MM/DD (slash separator), DD-MM-YYYY (day-first)
SELECT DISTINCT survey_date
FROM dbo.survey_raw
WHERE survey_date NOT LIKE '2026-[0-9][0-9]-[0-9][0-9]'
ORDER BY survey_date;

-- 0f. Check for NULL satisfaction_rating
-- These rows need a decision: impute or flag — we will do both
SELECT survey_id, customer_id, satisfaction_rating
FROM dbo.survey_raw
WHERE satisfaction_rating IS NULL;

-- 0g. Check for leading/trailing whitespace in freetext_response
-- Whitespace issues are invisible in raw inspection but will cause string comparison failures downstream
SELECT survey_id, freetext_response
FROM dbo.survey_raw
WHERE freetext_response != LTRIM(RTRIM(freetext_response));


-- ============================================================
-- STEP 1 — CREATE THE CLEAN TARGET TABLE
-- ------------------------------------------------------------
-- We never modify the raw table. This is a core principle in
-- data engineering — always preserve your source layer intact.
-- The clean table has proper data types (DATE instead of
-- VARCHAR for survey_date, BIT for boolean-like flags) and an
-- extra column to flag imputed rows for transparency.
-- ============================================================

IF OBJECT_ID('dbo.survey_clean', 'U') IS NOT NULL
    DROP TABLE dbo.survey_clean;
GO

CREATE TABLE dbo.survey_clean (
    survey_id               INT             NOT NULL,   -- carried over from raw for traceability
    customer_id             INT             NOT NULL,
    email                   VARCHAR(100)    NULL,       -- nullable: not all customers provided email
    phone                   VARCHAR(20)     NULL,       -- nullable: not all customers provided phone
    address                 VARCHAR(100)    NOT NULL,
    rewards_member          VARCHAR(3)      NOT NULL,   -- standardized to 'Yes' / 'No'
    survey_date             DATE            NOT NULL,   -- proper DATE type after format normalization
    survey_time             TIME            NOT NULL,   -- proper TIME type
    satisfaction_rating     TINYINT         NULL,       -- NULL retained where imputation not chosen
    satisfaction_imputed    BIT             NOT NULL DEFAULT 0, -- 1 = value was NULL and median-imputed
    service_feedback        VARCHAR(30)     NOT NULL,   -- standardized to a controlled vocabulary
    product_quality         VARCHAR(10)     NOT NULL,   -- already clean: High / Medium / Low
    visit_frequency         TINYINT         NOT NULL,
    recommend_to_friend     VARCHAR(3)      NOT NULL,   -- Yes / No
    freetext_response       VARCHAR(200)    NULL,

    CONSTRAINT PK_survey_clean PRIMARY KEY (survey_id)
);
GO


-- ============================================================
-- STEP 2 — REMOVE EXACT DUPLICATE ROWS
-- ------------------------------------------------------------
-- Problem: 3 pairs of fully identical rows exist (customer_ids
-- 8, 25, 71). These are likely system re-submissions or import
-- errors — not genuine repeat visits (same date + same time).
--
-- Why CTE with ROW_NUMBER?
-- We cannot use a plain DELETE with DISTINCT because SQL Server
-- needs a way to reference one specific copy of the duplicate.
-- ROW_NUMBER() assigns a sequence per duplicate group ordered
-- by survey_id, so we keep row_num = 1 (the first occurrence)
-- and delete row_num > 1. This is the standard safe approach.
--
-- Note: customer_ids 1, 2, 51 also appear twice but have
-- different survey_time values — those are legitimate repeat
-- visits from the same customer on the same day. We keep those.
-- ============================================================

WITH cte_duplicates AS (
    SELECT
        survey_id,
        ROW_NUMBER() OVER (
            PARTITION BY
                customer_id, email, phone, address, rewards_member,
                survey_date, survey_time, satisfaction_rating,
                service_feedback, product_quality, visit_frequency,
                recommend_to_friend, freetext_response
            ORDER BY survey_id
        ) AS row_num
    FROM dbo.survey_raw
)
DELETE FROM cte_duplicates
WHERE row_num > 1;

-- Verification: should now be 103 rows (106 - 3 duplicates removed)
SELECT COUNT(*) AS rows_after_dedup FROM dbo.survey_raw;
GO


-- ============================================================
-- STEP 3 — NORMALIZE survey_date TO A STANDARD DATE FORMAT
-- ------------------------------------------------------------
-- Problem: The survey_date column has 3 different formats:
--   Format A: YYYY-MM-DD  (e.g. 2026-01-03)  — 103 rows, standard
--   Format B: YYYY/MM/DD  (e.g. 2026/01/05)  —   2 rows, slash sep
--   Format C: DD-MM-YYYY  (e.g. 01-06-2026)  —   1 row,  day-first
--
-- Why not just CAST directly?
-- SQL Server's implicit CAST only handles YYYY-MM-DD cleanly.
-- Format B (slash) would cast fine in some collations but is
-- unreliable. Format C (day-first) would silently misparse —
-- '01-06-2026' would be read as Jan 6 instead of June 1.
--
-- Solution: We use CASE + REPLACE + explicit style codes in
-- CONVERT() to handle each format deterministically:
--   Style 120 = YYYY-MM-DD (ISO)
--   Style 103 = DD/MM/YYYY (British) — we reformat C to this first
--
-- This step updates the raw table's survey_date column in-place
-- to a clean YYYY-MM-DD string before we load into survey_clean.
-- (survey_date is still VARCHAR in survey_raw, so this is safe)
-- ============================================================

-- Fix Format B: replace slash separator with hyphen
-- YYYY/MM/DD  →  YYYY-MM-DD
UPDATE dbo.survey_raw
SET survey_date = REPLACE(survey_date, '/', '-')
WHERE survey_date LIKE '____/__/__';

-- Fix Format C: reformat DD-MM-YYYY to YYYY-MM-DD
-- We extract day, month, year as substrings and reconstruct
UPDATE dbo.survey_raw
SET survey_date =
    SUBSTRING(survey_date, 7, 4) + '-' +   -- year  (chars 7-10)
    SUBSTRING(survey_date, 4, 2) + '-' +   -- month (chars 4-5)
    SUBSTRING(survey_date, 1, 2)           -- day   (chars 1-2)
WHERE survey_date LIKE '__-__-____';

-- Verification: all dates should now be in YYYY-MM-DD format only
SELECT DISTINCT survey_date
FROM dbo.survey_raw
WHERE survey_date NOT LIKE '____-__-__'
ORDER BY survey_date;
-- Expected: 0 rows returned (no remaining non-standard dates)
GO


-- ============================================================
-- STEP 4 — LOAD CLEANED DATA INTO dbo.survey_clean
-- ------------------------------------------------------------
-- This is the main transformation INSERT. All cleaning logic
-- is applied inline here as expressions so the target table
-- receives fully standardized data from day one.
--
-- Each transformation is explained inline below.
-- ============================================================

INSERT INTO dbo.survey_clean (
    survey_id,
    customer_id,
    email,
    phone,
    address,
    rewards_member,
    survey_date,
    survey_time,
    satisfaction_rating,
    satisfaction_imputed,
    service_feedback,
    product_quality,
    visit_frequency,
    recommend_to_friend,
    freetext_response
)
SELECT

    -- survey_id: carry over as-is for row-level traceability back to raw
    survey_id,

    -- customer_id: no transformation needed, already an INT
    customer_id,

    -- email: LTRIM + RTRIM to strip accidental whitespace.
    -- Kept nullable — not every customer provided contact info.
    NULLIF(LTRIM(RTRIM(email)), '')         AS email,

    -- phone: same whitespace treatment as email.
    -- NULLIF converts empty string '' to NULL for consistency —
    -- an empty string and NULL mean the same thing here (no phone on file)
    NULLIF(LTRIM(RTRIM(phone)), '')         AS phone,

    -- address: LTRIM + RTRIM only, no structural changes needed
    LTRIM(RTRIM(address))                   AS address,

    -- rewards_member: normalize all case variants to proper 'Yes' / 'No'
    -- Source has: Yes, YES, yes → 'Yes' | No, NO, no → 'No'
    -- UPPER() first collapses all variants, then we map to title case
    CASE UPPER(LTRIM(RTRIM(rewards_member)))
        WHEN 'YES' THEN 'Yes'
        WHEN 'NO'  THEN 'No'
        ELSE            'No'    -- fallback for any unexpected value
    END                                     AS rewards_member,

    -- survey_date: convert from VARCHAR (now guaranteed YYYY-MM-DD)
    -- to proper DATE type using style 120 (ISO standard)
    CONVERT(DATE, survey_date, 120)         AS survey_date,

    -- survey_time: convert from VARCHAR 'HH:MM' to TIME type
    CAST(survey_time AS TIME)               AS survey_time,

    -- satisfaction_rating: handle the 2 NULL rows.
    -- Strategy: impute with the dataset median (3).
    -- Median is preferred over mean for ordinal rating scales
    -- because it is not pulled by extreme values at either end.
    COALESCE(satisfaction_rating, 3)        AS satisfaction_rating,

    -- satisfaction_imputed: flag rows where we filled in the NULL.
    -- This is a transparency column — analysts downstream will know
    -- which ratings are real vs imputed. Never silently hide imputation.
    CASE WHEN satisfaction_rating IS NULL THEN 1 ELSE 0 END
                                            AS satisfaction_imputed,

    -- service_feedback: this is the messiest column.
    -- Problems: mixed casing, trailing punctuation, synonyms
    -- ('average service' / 'Average' / 'Average service' all mean the same thing)
    --
    -- We standardize to a fixed 4-value controlled vocabulary:
    --   'Poor'      covers: Poor service, Poor service (trailing space)
    --   'Average'   covers: average service, Average, Average service
    --   'Good'      covers: Good service, good service, Good Service, Great service
    --   'Excellent' covers: Excellent, Excellent!
    --
    -- Why controlled vocab?
    -- Free-text feedback categories are useless for aggregation and
    -- dashboards. Mapping to a fixed set makes GROUP BY, pie charts,
    -- and KPI calculations reliable and consistent.
    CASE
        WHEN LOWER(LTRIM(RTRIM(service_feedback))) LIKE '%poor%'      THEN 'Poor'
        WHEN LOWER(LTRIM(RTRIM(service_feedback))) LIKE '%excellent%' THEN 'Excellent'
        WHEN LOWER(LTRIM(RTRIM(service_feedback))) LIKE '%good%'
          OR LOWER(LTRIM(RTRIM(service_feedback))) LIKE '%great%'     THEN 'Good'
        WHEN LOWER(LTRIM(RTRIM(service_feedback))) LIKE '%average%'   THEN 'Average'
        ELSE LTRIM(RTRIM(service_feedback))  -- fallback: keep as-is if nothing matches
    END                                     AS service_feedback,

    -- product_quality: already clean (High / Medium / Low, consistent casing)
    -- Just trim whitespace as a precaution
    LTRIM(RTRIM(product_quality))           AS product_quality,

    -- visit_frequency: already a clean integer (1-4), no transformation needed
    visit_frequency,

    -- recommend_to_friend: already clean (Yes / No, consistent casing)
    -- Trim as a precaution
    LTRIM(RTRIM(recommend_to_friend))       AS recommend_to_friend,

    -- freetext_response: strip leading and trailing whitespace.
    -- Several rows have multi-space padding at the start (e.g. '  Loved the latte').
    -- We do not alter the content itself — free text is subjective and
    -- should not be modified beyond basic whitespace cleanup.
    NULLIF(LTRIM(RTRIM(freetext_response)), '')  AS freetext_response

FROM dbo.survey_raw;
GO


-- ============================================================
-- STEP 5 — POST-LOAD VERIFICATION CHECKS
-- ------------------------------------------------------------
-- Always validate after loading. These checks confirm that
-- every transformation behaved as expected before you hand
-- this table to anyone downstream.
-- ============================================================

-- 5a. Row count check
-- Expecting 103 (106 raw - 3 exact duplicates removed in Step 2)
SELECT COUNT(*) AS total_clean_rows FROM dbo.survey_clean;

-- 5b. Confirm no unexpected values remain in rewards_member
-- Should only return 'Yes' and 'No'
SELECT rewards_member, COUNT(*) AS cnt
FROM dbo.survey_clean
GROUP BY rewards_member;

-- 5c. Confirm service_feedback is now only 4 controlled values
-- Should return: Poor, Average, Good, Excellent — nothing else
SELECT service_feedback, COUNT(*) AS cnt
FROM dbo.survey_clean
GROUP BY service_feedback
ORDER BY cnt DESC;

-- 5d. Confirm all survey_date values are valid DATEs
-- If any conversion failed silently, they would show as NULL
SELECT COUNT(*) AS null_dates
FROM dbo.survey_clean
WHERE survey_date IS NULL;

-- 5e. Confirm satisfaction_rating has no NULLs left after imputation
-- Expected: 0 NULLs
SELECT COUNT(*) AS null_ratings
FROM dbo.survey_clean
WHERE satisfaction_rating IS NULL;

-- 5f. Check how many rows were imputed — for documentation purposes
SELECT COUNT(*) AS imputed_rating_count
FROM dbo.survey_clean
WHERE satisfaction_imputed = 1;

-- 5g. Confirm freetext_response has no leading/trailing whitespace
-- Expected: 0 rows returned
SELECT survey_id, freetext_response
FROM dbo.survey_clean
WHERE freetext_response != LTRIM(RTRIM(freetext_response));

-- 5h. Confirm no empty strings slipped through as non-NULL values
-- NULLIF should have converted '' to NULL in Step 4
SELECT
    SUM(CASE WHEN email             = '' THEN 1 ELSE 0 END) AS empty_email,
    SUM(CASE WHEN phone             = '' THEN 1 ELSE 0 END) AS empty_phone,
    SUM(CASE WHEN freetext_response = '' THEN 1 ELSE 0 END) AS empty_freetext
FROM dbo.survey_clean;

-- 5i. Check satisfaction_rating distribution
-- Gives a quick sense of overall data shape
SELECT
    satisfaction_rating,
    COUNT(*)                                            AS response_count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()
         AS DECIMAL(5,2))                              AS pct_of_total
FROM dbo.survey_clean
GROUP BY satisfaction_rating
ORDER BY satisfaction_rating;

-- 5j. Preview the final clean table — first 20 rows
SELECT TOP 20 * FROM dbo.survey_clean ORDER BY survey_id;