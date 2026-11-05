# Business Analysis Findings
## SQL-Focused Business Analytics Project

**Dataset:** Brazilian E-Commerce Public Dataset by Olist  
**Database:** ecommerce_customer_intelligence  
**DBMS:** MySQL 8.0.46

## 1. Executive Summary

This project analyses e-commerce business performance using SQL. The analysis covers sales, product categories, customer behaviour, geographic performance, payments, delivery operations, customer reviews and order cancellations.

The completed analysis recorded:

| Metric | Result |
|---|---:|
| Delivered Orders | 96,478 |
| Product Revenue | R$13,221,498.11 |
| Freight | R$2,198,275.64 |
| Total Sales Including Freight | R$15,419,773.75 |
| Average Order Value | R$159.83 |

The findings identify important patterns in product performance, customer purchasing behaviour, regional sales, payment activity and delivery performance.

## 2. Sales Performance and Trends

### Overall Sales Performance

| Metric | Result |
|---|---:|
| Delivered Orders | 96,478 |
| Total Order Items | 110,197 |
| Product Revenue | R$13,221,498.11 |
| Freight | R$2,198,275.64 |
| Sales Including Freight | R$15,419,773.75 |
| Average Items per Order | 1.14 |
| Freight Contribution | 14.26% |

### Annual Sales Performance

| Year | Delivered Orders | Product Revenue | Freight |
|---|---:|---:|---:|
| 2016 | 267 | R$40,470.98 | R$6,182.76 |
| 2017 | 43,428 | R$5,962,902.01 | R$958,633.23 |
| 2018 | 52,783 | R$7,218,125.12 | R$1,233,459.65 |

**Key Findings**

- November 2017 recorded the highest monthly sales of R$1,153,364.20.
- Recorded sales were higher in 2018 than in 2017.
- Incomplete calendar coverage affects annual comparisons.

## 3. Product Category Analysis

### Top Categories by Revenue

| Rank | Category | Product Revenue |
|---|---|---:|
| 1 | Health & Beauty | R$1,233,131.72 |
| 2 | Watches & Gifts | R$1,166,176.98 |
| 3 | Bed, Bath & Table | R$1,023,434.76 |
| 4 | Sports & Leisure | R$954,852.55 |
| 5 | Computers & Accessories | R$888,724.61 |

**Key Findings**

- Health & Beauty generated the highest product revenue.
- Bed, Bath & Table recorded the highest item volume with 10,953 items.
- Computers had the highest average item price at R$1,098.92.
- The top three categories contributed 25.89% of total product revenue.

**Business Insight:** Category performance differs depending on revenue, item volume and average selling price. These measures should be evaluated together.

## 4. Customer Analysis

### Customer Purchasing Behaviour

| Customer Type | Customers | Delivered Orders | Product Revenue |
|---|---:|---:|---:|
| One-Time Customers | 90,557 | 90,557 | R$12,493,089.36 |
| Repeat Customers | 2,801 | 5,921 | R$728,408.75 |

**Key Findings**

- Approximately 97% of customers placed only one delivered order.
- Repeat customers represented approximately 3% of the analysed customer base.
- Average product revenue per repeat customer was R$260.05.
- Average product revenue per one-time customer was R$137.96.

**Business Insight:** Repeat purchasing is relatively limited. Customer retention and repeat-purchase behaviour are potential areas for further investigation.

## 5. Geographic Analysis

### Customer Concentration

| State | Customers | Customer Share |
|---|---:|---:|
| SP | 39,156 | 41.94% |
| RJ | 11,917 | 12.76% |
| MG | 11,001 | 11.78% |

The top three states accounted for 66.48% of customers.

### Freight Burden by State

| State | Freight Burden |
|---|---:|
| MA | 26.32% |
| RO | 24.70% |
| AM | 24.51% |
| SE | 24.24% |
| PI | 24.15% |
| SP | 13.85% |

**Key Findings**

- São Paulo generated the highest product revenue.
- Paraíba recorded the highest average product revenue per order at R$217.77.
- Maranhão recorded the highest freight burden at 26.32%.
- São Paulo recorded the lowest freight burden at 13.85%.

**Business Insight:** Geographic performance varies considerably. Regions with higher freight burden may require further logistics investigation.

## 6. Payment Analysis

### Payment Method Performance

| Payment Method | Orders | Payment Amount |
|---|---:|---:|
| Credit Card | 74,304 | R$12,101,094.88 |
| Boleto | 19,191 | R$2,769,932.58 |
| Voucher | 3,679 | R$343,013.19 |
| Debit Card | 1,485 | R$208,421.12 |

