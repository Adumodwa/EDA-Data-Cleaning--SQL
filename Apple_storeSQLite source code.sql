Create Table apple_description_combined As

Select * From appleStore_description1

union  ALL

Select * From appleStore_description2

Union ALL

select * from appleStore_description3

union ALL

select * FROM appleStore_description4

**EXPLORATORY DATA ANALYSIS**

-- Check the number of unique apps in boths tablesAppleStore

Select count(distinct id) as Unique_IDs
FROM AppleStore

Select count(DISTINCT id) as Unique_IDs
From apple_description_combined

--Check for any missing values in key fields

Select Count(*) as Missing_values
From AppleStore
where track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

Select Count(*) as Missing_values
From apple_description_combined
where app_desc IS NULL

--Find out number of apps per genre

SELECT prime_genre, Count(*) as NumApps
from AppleStore
GROUP By prime_genre
Order By NumApps DESC

--Get an overview of apps rating

Select MIN(user_rating) AS MinRating,
       MAX(user_rating) as MaxRating,
       AVG(user_rating) as AvgRating
from AppleStore

**DATA ANALYSIS**

--Determine whether paid apps have higher ratings than the free apps

Select 
      case when price > 0 then 'Paid'
      else 'Free'
    end as App_type,
    Avg(user_rating) as Avg_rating
From AppleStore
Group By App_type

--Check if apps with more supporting languages have high ratinngs

SELECT
      case when lang_num < 10 then '<10 languages'
           when lang_num between 10 and 30 then '10-30 languages'
           else '>30 languges'
       end As languages_bucket,
       Avg(user_rating) as Avg_Rating
From AppleStore
Group by languages_bucket
Order By Avg_Rating DESC

--Check genre with lower ratings

Select prime_genre,
       Avg(user_rating) as Avg_Rating
From AppleStore
Group By prime_genre
Order By Avg_Rating
Limit 10

--Check if there is correlation between the length of the apps descriptions and the user rating

SELECT
      case when length(b.app_desc) < 500 then 'Short'
           when length(b.app_desc) between 500 and 1000 then 'Medium'
           else 'Long'
       end as description_length_bucket,
       Avg(a.user_rating) as Avg_rating
from 
    AppleStore a
JOIN
    apple_description_combined b 
ON
    a.id = b.id
Group By description_length_bucket
Order By Avg_rating DESC

--Check top rated-apps for each genre

sELECT
  prime_genre, 
  track_name, 
  user_rating
FROM (
      SELECT
           prime_genre,
           track_name,
           user_rating,
           RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) As rank
      FROM applestore) AS a
WHERE
a.rank = 1