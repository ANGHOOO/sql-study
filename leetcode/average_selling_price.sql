# Write your MySQL query statement below
WITH A AS (
    SELECT
        p.product_id,
        p.start_date,
        p.end_date,
        p.price,
        u.purchase_date,
        u.units,
        p.price * u.units AS total_amount
    FROM
        Prices AS p
        LEFT JOIN UnitsSold AS u ON p.product_id = u.product_id
        AND u.purchase_date BETWEEN p.start_date AND p.end_date
)
SELECT
    A.product_id,
    CASE
        WHEN ROUND(SUM(A.total_amount) / SUM(units), 2) IS NULL THEN 0 
        ELSE ROUND(SUM(A.total_amount) / SUM(units), 2)
    END AS average_price
FROM
    A
GROUP BY
    A.product_id
