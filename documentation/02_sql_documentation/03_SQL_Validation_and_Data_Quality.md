## SQL-Focused Business Analytics Project

## 1. Purpose

This document records the data-quality checks and validation considerations identified during the SQL analysis of the Brazilian E-Commerce Public Dataset by Olist.

The objective is to make the analysis transparent and to clarify how identified data issues, metric definitions, and incomplete reporting periods may affect interpretation. The checks are diagnostic; they do not automatically modify or clean the source records.

## 2. Validation Scope

The SQL data-quality checks covered the following areas:

- Source-table record counts.
- Duplicate records.
- Missing values.
- Order and delivery timestamp sequence.
- Referential integrity between related tables.
- Order-status and date consistency.
- Numeric-value validation.
- Zero-value checks.
- Payment reconciliation.
- Data-type and format validation.

The analysis also considered table relationships, aggregation grain, and KPI definitions before interpreting the business-analysis results.

## 3. Source Data and Record-Grain Controls

The project uses nine Olist source tables: customers, geolocation, orders, order items, payments, reviews, products, sellers, and product-category translations.

These tables have different levels of detail.

| Table | Typical record grain | Validation consideration |
|---|---|---|
| Orders | One row per order | Order status and timestamp eligibility |
| Order items | One row per order item | An order can contain multiple items |
| Payments | One row per payment record | An order can have multiple payment records |
| Customers | One row per customer record | Customer-level aggregation |
| Reviews | One row per review record | An order can have multiple review records |
| Products | One row per product | Missing product attributes and category mapping |
| Sellers | One row per seller | Seller identifiers and relationships |
| Geolocation | Multiple geographic reference records | Repeated geographic information |
| Category translations | One row per translated category | Unmatched category values |

### Validation principle

Before aggregating joined tables, confirm the grain required by the metric.

For example, joining payment records directly to multiple order-item rows can multiply payment values. Similarly, review-record counts are not necessarily equal to unique reviewed-order counts.

Use the appropriate aggregation level and verify totals after one-to-many joins.

## 4. Data-Quality Findings

### 4.1 Source records and order data

The orders table contained **99,441 records** after the accidental CSV header row was removed during data loading.

The checks covered record counts, duplicate records, missing values, timestamp sequences, order-status rules, and relationships between tables.

**Potential impact:** Incorrectly loaded headers, missing values, or inconsistent relationships can affect counts and analyses that combine multiple tables.

**Control:** Preserve the original source files, document loading adjustments, and verify record counts before using the tables in analysis.

**Status:** The loading adjustment and validation checks were completed. No unsupported assumptions about the causes of individual exceptions are made.

### 4.2 Product attributes and category translation

The product checks identified:

| Finding | Records |
|---|---:|
| Products with one or more missing catalogue attributes | 610 |
| Products missing all four physical measurement fields | 2 |
| Products with category values unmatched to the translation table | 13 |

The two products missing all four physical measurement fields were:

- `09ff539a621711667c43eba6a3bd8466`
- `5eb564652db742ff8f28759cd8d2652a`

The 13 products with unmatched category values were associated with:

| Category value | Products | Distinct orders |
|---|---:|---:|
| `pc_gamer` | 3 | 8 |
| `portateis_cozinha_e_preparadores_de_alimentos` | 10 | 14 |
| **Total** | **13** | **22** |

**Potential impact:** Missing physical attributes may limit product-level analysis, while unmatched category translations can affect category labels and reporting completeness.

**Control:**
- Distinguish missing product attributes from missing category translations.
- Retain unmatched records when calculating overall totals unless an exclusion is justified.
- Use a consistent rule for displaying unmatched categories.

**Status:** Exceptions identified; their underlying causes have not been established.

### 4.3 Payment validation and reconciliation

The payment checks identified **9 zero-value payment records**.

Payment totals were also compared with order-item value plus freight for orders present in both joined datasets.

| Validation measure | Result |
|---|---:|
| Orders compared | 98,665 |
| Orders within R$1 difference | 98,416 |
| Orders with difference greater than R$1 | 249 |
| Within-tolerance share | 99.75% |
| Difference-greater-than-R$1 share | 0.25% |

