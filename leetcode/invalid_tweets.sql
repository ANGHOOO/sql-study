-- Write your PostgreSQL query statement below
SELECT
    tweet_id
FROM
    TWEETS
WHERE
    LENGTH(content) > 15
