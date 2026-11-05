-- Project: E-Commerce Business Analytics
-- File: data_quality_checks.sql
-- Purpose: Validate data quality across the datasets


USE ecommerce_customer_intelligence;

-- TASK 1: COUNT RECORDS IN ALL 9 TABLES

-- 1.ORDERS
SELECT COUNT(*) AS total_rows
FROM olist_orders_dataset;

-- 2.CUSTOMERS
SELECT COUNT(*) AS total_rows
FROM olist_customers_dataset;

-- 3.GEOLOCATION
SELECT COUNT(*) AS total_rows
FROM olist_geolocation_dataset;

-- 4.ORDER ITEMS
SELECT COUNT(*) AS total_rows
FROM olist_order_items_dataset;

-- 5.PAYMENTS
SELECT COUNT(*)AS total_rows
FROM olist_order_payments_dataset;

-- 6.REVIEWS
SELECT COUNT(*)AS total_rows
FROM olist_order_reviews_dataset;

-- 7.PRODUCTS
SELECT COUNT(*) AS total_rows
FROM olist_products_dataset;

-- 8.SELLERS
SELECT COUNT(*) AS total_rows
FROM olist_sellers_dataset;

-- 9.PRODUCT CATEGORY TRANSLATION
SELECT COUNT(*) AS total_rows
FROM product_category_name;


-- TASK 2: CHECK DUPLICATE RECORDS

-- 1. CHECK DUPLICATE CUSTOMER IDs
SELECT customer_id,
    COUNT(*)AS duplicate_count
FROM olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*)>1;

-- 2. CHECK EXACT DUPLICATE GEOGRAPHIC RECORDS
SELECT geolocation_zip_code_prefix,
       geolocation_lat,
       geolocation_lng,
       geolocation_city,
       geolocation_state,
       COUNT(*) AS duplicate_count
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix,
       geolocation_lat,
       geolocation_lng,
       geolocation_city,
       geolocation_state
HAVING COUNT(*) >1
ORDER BY duplicate_count DESC
LIMIT 10;

-- 3. COUNT REPEATED GEOGRAPHIC RECORDS
SELECT
    SUM(duplicate_count - 1) AS extra_repeated_records
FROM (
    SELECT COUNT(*) AS duplicate_count
    FROM olist_geolocation_dataset
    GROUP BY
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    HAVING COUNT(*) > 1
) AS duplicate_groups;

-- 4.CHECK DUPLICATE ORDER IDS
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 5.CHECK DUPLICATE PRODUCT IDS
SELECT
    product_id,
    COUNT(*)AS duplicate_count
FROM olist_products_dataset
GROUP BY product_id
HAVING COUNT(*)>1;

-- 6.CHECKS DUPLICATE SELLER IDS
SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM olist_sellers_dataset
GROUP BY seller_id
HAVING COUNT(*)>1;

-- 7.CHECK DUPLICATES ORDER-ITEM COMBINATIONS
SELECT
    order_id,
    order_item_id,
    COUNT(*)AS duplicate_count
FROM olist_order_items_dataset
GROUP BY order_id,order_item_id
HAVING COUNT(*) >1;

-- 8.CHECK DUPLICATE PAYMENTS SEQUENCES
SELECT
    order_id,
    payment_sequential,
    COUNT(*)AS duplicate_count
FROM olist_order_payments_dataset
GROUP BY order_id,payment_sequential
HAVING COUNT(*)>1;

-- 9.CHECK DUPLICATE REVIEW IDS
SELECT
    review_id,
    COUNT(*)AS duplicate_count
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*)>1
ORDER BY duplicate_count DESC
LIMIT 10;

-- 10.CHECK WEATHER REPEATED REVIEW IDS BELONG TO DIFFERENT ORDERS
SELECT
    review_id,
    COUNT(DISTINCT order_id) AS different_orders,
    COUNT(*) AS total_records
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1
LIMIT 10;

-- 11.CHECK DUPLICATE RECORDS ACROSS ALL THE COLUMNS
SELECT COUNT(*) AS identical_duplicate_groups
FROM (
    SELECT
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp,
        COUNT(*) AS record_count
    FROM olist_order_reviews_dataset
    GROUP BY
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp
    HAVING COUNT(*) > 1
) AS duplicate_groups;

