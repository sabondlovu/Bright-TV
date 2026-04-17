-- Databricks notebook source
--This is to see annalyse my data, to verify that the data imported is correct and accuarate 
SELECT*
FROM workspace.default.viewership;


SELECT
    UserID,
    Channel2,
    --- Thsis CASE STATEMENT is to categorise the items into categories, have them more spicified and more readable
    CASE
        WHEN Channel2 IN ('CNN', 'BBC', 'Sky News', 'eNCA') THEN 'News'
        WHEN Channel2 IN ('ESPN', 'SuperSport', 'Sky Sports', 'SuperSport Blitz', 'Supersport Live Events', 'ICC Cricket World Cup 2011') THEN 'Sports'
        WHEN Channel2 IN ('MTV', 'Channel O', 'Trace TV') THEN 'Music'
        WHEN Channel2 IN ('Cartoon Network', 'Disney', 'Nickelodeon', 'Boomerang') THEN 'Kids'
        WHEN Channel2 IN ('HBO', 'Netflix', 'Showmax', 'Africa Magic', 'Vuzu', 'E! Entertainment', 'KykNet','M-Net') THEN 'Entertainment'
        ELSE 'Other'
    END AS Channel_Category,
  

     RecordDate2,

    --- Here we are converting UCT time to SAST, to be more broad 
    DATE_FORMAT(from_utc_timestamp(to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'yyyy-MM-dd') AS Record_Date,
    DATE_FORMAT(from_utc_timestamp(to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'MMMM') AS Month_Name,
    DATE_FORMAT(from_utc_timestamp(to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'EEEE') AS DayOfWeek,

--- This is to specify the days of the week into Weekdays and Weekends
    CASE 
        WHEN DATE_FORMAT(from_utc_timestamp(to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'EEEE') IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,

--- I covert to timestamp and adjust from UTC to SAST (time related columns).
    DATE_FORMAT(from_utc_timestamp(to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm') AS Record_Time,

--- I use case statements to categories time into Morning, Afternoon, Evenings & Night.  
    CASE 
        WHEN HOUR(from_utc_timestamp(to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN HOUR(from_utc_timestamp(to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(from_utc_timestamp(to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS Time_Category,

    Duration2,

--- I use this segment to get the actual duration because the Duration2 column is a bit too long.
    DATE_FORMAT(Duration2, 'HH:mm:ss') AS Duration_Clean,
    HOUR(Duration2) AS Hours,
    MINUTE(Duration2) AS Minutes,
    SECOND(Duration2) AS Seconds

FROM viewership;


--------
CREATE OR REPLACE VIEW viewership_for_dashboard AS
SELECT 
    *,  
    
    -- 1. Create a "Looker-friendly" Date column
    CAST(RecordDate2 AS TIMESTAMP) AS ViewDate_Clean,
    
    -- 2. Create a "Looker-friendly" Numeric Duration
    (CAST(split(Duration2, ':')[0] AS INT) * 3600) + 
    (CAST(split(Duration2, ':')[1] AS INT) * 60) + 
    CAST(split(Duration2, ':')[2] AS INT) AS Duration_Seconds,
    
    -- 3.  Comparison Logic for better understanding 
    CASE 
        WHEN Channel2 IN ('Supersport Live Events', 'ICC Cricket World Cup 2011', 'Channel O') THEN 'Top 3 Channels'
        ELSE 'Other Channels'
    END AS Comparison_Group
FROM viewership; 

