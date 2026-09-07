# Excel Analysis Guide

The accompanying Excel analysis is designed around the `customers.csv` and `transactions.csv` datasets.

## Excel Skills Demonstrated

### 1. Data Preparation
- Convert raw CSV ranges into Excel Tables.
- Apply currency formatting to `amount_usd`.
- Use filters to review Completed, Pending, and Declined transactions.
- Freeze header rows and apply consistent column formatting.

### 2. Lookup / Customer Enrichment
Use `XLOOKUP` to bring customer attributes into transaction-level analysis.

```excel
=XLOOKUP([@customer_id],Customers[customer_id],Customers[country],"Not Found")
```

### 3. High-Value Review Flag
```excel
=IF([@amount_usd]>=20000,"High",IF([@amount_usd]>=10000,"Medium","Standard"))
```

### 4. Cross-Border Flag
```excel
=IF([@transaction_country]<>[@customer_country],"Cross-Border","Domestic")
```

### 5. PivotTable Analysis
Create PivotTables for:
- transaction value by month,
- transaction count by status,
- total value by customer,
- transaction value by type,
- domestic vs. cross-border activity.

### 6. Dashboard
Create KPI cards for total completed value, average transaction value, completed transaction count, and high-value transaction count. Add a monthly trend chart and conditional formatting to highlight records requiring review.

> All data in this project is synthetic and the review thresholds are simplified portfolio examples.