-- 12.CHECK DUPLICATE PRODUCT CATEGORY NAMES
SELECT
    product_category_name,
    COUNT(*) AS occurrence_count
FROM product_category_name
GROUP BY product_category_name
HAVING COUNT(*) > 1;

-- TASK 3: MISSING VALUE CHECKS --------------------------------------
-- 1. CHECK MISSING VALUES IN ORDERS TABLE
SELECT
    SUM(order_id IS NULL) AS null_order_id,
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(order_status IS NULL) AS null_order_status,
    SUM(order_purchase_timestamp IS NULL) AS null_purchase_timestamp,
    SUM(order_approved_at IS NULL) AS null_approved_at,
    SUM(order_delivered_carrier_date IS NULL) AS null_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS null_delivered_date,
    SUM(order_estimated_delivery_date IS NULL) AS null_estimated_date
FROM olist_orders_dataset;

-- 2. CHECK MISSING TIMESTAMPS BY ORDER STATUS -------------------
SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(order_approved_at IS NULL) AS missing_approval,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_delivery_date
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

-- 3.INVESTIGATE UNEXPECTED ORDER STATUS RECORD

SELECT *
FROM olist_orders_dataset
WHERE order_status = 'order_status';

-- 4.CHECK MISSING VALUES IN CUSTOMERS TABLE
SELECT
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(customer_unique_id IS NULL) AS missing_customer_unique_id,
    SUM(customer_zip_code_prefix IS NULL) AS missing_zip_code,
    SUM(customer_city IS NULL) AS missing_city,
    SUM(customer_state IS NULL) AS missing_state
FROM olist_customers_dataset;

-- 5.CHECK MISSING VALUES IN GEOLOCATION TABLE
SELECT
    SUM(geolocation_zip_code_prefix IS NULL) AS missing_zip_code,
    SUM(geolocation_lat IS NULL) AS missing_latitude,
    SUM(geolocation_lng IS NULL) AS missing_longitude,
    SUM(geolocation_city IS NULL) AS missing_city,
    SUM(geolocation_state IS NULL) AS missing_state
FROM olist_geolocation_dataset;

-- 6.CHECK MISSING VALUES IN ORDER ITEMS TABLE
SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(order_item_id IS NULL) AS missing_order_item_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(seller_id IS NULL) AS missing_seller_id,
    SUM(shipping_limit_date IS NULL) AS missing_shipping_date,
    SUM(price IS NULL) AS missing_price,
    SUM(freight_value IS NULL) AS missing_freight_value
FROM olist_order_items_dataset;

-- 7.CHECK MISSING VALUES IN PAYMENTS TABLE
SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(payment_sequential IS NULL) AS missing_payment_sequential,
    SUM(payment_type IS NULL) AS missing_payment_type,
    SUM(payment_installments IS NULL) AS missing_installments,
    SUM(payment_value IS NULL) AS missing_payment_value
FROM olist_order_payments_dataset;

-- 8.CHECK MISSING VALUES IN REVIEWS TABLE
SELECT
    SUM(review_id IS NULL) AS missing_review_id,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(review_score IS NULL) AS missing_review_score,
    SUM(review_comment_title IS NULL) AS missing_comment_title,
    SUM(review_comment_message IS NULL) AS missing_comment_message,
    SUM(review_creation_date IS NULL) AS missing_creation_date,
    SUM(review_answer_timestamp IS NULL) AS missing_answer_timestamp
FROM olist_order_reviews_dataset;

-- 9.CHECK MISSING VALUES IN PRODUCTS TABLE
SELECT
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_name_lenght IS NULL) AS missing_name_length,
    SUM(product_description_lenght IS NULL) AS missing_description_length,
    SUM(product_photos_qty IS NULL) AS missing_photos,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height,
    SUM(product_width_cm IS NULL) AS missing_width
FROM olist_products_dataset;

-- 10.CHECK MISSING VALUES IN SELLERS TABLE
SELECT
    SUM(seller_id IS NULL) AS missing_seller_id,
    SUM(seller_zip_code_prefix IS NULL) AS missing_zip_code,
    SUM(seller_city IS NULL) AS missing_city,
    SUM(seller_state IS NULL) AS missing_state
FROM olist_sellers_dataset;

