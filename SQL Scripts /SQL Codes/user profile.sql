-- Databricks notebook source

------BrightTV User Profiles Data Exploration.

SELECT*
FROM workspace.default.user_profiles;


---This is to show the youngest and the oldest person to use the service
SELECT
MIN(age) AS youngest,
MAX(age) AS oldest
FROM workspace.default.user_profiles;


SELECT
  MIN(Age) AS youngest_age,
  MAX(Age) AS oldest_age
FROM user_profiles;

-----------------------------------------

---We are here to remove the spaces between the words in the name column

UPDATE user_profiles
SET 
  `Social Media Handle` = REPLACE(`Social Media Handle`, ' ', ''),
  `Email` = REPLACE(Email, ' ', ''),
  `Name` = REPLACE(Name, ' ', '');

------------
SELECT 
    UserID,
    Name,
    Surname,
    Email,
    Gender,
    Race,
    Province,
    `Social Media Handle`,
    Age,
    CASE
        WHEN Age < 13 THEN 'Child'
        WHEN Age BETWEEN 13 AND 17 THEN 'Teen'
        WHEN Age BETWEEN 18 AND 34 THEN 'Young Adult'
        WHEN Age BETWEEN 35 AND 59 THEN 'Adult'
        ELSE 'Senior'
    END AS Age_Group,
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 24 THEN '18–24'
        WHEN Age BETWEEN 25 AND 34 THEN '25–34'
        WHEN Age BETWEEN 35 AND 44 THEN '35–44'
        WHEN Age BETWEEN 45 AND 54 THEN '45–54'
        WHEN Age BETWEEN 55 AND 64 THEN '55–64'
        ELSE '65+'
    END AS Age_Category
FROM user_profiles
LIMIT 10;



---THis is to make permanent change sto the table 
-- 1. Add Age_Group and Update logic
ALTER TABLE user_profiles
ADD COLUMNS IF NOT EXISTS (Age_Group STRING);


UPDATE user_profiles
SET Age_Group = CASE
    WHEN Age < 13 THEN 'Child'
    WHEN Age BETWEEN 13 AND 17 THEN 'Teen'
    WHEN Age BETWEEN 18 AND 34 THEN 'Young Adult'
    WHEN Age BETWEEN 35 AND 59 THEN 'Adult'
    ELSE 'Senior'
END;


-- 2. Add Age_Category and Update logic
ALTER TABLE user_profiles
ADD COLUMNS IF NOT EXISTS (Age_Category STRING);


UPDATE user_profiles
SET Age_Category = CASE
    WHEN Age < 18 THEN 'Under 18'
    WHEN Age BETWEEN 18 AND 24 THEN '18–24'
    WHEN Age BETWEEN 25 AND 34 THEN '25–34'
    WHEN Age BETWEEN 35 AND 44 THEN '35–44'
    WHEN Age BETWEEN 45 AND 54 THEN '45–54'
    WHEN Age BETWEEN 55 AND 64 THEN '55–64'
    ELSE '65+'
END;
----sorting out the table name
SELECT
    UserID,
    Name,
    Surname,
    Gender,
    Race,
    Age,
    Age_Group,
    Age_Category,
    Email,
   'Social Media Handle',
    Province
FROM user_profiles;
