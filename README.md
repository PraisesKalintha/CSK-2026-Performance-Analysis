![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=flat&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-FF6F00?style=flat&logo=microsoft&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)


# CSK 2026 Performance Analysis

A ball-by-ball data analysis of Chennai Super Kings' IPL 2026 season — a full pipeline from raw delivery data to an interactive Power BI dashboard, with every finding traced back to a SQL query.

**Season record: 6 wins – 8 losses (42.86% win rate) across 14 matches.**



## Pipeline

```
Python (pandas, Google Colab)  →  MySQL (CTEs, window functions)  →  Power BI (Power Query + DAX)
        cleaning                      querying / analysis                visualization
```

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



## Key Findings

**1. The Jamie Overton + Akeal Hosein pairing is the single biggest lever on results.**

| Combination status | Matches | Win rate | Wins – Losses |
| --- | --- | --- | --- |
| Both played | 6 | 83.3% | 5–1 |
| Akeal absent only | 4 | 25.0% | 1–3 |
| Overton absent only | 1 | 0.0% | 0–1 |
| Both absent | 3 | 0.0% | 0–3 |

Individually: Akeal Hosein played → 71% win rate vs. 14% when absent. Jamie Overton played → 60% vs. 0% when absent.

**2. Losing early wickets in the powerplay predicts losses.**

| Wickets lost in PP | Matches | Win rate |
| --- | --- | --- |
| 0–1 | 3 | 67% |
| 2 | 4 | 50% |
| 3+ | 7 | 29% |

**3. Sanju Samson surviving the powerplay is close to a binary result predictor.**

| Samson's PP impact | Matches | Win rate | Avg runs | Avg SR |
| --- | --- | --- | --- | --- |
| IMPACT | 4 | 100% (4–0) | 87.3 | 177.3 |
| MODERATE | 5 | 40% (2–3) | 19.4 | 140.6 |
| FAILED | 5 | 0% (0–5) | 5.8 | 119.8 |

**4. Wickets taken in the middle overs is just as decisive on the bowling side.** 3+ wickets taken in the middle overs → 85.71% win rate. 0–2 wickets → 0% win rate.

**5. The season was decisive, not dramatic.** 11 of 14 matches were blowouts — 6 blowout losses, 5 blowout wins — against only 3 close matches (2 close losses, 1 close win). Blowout losses are driven by wicket clusters, not slow scoring: CSK loses roughly double the powerplay and middle-overs wickets in blowout losses compared to blowout wins.

**6. Bowling economy improves in every phase when Overton and Hosein bowl together**, versus the rest of the attack:

| Phase | Overton + Hosein | Rest of bowling |
| --- | --- | --- |
| Powerplay | 9.03 | 10.58 |
| Middle overs | 7.78 | 9.67 |
| Death overs | 8.96 | 12.55 |

**7. Designated middle- and death-overs batters underperformed their roles.** Kartik Sharma and Ruturaj Gaikwad (most-used in the middle) and Shivam Dube / Prashant Veer (most-used at death) scored below the strike rate threshold generally needed to win T20 matches, while some of the squad's highest-impact batters were used out of position or given too few deliveries to influence the game.

**8. Anshul Kamboj's economy worsened as the tournament progressed:**
8.03 in Phase 1 (M1–M3) → 10.97 in Phase 2 (M4–M10) → 11.50 in Phase 3 (M11–M14).

**9. Kagiso Rabada was CSK's most dangerous opponent bowler,** taking 6 wickets against them across the season — ahead of Mohammed Siraj and Eshan Malinga (4 each).



## Recommendations

**1. Build the batting order around protecting Sanju Samson through the powerplay.** CSK's win rate is 100% when he survives it, 11% when he doesn't — the clearest single pattern in the season.

**2. Define clear roles across the batting order, not just at the top.** Several players suited to one position have been used out of position all season.

**3. Establish one designated finisher instead of splitting death-overs duty across the squad.** Sarfaraz Khan, Samson, and Kartik Sharma convert boundaries more efficiently than Dube in that phase.

**4. Field Overton and Hosein together consistently, not just when available.** Without both, middle-overs wicket-taking goes flat and the attack becomes one-dimensional.

**5. Manage player fitness and injuries proactively.** Roughly 6 players were unavailable for stretches of the season, reshaping the XI repeatedly.


## Data

✦ **Source:** ball-by-ball delivery data for all of CSK's 14 matches in the 2026 season (Kaggle), plus a `matches.csv` metadata file.

✦ **Verification:** all 14 match results were manually cross-checked against official Cricbuzz scorecards; two matches had a scoring discrepancy from a double-counted `extras` column and were corrected by hand (see `Power BI/key_measures.md`).

✦ **Supplementary data:** no `bowler_type` field exists in the raw data (bowling style is a property of the player, not the delivery). A manual lookup table (bowler → Pace/Spin) was built for all 62 distinct bowlers who dismissed a CSK batsman, and reused to break down which bowlers dismissed CSK most often (Rabada, Siraj, Malinga topped the list) and which pace/spin split dismissed which CSK batter.


## Tools Used

**Python** — pandas (Google Colab)

**MySQL** — CTEs, window functions (`DENSE_RANK`, `ROW_NUMBER`, `MINX`, etc.)

**Power BI** — Power Query, DAX

## Notes & Known Limitations

✦ Power BI connects via CSV export, not a live MySQL connection — the MySQL Connector/NET version required by Power BI wasn't available, so pre-aggregated CSVs are loaded directly.

✦ Several segmentations run on very small samples (14 matches total, some splits down to n=1). Every rate/percentage above is shown against its underlying match count for that reason.

✦ The bowler pace/spin lookup table is trimmed to a handful of example rows in the SQL script comments (full list covers 62 bowlers) — extend it if you fork this analysis for a different team or season.


## Dashboard

<img width="1130" height="652" alt="Batting roles dashboard" src="https://github.com/user-attachments/assets/f07ce527-dff3-4b46-9ad2-2ed1cae6708f" />

<img width="1115" height="635" alt="Match closeness dashboard" src="https://github.com/user-attachments/assets/b060ebe1-e5a4-4cd0-a76c-2a5a06ab2bb6" />

<img width="1120" height="631" alt="Samson impact and recommendations dashboard" src="https://github.com/user-attachments/assets/785b430c-9621-4fea-b66f-8c80f8202962" />

<img width="1121" height="627" alt="Bowling combo dashboard" src="https://github.com/user-attachments/assets/c6ddaa75-bc20-4796-9e8f-fa8954d41701" />