-- 11.INVESTIGATE MISSING REVIEW RECORDS
SELECT *
FROM olist_order_reviews_dataset
WHERE order_id IS NULL
   OR review_score IS NULL
   OR review_comment_title IS NULL
   OR review_comment_message IS NULL
LIMIT 15;

-- 12.INVESTIGATE MISSING PRODUCT CATEGORY ATTRIBUTES
SELECT
    COUNT(*) AS total_incomplete_products,
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_name_lenght IS NULL) AS missing_name_length,
    SUM(product_description_lenght IS NULL) AS missing_description_length,
    SUM(product_photos_qty IS NULL) AS missing_photos
FROM olist_products_dataset
WHERE product_category_name IS NULL
   OR product_name_lenght IS NULL
   OR product_description_lenght IS NULL
   OR product_photos_qty IS NULL;

-- 13.INSPECT PRODUCTS WITH MISSING CATEGORY ATTRIBUTES
SELECT *
FROM olist_products_dataset
WHERE product_category_name IS NULL
LIMIT 10;

-- 14.INVESTIGATE PRODUCTS WITH MISSING PHYSICAL MEASUREMENTS
SELECT *
FROM olist_products_dataset
WHERE product_weight_g IS NULL
   OR product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;

-- 15.CHECK SALES OF PRODUCTS WITH MISSING PHYSICAL ATTRIBUTES
SELECT
    p.product_id,
    COUNT(oi.order_id) AS total_order_items
FROM olist_products_dataset p
LEFT JOIN olist_order_items_dataset oi
    ON p.product_id = oi.product_id
WHERE p.product_id IN (
    '09ff539a621711667c43eba6a3bd8466',
    '5eb564652db742ff8f28759cd8d2652a'
)
GROUP BY p.product_id;

-- 16.CHECK SALES OF PRODUCTS WITH MISSING CATEGORY INFORMATION
SELECT
    COUNT(DISTINCT p.product_id) AS incomplete_products,
    COUNT(oi.product_id) AS total_order_items
FROM olist_products_dataset p
LEFT JOIN olist_order_items_dataset oi
    ON p.product_id = oi.product_id
WHERE p.product_category_name IS NULL;

-- TASK 4: TIMESTAMP SEQUENCE AND DELIVERY-DATE VALIDATION -------------

-- 1. CHECK APPROVAL BEFORE PURCHASE
SELECT COUNT(*) AS invalid_approval_dates
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s')
    < STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s');

-- 2. CHECK CARRIER DATE BEFORE APPROVAL
SELECT COUNT(*) AS invalid_carrier_dates
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')
    < STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s');

-- 3.CHECK INVALID CARRIER TIMESTAMPS BY ORDER STATUS
SELECT
    order_status,
    COUNT(*) AS invalid_carrier_dates
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')
    < STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s')
GROUP BY order_status
ORDER BY invalid_carrier_dates DESC;

-- 4.CHECK CUSTOMER DELIVERY BEFORE CARRIER HANDOVER
SELECT COUNT(*) AS invalid_delivery_dates
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
    < STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s');

-- 5.CHECK ACTUAL DELIVERY AFTER ESTIMATED DELIVERY
SELECT COUNT(*) AS late_deliveries
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
    > STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s');

-- 6.INVESTIGATE LATE DELIVERIES
SELECT
    order_id,
    order_status,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
    > STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s')
LIMIT 10;

-- 7.CHECK CUSTOMER DELIVERY BEFORE PURCHASE
SELECT COUNT(*) AS invalid_delivery_purchase_dates
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
    < STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s');

-- 8.CHECK CARRIER HANDOVER BEFORE PURCHASE
SELECT COUNT(*) AS invalid_carrier_purchase_dates
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')
    < STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s');

-- 9.INVESTIGATE CARRIER HANDOVER BEFORE PURCHASE
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_carrier_date
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')
    < STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
LIMIT 20;

-- 10.CHECK APPROVAL AFTER ESTIMATED DELIVERY
SELECT COUNT(*) AS invalid_approval_estimated_dates
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s')
    > STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s');

-- 11.INVESTIGATE APPROVAL AFTER ESTIMATED DELIVERY
SELECT
    order_id,
    order_status,
    order_approved_at,
    order_estimated_delivery_date
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s')
    > STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s')