The comparison used an INNER JOIN, so orders without the required payment or order-item totals were not included.

The largest investigated difference was:

| Component | Value |
|---|---:|
| Payment total | R$1,586.47 |
| Order-item value plus freight | R$1,403.66 |
| Difference (payment minus item and freight) | +R$182.81 |

The order had one credit-card payment with 10 installments. The available data did not establish the reason for the difference.

**Potential impact:** Payment totals and item-plus-freight totals are not interchangeable unless their populations and calculation rules are aligned.

**Control:**
- Compare totals at the same order level.
- Keep the join population and tolerance explicit.
- Investigate material differences without assigning unsupported causes.
- Do not classify an exception as fraud, overcharging, or financial loss without further evidence.

**Status:** Reconciliation exceptions identified; their causes remain unresolved.

### 4.4 Zero-freight order items

The checks identified:

| Finding | Result |
|---|---:|
| Order-item rows with zero freight | 383 |
| Distinct orders represented | 339 |
| Sellers represented | 9 |

**Potential impact:** Zero-freight records affect freight averages and freight-burden calculations.

**Control:** Retain the recorded values and make the treatment of zero freight clear in freight-related metrics. Do not assume that every zero-freight record is an error.

**Status:** Identified; the reason for these records has not been established.

### 4.5 Zero-weight products

Four products had a recorded weight of zero while their dimensions were 30 × 25 × 30:

- `81781c0fed9fe1ad6e8c81fca1e1cb08`
- `8038040ee2a71048d4bdbbdc985b69ab`
- `36ba42dd187055e1fbe943b2d11430ca`
- `e673e90efa65a5409ff4196c038bb5af`

**Potential impact:** These values may affect analyses that depend on product weight or shipping characteristics.

**Control:** Flag these records in product-level checks and avoid replacing their values without a verified source.

**Status:** Identified; the correct weights are not established by the available data.

### 4.6 Review records

The review analysis identified multiple review records associated with some orders.

| Measure | Result |
|---|---:|
| Total review records | 99,224 |
| Distinct orders with reviews | 98,673 |
| Orders with multiple review records | 547 |
| Review records belonging to those orders | 1,098 |
| Maximum review records for one order | 3 |
| Additional records beyond one per order | 551 |

Multiple review records should not automatically be treated as invalid duplicates.

**Potential impact:** Review-level averages and percentages can differ from order-level metrics when an order has more than one review record.

**Control:**
- State whether a metric counts review records or unique orders.
- Apply a consistent rule when comparing groups.
- Do not delete or deduplicate records without a justified rule.

**Status:** Identified; no automatic deletion is recommended.

## 5. Delivery and Review Metric Consistency

The delivery analysis and review analysis use different populations and grains. Delivery results count eligible orders, while review comparisons count review records associated with eligible delivered orders.

### Delivery results

| Measure | Result |
|---|---:|
| Orders with actual and estimated delivery dates | 96,470 |
| Delivered on time or early | 88,644 |
| Delivered late | 7,826 |
| On-time-or-early rate | 91.89% |
| Late rate | 8.11% |
| Average actual delivery time | 12.50 days |

### Review comparison by delivery group

| Delivery group | Review records | Average review score | Low-score share |
|---|---:|---:|---:|
| On time | 88,653 | 4.29 | 9.23% |
| Late | 7,700 | 2.57 | 54.03% |

The review counts are review records, not unique orders. They should not be directly substituted for the eligible-order counts in the delivery analysis.

The results show an association between late delivery and lower review scores. They do not, by themselves, establish causation.

### Timestamp and calendar-day differences

Timestamp comparisons and calendar-day calculations can produce different results. An order delivered later than its estimated timestamp on the same calendar date may be classified as late by a timestamp comparison while its `DATEDIFF` result is zero.

**Control:**
- State the delivery comparison rule.
- Identify the eligible population and missing-date exclusions.
- Distinguish review records from unique orders.
- Keep timestamp-based delay and calendar-day delay definitions explicit.

**Status:** Metric populations and calculation rules are documented; comparisons should retain these distinctions.

