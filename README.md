# CSK 2026 Performance Analysis

A ball-by-ball data analysis of Chennai Super Kings' IPL 2026 season — a full pipeline from raw delivery data to an interactive Power BI dashboard, with every finding traced back to a SQL query.

# Pipeline

Python (pandas, Google Colab)  →  MySQL (CTEs, window functions)  →  Power BI (Power Query + DAX)
        cleaning                      querying / analysis                visualization


Raw ball-by-ball data (ipl_2026_deliveries.csv, cross-referenced against matches.csv) is filtered down to CSK's 14 matches in Python, loaded into MySQL for analysis with CTEs and window functions, then visualized in Power BI via CSV export.