LIMIT 12;

-- 12.CHECK ESTIMATED DELIVERY BEFORE PURCHASE
SELECT COUNT(*) AS invalid_estimated_delivery_dates
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s')
    < STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s');

-- 13.COUNT ON-TIME DELIVERIES
SELECT
    COUNT(*) AS on_time_deliveries
FROM olist_orders_dataset
WHERE order_status = 'delivered'
AND STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
    <= STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s');

-- 14.CHECK COMBINED TIMESTAMP SEQUENCE ANOMALIES
SELECT COUNT(*) AS orders_with_timestamp_anomalies
FROM olist_orders_dataset
WHERE
    STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')
        < STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
    OR
    STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')
        < STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s')
    OR
    STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
        < STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s');

-- TASK 5: MISSING IDENTIFIERS AND REFERENTIAL INTEGRITY

-- 1.CHECK ORDERS WITHOUT MATCHING CUSTOMERS
SELECT COUNT(*) AS unmatched_customer_orders
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 2.CHECK ORDER ITEMS WITHOUT MATCHING ORDERS
SELECT COUNT(*) AS order_items_without_matching_order
FROM olist_order_items_dataset oi
LEFT JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 3.CHECK ORDER ITEMS WITHOUT MATCHING PRODUCTS
SELECT COUNT(*) AS order_items_without_matching_product
FROM olist_order_items_dataset oi
LEFT JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 4.CHECK ORDER ITEMS WITHOUT MATCHING SELLERS
SELECT COUNT(*) AS order_items_without_matching_seller
FROM olist_order_items_dataset oi
LEFT JOIN olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- 5. CHECK PAYMENTS WITHOUT MATCHING ORDERS
SELECT COUNT(*) AS payments_without_matching_order
FROM olist_order_payments_dataset p
LEFT JOIN olist_orders_dataset o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 6. CHECK REVIEWS WITHOUT MATCHING ORDERS
SELECT COUNT(*) AS reviews_without_matching_order
FROM olist_order_reviews_dataset r
LEFT JOIN olist_orders_dataset o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 7. CHECK PRODUCTS WITHOUT CATEGORY TRANSLATIONS
SELECT COUNT(*) AS products_without_category_translation
FROM olist_products_dataset p
LEFT JOIN product_category_name t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
AND t.product_category_name IS NULL;

-- 8. IDENTIFY PRODUCTS WITH UNMATCHED CATEGORIES
SELECT
    p.product_id,
    p.product_category_name
FROM olist_products_dataset p
LEFT JOIN product_category_name t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
AND t.product_category_name IS NULL;

-- 9. INVESTIGATE UNMATCHED CATEGORIES IN ORDERS
SELECT
    p.product_category_name,
    COUNT(DISTINCT p.product_id) AS product_count,
    COUNT(DISTINCT oi.order_id) AS order_count
FROM olist_products_dataset p
LEFT JOIN olist_order_items_dataset oi
    ON p.product_id = oi.product_id
LEFT JOIN product_category_name t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
AND t.product_category_name IS NULL
GROUP BY p.product_category_name;

-- 10. CHECK CUSTOMERS WITHOUT ORDERS
SELECT COUNT(*) AS customers_without_orders
FROM olist_customers_dataset c
LEFT JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 11. CHECK SELLERS WITHOUT ORDER ITEMS
SELECT COUNT(*) AS sellers_without_order_items
FROM olist_sellers_dataset s
LEFT JOIN olist_order_items_dataset oi
    ON s.seller_id = oi.seller_id
WHERE oi.seller_id IS NULL;


-- TASK 6: ORDER STATUS AND ORDER-DATE BUSINESS RULES

-- 1. CHECK ORDERS WITHOUT ORDER ITEMS
-- PURPOSE: IDENTIFY ORDERS THAT HAVE NO ASSOCIATED ORDER-ITEM RECORDS
SELECT
    COUNT(*) AS orders_without_order_items
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- 2. CHECK ORDER DISTRIBUTION BY STATUS
-- PURPOSE: ANALYZE THE NUMBER OF ORDERS IN EACH ORDER STATUS
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

