-- Write your PostgreSQL query statement below
WITH temp_01 AS (
    SELECT
        *,
        coalesce(referee_id, -1) AS filled_referee
    FROM
        Customer
)
SELECT
    name
FROM
    temp_01
WHERE
    filled_referee != 2
