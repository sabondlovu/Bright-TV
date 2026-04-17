-- Databricks notebook source
--This is an ettempt to joing the two tables and analyse them 

SELECT
    -- USER PROFILE DETAILS
    ---To define my alliases for the User profile table
    --I also used CONCAT to join the name and surname into one 
    a.UserID,
    CONCAT(a.Name, ' ', a.Surname) AS Full_Name,
    a.Gender,
    a.Race,
    a.Age,
    --- This for categorising the age group, so that they are orderly and easy to read 
    CASE
        WHEN a.Age < 13 THEN 'Child'
        WHEN a.Age BETWEEN 13 AND 17 THEN 'Teen'
        WHEN a.Age BETWEEN 18 AND 34 THEN 'Young Adult'
        WHEN a.Age BETWEEN 35 AND 59 THEN 'Adult'
        ELSE 'Senior'
    END AS Age_Group,
    CASE
        WHEN a.Age < 18 THEN 'Under 18'
        WHEN a.Age BETWEEN 18 AND 24 THEN '18–24'
        WHEN a.Age BETWEEN 25 AND 34 THEN '25–34'
        WHEN a.Age BETWEEN 35 AND 44 THEN '35–44'
        WHEN a.Age BETWEEN 45 AND 54 THEN '45–54'
        WHEN a.Age BETWEEN 55 AND 64 THEN '55–64'
        ELSE '65+'
    END AS Age_Category,
    REPLACE(a.Email, '  ', '') AS Clean_Email,
    REPLACE(a.`Social Media Handle`, '  ', '') AS Clean_Handle, 
    REPLACE(a.Name, '  ', '') AS Clean_Name,
    a.Province,
    CASE 
        WHEN a.UserID IS NOT NULL THEN 'Active'
        ELSE 'Inactive'
    END AS Account_Status,

    -- VIEWERSHIP DETAILS
    -- In this database we are going to use to see the trends of the viewers and what they wtach the most and and who watches what at what time
    b.Channel2,
    CASE
        WHEN b.Channel2 IN ('CNN', 'BBC', 'Sky News', 'eNCA') THEN 'News'
        WHEN b.Channel2 IN ('ESPN', 'SuperSport', 'Sky Sports', 'SuperSport Blitz', 'Supersport Live Events', 'ICC Cricket World Cup 2011') THEN 'Sports'
        WHEN b.Channel2 IN ('MTV', 'Channel O', 'Trace TV') THEN 'Music'
        WHEN b.Channel2 IN ('Cartoon Network', 'Disney', 'Nickelodeon', 'Boomerang') THEN 'Kids'
        WHEN b.Channel2 IN ('HBO', 'Netflix', 'M-Net', 'Showmax', 'Africa Magic', 'Vuzu', 'E! Entertainment', 'KykNet') THEN 'Entertainment'
        ELSE 'Other'
    END AS Channel_Category,

    b.RecordDate2,
    DATE_FORMAT(from_utc_timestamp(to_timestamp(b.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'yyyy-MM-dd') AS Record_Date,
    DATE_FORMAT(from_utc_timestamp(to_timestamp(b.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'MMMM') AS Month_Name,
    DATE_FORMAT(from_utc_timestamp(to_timestamp(b.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'EEEE') AS DayOfWeek,

    CASE 
        WHEN DATE_FORMAT(from_utc_timestamp(to_timestamp(b.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'EEEE') IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,

    DATE_FORMAT(from_utc_timestamp(to_timestamp(b.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm') AS Record_Time,

    CASE 
        WHEN HOUR(from_utc_timestamp(to_timestamp(b.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN HOUR(from_utc_timestamp(to_timestamp(b.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(from_utc_timestamp(to_timestamp(b.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS Time_Category,

    b.Duration2,
    DATE_FORMAT(b.Duration2, 'HH:mm:ss') AS Duration_Clean,
    HOUR(b.Duration2) AS Hours,
    MINUTE(b.Duration2) AS Minutes,
    SECOND(b.Duration2) AS Seconds

FROM workspace.default.user_profiles AS a
FULL OUTER JOIN workspace.default.viewership AS b
    ON a.UserID = b.UserID;