-- 3. CHECK ORDERS WITH FUTURE PURCHASE DATES
SELECT
    order_id,
    order_purchase_timestamp
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
    > '2018-10-17 17:30:18';

-- 4. CHECK EARLIEST AND LATEST ORDER PURCHASE DATES
-- PURPOSE: IDENTIFY THE OVERALL DATE RANGE OF ORDER TRANSACTIONS
SELECT
    MIN(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'))
        AS earliest_purchase_date,
    MAX(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'))
        AS latest_purchase_date
FROM olist_orders_dataset;


-- 5. CHECK MONTHLY ORDER DISTRIBUTION
-- PURPOSE: ANALYZE ORDER VOLUME ACROSS DIFFERENT MONTHS
SELECT
    DATE_FORMAT(
        STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'),
        '%Y-%m'
    ) AS purchase_month,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY purchase_month
ORDER BY purchase_month;

-- 6. CHECK ORDER DISTRIBUTION BY DAY OF THE WEEK
-- PURPOSE: IDENTIFY THE WEEKDAYS WITH THE HIGHEST ORDER VOLUME
SELECT
    DAYNAME(
        STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
    ) AS purchase_day,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY DAYOFWEEK(
    STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
), purchase_day
ORDER BY DAYOFWEEK(
    STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
);

-- 7. CHECK ORDER DISTRIBUTION BY HOUR
-- PURPOSE: IDENTIFY PEAK ORDER PLACING HOURS
SELECT
    HOUR(
        STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
    ) AS purchase_hour,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY purchase_hour
ORDER BY purchase_hour;

-- 8. INVESTIGATE LOW ORDER VOLUME IN SEPTEMBER AND OCTOBER 2018
-- PURPOSE: ANALYZE MONTHLY ORDER COUNTS BY ORDER STATUS
SELECT
    DATE_FORMAT(
        STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'),
        '%Y-%m'
    ) AS purchase_month,
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
WHERE order_purchase_timestamp >= '2018-09-01'
GROUP BY purchase_month, order_status
ORDER BY purchase_month, total_orders DESC;

-- 9. CHECK DAILY ORDER DISTRIBUTION
-- PURPOSE: IDENTIFY UNUSUAL GAPS IN DAILY ORDER ACTIVITY
SELECT
    DATE(
        STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
    ) AS purchase_date,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
WHERE order_purchase_timestamp >= '2018-09-01'
GROUP BY purchase_date
ORDER BY purchase_date;


-- 10. CHECK FOR UNEXPECTED ORDER STATUSES
-- PURPOSE: IDENTIFY INVALID OR UNRECOGNIZED ORDER STATUS VALUES
SELECT DISTINCT
    order_status
FROM olist_orders_dataset
WHERE order_status NOT IN (
    'delivered',
    'shipped',
    'canceled',
    'unavailable',
    'invoiced',
    'processing',
    'created',
    'approved'
);


-- 11. INVESTIGATE DELIVERED ORDERS WITH MISSING CARRIER TIMESTAMPS
-- PURPOSE: IDENTIFY DELIVERED ORDERS WITHOUT CARRIER HANDOVER INFORMATION
SELECT
    order_id,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_dataset
WHERE order_status = 'delivered'
AND order_delivered_carrier_date IS NULL;

-- 12. INVESTIGATE DELIVERED ORDERS WITH MISSING APPROVAL TIMESTAMPS
-- PURPOSE: IDENTIFY DELIVERED ORDERS WITHOUT APPROVAL INFORMATION
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM olist_orders_dataset
WHERE order_status = 'delivered'
AND order_approved_at IS NULL;

-- TASK 7
-- 1. NUMERIC VALIDATION OF ORDER ITEMS
-- PURPOSE: IDENTIFY NEGATIVE AND MISSING PRICE AND FREIGHT VALUES
SELECT
    SUM(CASE WHEN price < 0 THEN 1 ELSE 0 END) AS negative_prices,
    SUM(CASE WHEN freight_value < 0 THEN 1 ELSE 0 END) AS negative_freight_values,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS missing_prices,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS missing_freight_values
FROM olist_order_items_dataset;

-- 2. PAYMENT VALUE VALIDATION
-- PURPOSE: IDENTIFY ZERO OR NEGATIVE PAYMENT VALUES
SELECT
    SUM(CASE WHEN payment_value <= 0 THEN 1 ELSE 0 END)
        AS invalid_payment_values
FROM olist_order_payments_dataset;

-- 3. PRODUCT MEASUREMENT VALIDATION
-- PURPOSE: IDENTIFY NEGATIVE PRODUCT MEASUREMENTS
SELECT
    SUM(CASE WHEN product_weight_g < 0 THEN 1 ELSE 0 END)
        AS negative_weights,
    SUM(CASE WHEN product_length_cm < 0 THEN 1 ELSE 0 END)
        AS negative_lengths,
    SUM(CASE WHEN product_height_cm < 0 THEN 1 ELSE 0 END)
        AS negative_heights,
    SUM(CASE WHEN product_width_cm < 0 THEN 1 ELSE 0 END)
        AS negative_widths
FROM olist_products_dataset;

-- 4. CHECK MISSING PRODUCT MEASUREMENTS
-- PURPOSE: IDENTIFY PRODUCTS WITH MISSING PHYSICAL DIMENSIONS
SELECT
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END)
        AS missing_weights,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END)
        AS missing_lengths,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END)
        AS missing_heights,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END)
        AS missing_widths
