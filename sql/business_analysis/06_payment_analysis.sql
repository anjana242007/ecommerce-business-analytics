USE ecommerce_customer_intelligence;

-- TASK 1:
-- Payment Method Performance

SELECT
    op.payment_type,
    COUNT(DISTINCT op.order_id) AS total_orders,
    COUNT(*) AS total_payment_records,
    ROUND(SUM(op.payment_value), 2) AS total_payment_amount,
    ROUND(AVG(op.payment_value), 2) AS average_payment_amount
FROM olist_order_payments_dataset AS op
JOIN olist_orders_dataset AS o
    ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY op.payment_type
ORDER BY total_payment_amount DESC;

-- TASK 2:
-- Credit Card Installment Behaviour

SELECT
    op.payment_installments,
    COUNT(DISTINCT op.order_id) AS total_orders,
    COUNT(*) AS total_payment_records,
    ROUND(SUM(op.payment_value), 2) AS total_payment_amount,
    ROUND(AVG(op.payment_value), 2) AS average_payment_amount
FROM olist_order_payments_dataset AS op
JOIN olist_orders_dataset AS o
    ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
    AND op.payment_type = 'credit_card'
GROUP BY op.payment_installments
ORDER BY op.payment_installments;

-- TASK 3:
-- Payment vs Order Value Reconciliation

WITH payment_summary AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment
    FROM olist_order_payments_dataset
    GROUP BY order_id
),
order_summary AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS total_order_value
    FROM olist_order_items_dataset
    GROUP BY order_id
)
SELECT
    COUNT(*) AS total_orders_compared,
    SUM(
        CASE
            WHEN ABS(p.total_payment - o.total_order_value) <= 1
                THEN 1
            ELSE 0
        END
    ) AS matched_orders,
    SUM(
        CASE
            WHEN ABS(p.total_payment - o.total_order_value) > 1
                THEN 1
            ELSE 0
        END
    ) AS mismatched_orders,
    ROUND(
        SUM(
            CASE
                WHEN ABS(p.total_payment - o.total_order_value) <= 1
                    THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS matched_percentage
FROM payment_summary AS p
JOIN order_summary AS o
    ON p.order_id = o.order_id;

-- TASK 4:
-- Largest Payment Reconciliation Differences

WITH payment_summary AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment
    FROM olist_order_payments_dataset
    GROUP BY order_id
),
order_summary AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS total_order_value
    FROM olist_order_items_dataset
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.order_status,
    ROUND(p.total_payment, 2) AS total_payment,
    ROUND(os.total_order_value, 2) AS total_order_value,
    ROUND(
        p.total_payment - os.total_order_value, 2
    ) AS payment_difference
FROM olist_orders_dataset AS o
JOIN payment_summary AS p
    ON o.order_id = p.order_id
JOIN order_summary AS os
    ON o.order_id = os.order_id
WHERE ABS(p.total_payment - os.total_order_value) > 1
ORDER BY ABS(p.total_payment - os.total_order_value) DESC
LIMIT 20;