## 6. Incomplete Monthly Order Coverage

The order-status analysis showed sparse records in the later months of 2018.

| Period | Total orders | Canceled orders | Cancellation rate |
|---|---:|---:|---:|
| August 2018 | 6,512 | 84 | 1.29% |
| September 2018 | 16 | 15 | 93.75% |
| October 2018 | 4 | 4 | 100.00% |

September and October 2018 have very small populations. Their cancellation rates are mathematically correct for the recorded orders but should not be interpreted as representative monthly performance.

The monthly delivered-sales output also ends in August 2018. Missing later months in that output must not be interpreted as zero delivered sales.

**Potential impact:** Sparse or incomplete periods can distort monthly trends, cancellation rates, and year-over-year comparisons.

**Control:**
- Flag incomplete periods.
- Avoid comparing sparse months with full months as though coverage were equivalent.
- Distinguish missing months from months with zero activity.
- State the reporting cutoff when presenting trends.

**Status:** Coverage limitation identified; the reason for sparse late-2018 records has not been established.

## 7. KPI Validation Rules

Apply the following checks before publishing SQL results or Power BI measures.

| KPI | Validation requirement |
|---|---|
| Total orders | Confirm the order population and status filters |
| Delivered orders | Distinguish status counts from delivery-date-eligible orders |
| Product revenue | Aggregate item prices at the correct grain |
| Freight | Avoid duplication when joining order items to other tables |
| Product revenue plus freight | Use compatible populations and inclusion rules |
| Average order value | State the revenue components and eligible-order denominator |
| Repeat-customer rate | Define the customer population and qualifying orders |
| On-time delivery rate | State the date-comparison rule and eligible population |
| Cancellation rate | Use the same purchase-period population for numerator and denominator |
| Low review-score rate | State whether the metric counts review records or unique orders |
| Freight burden | Calculate freight divided by product revenue for the same population |

### Validation principles

1. **Consistent definitions:** SQL and Power BI must use the same KPI rules.
2. **Consistent populations:** Numerators and denominators must refer to compatible populations.
3. **Correct aggregation grain:** Review one-to-many joins to prevent inflated totals.
4. **Explicit exclusions:** Document missing values and excluded records.
5. **Traceable results:** Link important findings to their SQL queries.
6. **Transparent limitations:** Keep unresolved exceptions visible when they affect interpretation.

## 8. Reporting Recommendations

| Control | Implementation |
|---|---|
| KPI definitions | Document the formula, population, numerator, denominator, and exclusions |
| Payment reconciliation | Retain and review material payment differences |
| Data coverage | Flag incomplete months and unavailable comparison periods |
| Join-grain review | Check one-to-many joins before aggregation |
| Review-count consistency | Distinguish review records from unique reviewed orders |
| SQL and Power BI consistency | Align dashboard measures with validated SQL definitions |
| Evidence traceability | Keep each important finding connected to its analysis query |

These controls improve the reliability and explainability of the project. They do not mean that every identified exception has been resolved.

## 9. Outstanding Issues

The following causes remain unconfirmed based on the completed checks:

- The reasons for the 249 payment differences greater than R$1.
- The reason for the 9 zero-value payment records.
- The correct physical measurements for products with missing attributes.
- The reason for unmatched product-category translations.
- The reasons for zero-freight order-item records.
- The correct weights for the four zero-weight products.
- Whether multiple review records represent valid separate records or duplicates.
- The reason for sparse late-2018 order coverage.
- The causes of unusually long delivery delays.

These findings should be described as unresolved rather than presented as confirmed errors or business causes.

## 10. Conclusion

The SQL validation work identified data-quality exceptions and reporting limitations involving product attributes, category translations, payment reconciliation, freight values, product weights, review records, delivery metrics, and monthly data coverage.

The findings highlight the importance of checking table grain, defining KPIs consistently, validating joined totals, and documenting incomplete or unusual records.

The final Power BI report should use the same metric definitions as the SQL analysis and clearly disclose limitations where they affect interpretation. The validation process supports a more transparent and technically defensible business analytics project.