FROM olist_products_dataset;

-- 5. IDENTIFY PRODUCTS WITH MISSING MEASUREMENTS
-- PURPOSE: RETRIEVE PRODUCT RECORDS WITH INCOMPLETE PHYSICAL DIMENSIONS
SELECT
    product_id,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_dataset
WHERE product_weight_g IS NULL
   OR product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;

-- 6. CHECK MISSING PRODUCT ATTRIBUTES
-- PURPOSE: IDENTIFY PRODUCTS WITH INCOMPLETE CATALOG INFORMATION
SELECT
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END)
        AS missing_categories,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END)
        AS missing_product_names,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END)
        AS missing_descriptions,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END)
        AS missing_photos
FROM olist_products_dataset;

-- 7. IDENTIFY PRODUCTS WITH MISSING CATALOG ATTRIBUTES
-- PURPOSE: RETRIEVE PRODUCT RECORDS WITH INCOMPLETE CATALOG INFORMATION
SELECT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty
FROM olist_products_dataset
WHERE product_category_name IS NULL
   OR product_name_lenght IS NULL
   OR product_description_lenght IS NULL
   OR product_photos_qty IS NULL;

-- 8. REVIEW SCORE VALIDATION
-- PURPOSE: IDENTIFY REVIEW SCORES OUTSIDE THE VALID RANGE
SELECT
    COUNT(*) AS invalid_review_scores
FROM olist_order_reviews_dataset
WHERE review_score NOT BETWEEN 1 AND 5;

-- Geolocation coordinates
SELECT
    SUM(CASE WHEN geolocation_lat < -90
              OR geolocation_lat > 90
             THEN 1 ELSE 0 END) AS invalid_latitudes,
    SUM(CASE WHEN geolocation_lng < -180
              OR geolocation_lng > 180
             THEN 1 ELSE 0 END) AS invalid_longitudes,
    SUM(CASE WHEN geolocation_lat IS NULL
             THEN 1 ELSE 0 END) AS missing_latitudes,
    SUM(CASE WHEN geolocation_lng IS NULL
             THEN 1 ELSE 0 END) AS missing_longitudes
FROM olist_geolocation_dataset;

-- TASK 8: ZERO-VALUE VALIDATION
-- STEP 1: ZERO PRODUCT PRICES
SELECT
    COUNT(*) AS zero_price_records
FROM olist_order_items_dataset
WHERE price = 0;

-- STEP 2: ZERO FREIGHT CHARGES
-- PURPOSE: IDENTIFY ORDER ITEMS WITH ZERO FREIGHT CHARGES
SELECT
    COUNT(*) AS zero_freight_records
FROM olist_order_items_dataset
WHERE freight_value = 0;

-- STEP 3: ZERO PRODUCT WEIGHT
-- PURPOSE: IDENTIFY PRODUCTS WITH ZERO WEIGHT
SELECT
    COUNT(*) AS zero_weight_products
FROM olist_products_dataset
WHERE product_weight_g = 0;

