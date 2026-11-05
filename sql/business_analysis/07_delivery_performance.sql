USE ecommerce_customer_intelligence;

-- TASK 1:
-- Actual Delivery Time
SELECT
    COUNT(*) AS delivered_orders,
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ), 2
    ) AS average_delivery_days,
    MIN(
        DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    ) AS minimum_delivered_days,
    MAX(
        DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    ) AS maximum_delivery_days
FROM olist_orders_dataset
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL;

-- TASK 2:
-- Actual vs Estimated Delivery
SELECT
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN order_delivered_customer_date
                 <= order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delivered_on_time,
    SUM(
        CASE
            WHEN order_delivered_customer_date
                 > order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delivered_late,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date
                     <= order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS on_time_delivery_percentage
FROM olist_orders_dataset
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL;

-- TASK 3:
-- Average Delay for Late Deliveries
SELECT
    COUNT(*) AS late_orders,
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_estimated_delivery_date
            )
        ), 2
    ) AS average_delay_days,
    MIN(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS minimum_delay_days,
    MAX(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS maximum_delay_days
FROM olist_orders_dataset
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date > order_estimated_delivery_date;

-- TASK 4:
-- Late Delivery Rate by State

SELECT
    c.customer_state,
    COUNT(o.order_id) AS delivered_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date
                 > o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date
                     > o.order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(o.order_id),
        2
    ) AS late_delivery_percentage
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(o.order_id) >= 100
ORDER BY late_delivery_percentage DESC;

-- TASK 5:
-- Top 20 Most Delayed Orders
SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    DATEDIFF(
        order_delivered_customer_date,
        order_estimated_delivery_date
    ) AS delay_days
FROM olist_orders_dataset
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date > order_estimated_delivery_date
ORDER BY delay_days DESC
LIMIT 20;

-- TASK 6:
-- Delayed Orders by Actual Delivery Date

SELECT
    DATE(order_delivered_customer_date) AS actual_delivery_date,
    COUNT(*) AS delayed_orders,
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_estimated_delivery_date
            )
        ), 2
    ) AS average_delay_days,
    MAX(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS maximum_delay_days
FROM olist_orders_dataset
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date > order_estimated_delivery_date
GROUP BY DATE(order_delivered_customer_date)
HAVING COUNT(*) >= 5
ORDER BY delayed_orders DESC
LIMIT 20;