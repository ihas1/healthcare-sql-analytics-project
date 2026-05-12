# Healthcare Revenue Cycle & Patient Outcomes Analytics

## Overview

This project simulates a healthcare analytics environment focused on hospital operations, patient admissions, and revenue cycle reporting using PostgreSQL.

The database was designed to analyze common healthcare metrics related to:

- patient admissions
- readmissions
- insurance claims
- claim denials
- reimbursement performance
- provider productivity
- operational revenue trends

The project demonstrates SQL skills commonly used in healthcare analytics, business intelligence, and operational reporting roles.

---

# Why I Built This

I wanted to build a healthcare-focused SQL project that combined operational analytics with financial KPI reporting.

The goal was to practice designing a relational database and writing business-oriented SQL queries using realistic healthcare workflows such as patient admissions, claims processing, reimbursement analysis, and readmission tracking.

---

# Business Scenario

A regional healthcare organization wants to improve visibility into operational and financial performance across its hospital system.

Leadership teams need reporting that helps answer questions such as:

- Which providers generate the highest reimbursement revenue?
- What percentage of claims are being denied?
- Are readmissions increasing?
- Which diagnosis categories produce the highest hospital charges?
- How are reimbursement trends changing over time?

This project simulates the SQL analytics layer used to support those reporting workflows.

---

# Technologies Used

- PostgreSQL
- SQL
- pgAdmin
- GitHub

---

# Database Schema

The project contains the following tables:

| Table | Description |
|---|---|
| patients | Patient demographic information |
| providers | Provider and department information |
| diagnoses | Diagnosis reference data |
| admissions | Hospital admission encounters |
| claims | Insurance claim and reimbursement data |
| claim_denials | Claim denial tracking |

---

# Data Relationships

- Each patient can have multiple admissions.
- Each admission is assigned to a provider.
- Admissions are associated with diagnosis codes.
- Claims are linked to admissions.
- Denials are linked to claims.

---

# SQL Skills Demonstrated

## Querying & Analysis

- joins
- aggregations
- grouping
- filtering
- conditional logic
- date-based analysis

## Advanced SQL

- common table expressions (CTEs)
- window functions
- views
- indexes
- KPI reporting queries

---

# Healthcare Analytics KPIs

| KPI | Purpose |
|---|---|
| Average Length of Stay | Measures operational efficiency |
| 30-Day Readmission Analysis | Identifies patient return patterns |
| Claim Denial Rate | Measures reimbursement challenges |
| Reimbursement Rate | Tracks payer reimbursement performance |
| Monthly Revenue Trends | Monitors reimbursement revenue over time |
| Revenue by Diagnosis Category | Analyzes financial impact by diagnosis type |

---

# Example Analyses Included

## Readmission Analysis

Used window functions and `LAG()` to identify patients readmitted within 30 days of discharge.

## Provider Revenue Performance

Compared provider reimbursement totals, billed amounts, and reimbursement rates.

## Denial Rate Analysis

Calculated denied claim percentages to evaluate revenue cycle performance.

## Chronic Condition Cost Analysis

Compared patient charges for chronic vs non-chronic condition populations.

## Revenue Trend Analysis

Tracked monthly reimbursement revenue using payment data.

---

# Example SQL Features Used

## Common Table Expressions (CTEs)

Used to simplify multi-step readmission analysis logic.

## Window Functions

Used to compare patient admissions chronologically.

## Views

Created reusable reporting views for patient admission summaries.

## Indexes

Added indexes to improve query performance on frequently joined columns.

---

# Assumptions

- Readmissions are defined as patient returns within 30 days of discharge.
- Approved claim amounts may differ from billed amounts due to payer adjustments.
- Sample data is synthetic and created for portfolio purposes only.
- The project is intended for analytics practice and does not contain protected health information (PHI).

---

# Project Structure

```text
healthcare-revenue-cycle-analytics/
│
├── sql/
│   └── healthcare_analytics.sql
├── LICENSE
└── README.md
```
---

# Future Improvements

Potential future enhancements include:

- larger synthetic datasets
- payer dimension tables
- emergency department analytics
- medication utilization analytics
- predictive readmission analysis
- automated reporting workflows

---

# Resume Highlights

- Built a PostgreSQL healthcare analytics database simulating hospital operations and revenue cycle workflows.
- Developed advanced SQL queries using joins, CTEs, aggregations, and window functions for KPI reporting.
- Performed readmission, reimbursement, denial rate, and provider performance analysis.
- Designed SQL queries for healthcare operational and financial reporting scenarios.

---

# Author

Issa H.

Aspiring Data Analyst focused on SQL, healthcare analytics, and business intelligence.