-- STEP 4: ZERO PRODUCT DIMENSIONS
-- PURPOSE: IDENTIFY PRODUCTS WITH ZERO LENGTH, HEIGHT, OR WIDTH
SELECT
    SUM(CASE WHEN product_length_cm = 0 THEN 1 ELSE 0 END) AS zero_length,
    SUM(CASE WHEN product_height_cm = 0 THEN 1 ELSE 0 END) AS zero_height,
    SUM(CASE WHEN product_width_cm = 0 THEN 1 ELSE 0 END) AS zero_width
FROM olist_products_dataset;

-- STEP 5: INVESTIGATE ZERO FREIGHT CHARGES
-- PURPOSE: COUNT DISTINCT ORDERS CONTAINING ZERO-FREIGHT ITEMS
SELECT
    COUNT(DISTINCT order_id) AS orders_with_zero_freight
FROM olist_order_items_dataset
WHERE freight_value = 0;

-- STEP 6: SELLERS WITH ZERO-FREIGHT ITEMS
-- PURPOSE: COUNT DISTINCT SELLERS ASSOCIATED WITH ZERO-FREIGHT ITEMS
SELECT
    COUNT(DISTINCT seller_id) AS sellers_with_zero_freight
FROM olist_order_items_dataset
WHERE freight_value = 0;

-- STEP 7: SELLER-WISE ZERO FREIGHT ANALYSIS
-- PURPOSE: COUNT ZERO-FREIGHT ORDER ITEMS FOR EACH SELLER
SELECT
    seller_id,
    COUNT(*) AS zero_freight_items
FROM olist_order_items_dataset
WHERE freight_value = 0
GROUP BY seller_id
ORDER BY zero_freight_items DESC;

-- STEP 8: ZERO-FREIGHT VS NON-ZERO-FREIGHT PRICE COMPARISON
-- PURPOSE: COMPARE AVERAGE PRODUCT PRICES BY FREIGHT CATEGORY
SELECT
    CASE
        WHEN freight_value = 0 THEN 'Zero Freight'
        ELSE 'Non-Zero Freight'
    END AS freight_category,
    COUNT(*) AS total_items,
    ROUND(AVG(price), 2) AS average_product_price
FROM olist_order_items_dataset
GROUP BY freight_category;

-- STEP 9: IDENTIFY PRODUCTS WITH ZERO PHYSICAL MEASUREMENTS
-- PURPOSE: RETRIEVE PRODUCT IDs AND THEIR ZERO MEASUREMENT VALUES
SELECT
    product_id,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_dataset
WHERE product_weight_g = 0
   OR product_length_cm = 0
   OR product_height_cm = 0
   OR product_width_cm = 0;


-- TASK 9: PAYMENT-TO-ITEM TOTAL RECONCILIATION
-- STEP 1: COMPARE PAYMENT TOTALS WITH ORDER ITEM TOTALS
-- PURPOSE: IDENTIFY ORDERS WITH MATCHING AND MISMATCHING TOTALS
WITH item_totals AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
),
payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
),
reconciliation AS (
    SELECT
        i.order_id,
        i.item_total,
        p.payment_total,
        ROUND(p.payment_total - i.item_total, 2) AS difference
    FROM item_totals i
    INNER JOIN payment_totals p
        ON i.order_id = p.order_id
)
SELECT
    COUNT(*) AS total_orders_compared,
    SUM(CASE WHEN ABS(difference) <= 1 THEN 1 ELSE 0 END) AS matched_orders,
    SUM(CASE WHEN ABS(difference) > 1 THEN 1 ELSE 0 END) AS mismatched_orders
FROM reconciliation;

-- STEP 2
-- PURPOSE: FIND TOP 10 ORDERS WITH PAYMENT DIFFERENCES
SELECT
    p.order_id,
    ROUND(p.payment_total, 2) AS payment_total,
    ROUND(i.item_total, 2) AS item_total,
    ROUND(p.payment_total - i.item_total, 2) AS difference
