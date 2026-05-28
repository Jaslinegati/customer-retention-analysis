-- Repeat purchase rate and average orders per customer
-- Key retention KPI: what % of customers ever placed more than one order?

WITH order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    COUNT(*)                                                                  AS total_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)                       AS repeat_customers,
    ROUND(100.0 * SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
                / COUNT(*), 2)                                                AS repeat_rate_pct,
    ROUND(AVG(total_orders), 2)                                              AS avg_orders_per_customer,
    MAX(total_orders)                                                         AS max_orders_single_customer
FROM order_counts;
