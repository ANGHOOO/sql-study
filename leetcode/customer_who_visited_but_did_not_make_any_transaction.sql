-- Write your PostgreSQL query statement below
WITH temp_a AS (
    SELECT
        Visits.visit_id,
        Visits.customer_id,
        Transactions.transaction_id,
        Transactions.amount
    FROM
        Visits
        LEFT JOIN Transactions ON Visits.visit_id = Transactions.visit_id
    WHERE
        transaction_id is null
)
SELECT
    customer_id,
    COUNT(visit_id) AS count_no_trans
FROM
    temp_a
GROUP BY
    customer_id