FROM (
    SELECT order_id, SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p
JOIN (
    SELECT order_id, SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
) i ON p.order_id = i.order_id
WHERE ABS(p.payment_total - i.item_total) > 1
ORDER BY ABS(p.payment_total - i.item_total) DESC
LIMIT 10;

-- STEP 3
-- PURPOSE: INVESTIGATE PAYMENT RECORDS FOR THE LARGEST MISMATCHED ORDER
SELECT
    order_id,
    payment_type,
    payment_installments,
    payment_value
FROM olist_order_payments_dataset
WHERE order_id = 'ce6d150fb29ada17d2082f4847107665';

-- STEP 4
-- PURPOSE: INSPECT PRODUCT PRICES AND FREIGHT CHARGES
SELECT
    order_id,
    product_id,
    seller_id,
    price,
    freight_value,
    (price + freight_value) AS item_total
FROM olist_order_items_dataset
WHERE order_id = 'ce6d150fb29ada17d2082f4847107665';

-- STEP 5
-- PURPOSE: CHECK THE STATUS OF THE SELECTED MISMATCHED ORDER
SELECT
    order_id,
    order_status
FROM olist_orders_dataset
WHERE order_id = 'ce6d150fb29ada17d2082f4847107665';

-- STEP 6
-- PURPOSE: COUNT PAYMENT MISMATCHES BY ORDER STATUS
SELECT
    o.order_status,
    COUNT(*) AS mismatch_orders
FROM olist_orders_dataset o
JOIN (
    SELECT order_id, SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p ON o.order_id = p.order_id
JOIN (
    SELECT order_id, SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
) i ON o.order_id = i.order_id
WHERE ABS(p.payment_total - i.item_total) > 1
GROUP BY o.order_status
ORDER BY mismatch_orders DESC;

-- TASK 10: DATA TYPE AND FORMAT VALIDATION
-- STEP 1: INSPECT DATA TYPES OF IMPORTANT TABLES
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'ecommerce_customer_intelligence'
AND TABLE_NAME IN (
    'olist_orders_dataset',
    'olist_order_items_dataset',
    'olist_order_payments_dataset',
    'olist_products_dataset'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- STEP 2: CHECK INVALID NUMERIC VALUES
SELECT
    SUM(price REGEXP '^-?[0-9]+(\\.[0-9]+)?$' = 0) AS invalid_prices,
    SUM(freight_value REGEXP '^-?[0-9]+(\\.[0-9]+)?$' = 0) AS invalid_freight
FROM olist_order_items_dataset;

-- STEP 3: CHECK INVALID PAYMENT VALUES
SELECT
    SUM(payment_value REGEXP '^-?[0-9]+(\\.[0-9]+)?$' = 0)
    AS invalid_payment_values
FROM olist_order_payments_dataset;

-- STEP 4: CHECK INVALID PRODUCT MEASUREMENTS
SELECT
    SUM(product_weight_g REGEXP '^-?[0-9]+(\\.[0-9]+)?$' = 0) AS invalid_weight,
    SUM(product_length_cm REGEXP '^-?[0-9]+(\\.[0-9]+)?$' = 0) AS invalid_length,
    SUM(product_height_cm REGEXP '^-?[0-9]+(\\.[0-9]+)?$' = 0) AS invalid_height,
    SUM(product_width_cm REGEXP '^-?[0-9]+(\\.[0-9]+)?$' = 0) AS invalid_width
FROM olist_products_dataset;

-- STEP 5: CHECK INVALID DATE FORMATS
SELECT
    SUM(
        STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') IS NULL
        AND order_purchase_timestamp IS NOT NULL
    ) AS invalid_purchase_dates,
    SUM(
        STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s') IS NULL
        AND order_approved_at IS NOT NULL
    ) AS invalid_approval_dates,
    SUM(
        STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s') IS NULL
        AND order_delivered_carrier_date IS NOT NULL
    ) AS invalid_carrier_dates,
    SUM(
        STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s') IS NULL
        AND order_delivered_customer_date IS NOT NULL
    ) AS invalid_delivery_dates,
    SUM(
        STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s') IS NULL
        AND order_estimated_delivery_date IS NOT NULL
    ) AS invalid_estimated_dates
FROM olist_orders_dataset;
-- CHECK INVALID SHIPPING DATE FORMATS
SELECT
    SUM(
        STR_TO_DATE(shipping_limit_date, '%Y-%m-%d %H:%i:%s') IS NULL
        AND shipping_limit_date IS NOT NULL
    ) AS invalid_shipping_dates
FROM olist_order_items_dataset;