### Payment Reconciliation

| Metric | Result |
|---|---:|
| Orders Compared | 98,665 |
| Matched Within R$1 | 98,416 |
| Mismatched Orders | 249 |
| Match Rate | 99.75% |

The largest identified difference was R$182.81 between the payment total and the order-item total including freight.

**Business Insight:** Payment reconciliation exceptions require further investigation before financial reporting. The analysis did not establish their root causes.

## 7. Delivery Performance

### Overall Delivery Results

| Metric | Result |
|---|---:|
| Eligible Delivered Orders | 96,470 |
| On-Time or Early Deliveries | 88,644 |
| Late Deliveries | 7,826 |
| On-Time Delivery Rate | 91.89% |
| Average Delay | 8.87 Days |
| Maximum Delay | 188 Days |

### Late Delivery Rate by State

| State | Late Orders | Late Delivery Rate |
|---|---:|---:|
| AL | 95 | 23.93% |
| MA | 141 | 19.67% |
| PI | 76 | 15.97% |
| CE | 196 | 15.32% |
| RJ | 1,664 | 13.47% |
| SP | 2,387 | 5.89% |
| RO | 7 | 2.88% |

**Key Findings**

- Alagoas recorded the highest late-delivery rate at 23.93%.
- São Paulo recorded the highest number of late orders.
- The most delayed order had a delay of 188 days.

**Business Insight:** High-delay regions and unusually delayed orders should be investigated to identify possible delivery issues.

## 8. Review Analysis

### Review Score Distribution

| Review Score | Review Records | Share |
|---|---:|---:|
| 1 | 11,424 | 11.51% |
| 2 | 3,151 | 3.18% |
| 3 | 8,179 | 8.24% |
| 4 | 19,142 | 19.29% |
| 5 | 57,328 | 57.78% |

### Review Scores by Delivery Performance

| Delivery Group | Average Review Score | Low-Score Share |
|---|---:|---:|
| On Time | 4.29 | 9.23% |
| Late | 2.57 | 54.03% |

**Key Findings**

- 77.07% of review records had scores of four or five.
- Late-delivery review records had a considerably lower average score.
- 547 orders had multiple review records.
- The highest monthly average review score was 4.32 in July 2018.

**Business Insight:** Late delivery is strongly associated with lower review scores in the analysed data. This relationship does not establish causation.

## 9. Order Status and Cancellation Analysis

### Order Status Distribution

| Order Status | Orders | Share |
|---|---:|---:|
| Delivered | 96,478 | 97.02% |
| Shipped | 1,107 | 1.11% |
| Canceled | 625 | 0.63% |
| Unavailable | 609 | 0.61% |
| Invoiced | 314 | 0.32% |
| Processing | 301 | 0.30% |
| Created | 5 | 0.01% |
| Approved | 2 | 0.00% |

### Cancellation Findings

- August 2018 recorded the highest cancellation count with 84 orders.
- August 2018 had a cancellation rate of 1.29% among 6,512 orders.
- February 2018 recorded 73 cancellations.
- September and October 2018 had only 16 and 4 orders respectively.

The cancellation rates for September and October should not be treated as representative monthly performance because of the limited number of orders.

## 10. Key Business Recommendations

| Business Area | Recommendation |
|---|---|
| Sales | Monitor product revenue and freight contribution. |
| Product Categories | Compare category revenue and item volume. |
| Customer Behaviour | Investigate repeat-purchase opportunities. |
| Geographic Performance | Examine regional freight burden. |
| Payment Analysis | Investigate payment reconciliation differences. |
| Delivery Performance | Review high-delay regions and extreme delays. |
| Customer Experience | Investigate low review scores associated with late deliveries. |

## 11. Data Limitations

1. Different analyses use different populations, including all orders and delivered orders.
2. The dataset has incomplete time coverage, particularly in 2016 and late 2018.
3. Payment reconciliation excludes orders without matching payment or item records.
4. Multiple review records can exist for one order.
5. Averages and percentages depend on the population and calculation method.
6. Observed relationships do not establish causation.
7. Revenue does not represent profit because product costs and operating expenses were not analysed.

## 12. Conclusion

The SQL analysis provides insights into sales performance, product categories, customer purchasing behaviour, geographic distribution, payment activity, delivery performance and customer reviews.

The findings identify areas for further investigation in customer retention, regional logistics, payment reconciliation and delivery-related customer experience.

These results will form the analytical foundation for the project's independently developed Power BI dashboard.