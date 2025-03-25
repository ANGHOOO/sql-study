# Write your MySQL query statement below
SELECT
    *
FROM
    Cinema
WHERE
    Cinema.id % 2 = 1
    AND Cinema.description != 'boring'
ORDER BY
    Cinema.rating DESC;
