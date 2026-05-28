# Environmental Facility Risk Analysis

## Objective

The objective of this project is to analyze environmental operations data across multiple facilities and identify which facilities should be prioritized for compliance risk and energy efficiency review.

## Dataset Description

This project uses two tables:

### 1. environmental_operations

This table contains daily environmental operation records.

Columns:
- date
- facility
- waste_type
- waste_kg
- water_m3
- energy_kwh
- limit_exceeded

### 2. facility_info

This table contains facility-level information.

Columns:
- facility
- region
- manager
- facility_type

The two tables are joined using the `facility` column.

## Tools Used

- SQL
- SQLite
- Data analysis
- Risk classification
- Conditional aggregation

## SQL Skills Demonstrated

- Table creation
- Data insertion
- LEFT JOIN
- GROUP BY
- SUM, AVG, COUNT
- CASE WHEN
- Conditional aggregation
- Subqueries
- Business recommendation based on data analysis

## Key Metrics

- Total waste
- Total water usage
- Total energy consumption
- Average energy consumption
- Compliance violation count
- Compliance risk level
- Energy risk level
- Overall priority level

## Risk Classification Logic

### Compliance Risk

| Condition | Risk Level |
|---|---|
| violation_count >= 2 | High Compliance Risk |
| violation_count = 1 | Medium Compliance Risk |
| violation_count = 0 | Low Compliance Risk |

### Energy Risk

| Condition | Risk Level |
|---|---|
| total_energy >= 2000 | High Energy Risk |
| total_energy >= 1800 | Medium Energy Risk |
| total_energy < 1800 | Low Energy Risk |

### Overall Priority

| Condition | Priority |
|---|---|
| violation_count >= 2 | Priority 1 |
| total_energy >= 2000 | Priority 2 |
| violation_count = 1 OR total_energy >= 1800 | Priority 3 |
| Otherwise | Priority 4 |

## Key Findings

1. Plant B has the highest compliance risk, with 2 limit exceedances.
2. Plant C has the highest total energy consumption, with 2,090 kWh, and is classified as High Energy Risk.
3. Plant A has the highest total waste amount, with 450 kg, but has no compliance violations.
4. Plastic is the largest waste type, with 450 kg total waste.

## Final Recommendation

Based on the analysis, Plant B should be prioritized first because it has the highest compliance risk, with 2 limit exceedances. Plant C should also be reviewed because it has the highest total energy consumption, with 2,090 kWh, and is classified as High Energy Risk.

The main waste type to monitor is Plastic, because it has the highest total waste amount at 450 kg.

## Project Summary

This project shows how SQL can be used to analyze environmental operations data, classify facility-level risk, and support management decision-making through data-driven recommendations.