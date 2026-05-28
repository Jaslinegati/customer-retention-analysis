-- Revenue vs customer satisfaction by product category
-- Identifies categories with high revenue but low review scores
-- (potential fulfilment or quality issues worth investigating)

SELECT
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    COUNT(DISTINCT oi.order_id)                                          AS total_orders,
    ROUND(SUM(oi.price)::NUMERIC, 2)                                    AS total_revenue,
    ROUND(AVG(oi.price)::NUMERIC, 2)                                    AS avg_item_price,
    ROUND(AVG(r.review_score)::NUMERIC, 2)                              AS avg_review_score,
    COUNT(CASE WHEN r.review_score <= 2 THEN 1 END)                     AS low_score_count,
    ROUND(
        100.0 * COUNT(CASE WHEN r.review_score <= 2 THEN 1 END)
              / NULLIF(COUNT(r.review_score), 0),
        1
    )                                                                    AS low_score_pct
FROM order_items oi
JOIN products p          ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
                         ON p.product_category_name = t.product_category_name
JOIN order_reviews r     ON oi.order_id = r.order_id
JOIN orders o            ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
HAVING COUNT(DISTINCT oi.order_id) > 100
ORDER BY total_revenue DESC;
