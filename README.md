# CSK 2026 Performance Analysis

A ball-by-ball data analysis of Chennai Super Kings' IPL 2026 season — a full pipeline from raw delivery data to an interactive Power BI dashboard, with every finding traced back to a SQL query.

# Pipeline

Python (pandas, Google Colab)  →  MySQL (CTEs, window functions)  →  Power BI (Power Query + DAX)
        cleaning                      querying / analysis                visualization


Raw ball-by-ball data (ipl_2026_deliveries.csv, cross-referenced against matches.csv) is filtered down to CSK's 14 matches in Python, loaded into MySQL for analysis with CTEs and window functions, then visualized in Power BI via CSV export.

# Repository Structure

# CSK 2026 Performance Analysis

A ball-by-ball data analysis of Chennai Super Kings' IPL 2026 season — a full pipeline from raw delivery data to an interactive Power BI dashboard, with every finding traced back to a SQL query.

## Pipeline

Python (pandas, Google Colab)  →  MySQL (CTEs, window functions)  →  Power BI (Power Query + DAX)
        cleaning                      querying / analysis                visualization

Raw ball-by-ball data (`ipl_2026_deliveries.csv`, cross-referenced against `matches.csv`) is filtered down to CSK's 14 matches in Python, loaded into MySQL for analysis with CTEs and window functions, then visualized in Power BI via CSV export.

## Repository Structure

```
├── README.md
├── CSK_2026_Performance_Analysis.pbix            ← Power BI file
├── Python/
│   └── ipl_2026_stage_1_data_loading.py          ← pandas cleaning + match-result pipeline
├── MYSQL/
│   ├── 02_schema_setup_and_win_rate_queries.sql  ← schema, powerplay & combination queries
│   └── 03_advanced_analysis_window_functions.sql ← CTEs, DENSE_RANK, full batting audit
├── Power BI/
│   └── key_measures.md                           ← DAX measures + bugs fixed, with before/after
└── screenshots/
    └── *.png                                     ← dashboard views (roles, match closeness, bowling combo)
```
