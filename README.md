![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=flat&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-FF6F00?style=flat&logo=microsoft&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

# 🏏 CSK 2026 Performance Analysis

A ball-by-ball analysis of Chennai Super Kings' IPL 2026 season: a full pipeline from raw delivery data to a 7-page interactive Power BI report, with every finding traced back to a SQL query.

**Season record: 6 wins – 8 losses (42.86% win rate) across 14 matches. Home 4W–3L, away 2W–5L.**

> **Headline finding:** CSK lost all 5 matches in which they lost 3+ powerplay wickets, and all 6 of their wins came when they took 3+ wickets in the middle overs. The season was decided by early wickets on both sides of the ball.

<img width="1130" height="652" alt="Batting roles dashboard" src="https://github.com/user-attachments/assets/f07ce527-dff3-4b46-9ad2-2ed1cae6708f" />
<img width="1115" height="635" alt="Match closeness dashboard" src="https://github.com/user-attachments/assets/b060ebe1-e5a4-4cd0-a76c-2a5a06ab2bb6" />
<img width="1120" height="631" alt="Samson impact and recommendations dashboard" src="https://github.com/user-attachments/assets/785b430c-9621-4fea-b66f-8c80f8202962" />
<img width="1121" height="627" alt="Bowling combination dashboard" src="https://github.com/user-attachments/assets/c6ddaa75-bc20-4796-9e8f-fa8954d41701" />

---

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
    └── *.png                                     ← dashboard views
```

---

## Key Findings

*Every rate is shown with its match count, because the sample is small (14 matches).*

**1. The Jamie Overton + Akeal Hosein pairing is the biggest lever on results.**

| Combination status | Matches | Win rate | Wins – Losses |
|---|---|---|---|
| Both played | 6 | 83.3% | 5–1 |
| Akeal absent only | 4 | 25.0% | 1–3 |
| Overton absent only | 1 | 0.0% | 0–1 |
| Both absent | 3 | 0.0% | 0–3 |

Individually: with Akeal Hosein playing, CSK won 71% (5 of 7) vs 14% (1 of 7) without him. With Jamie Overton playing, CSK won 60% (6 of 10) vs 0% (0 of 4) without him.

**2. Losing early wickets in the powerplay predicts losses.**

| Wickets lost in powerplay | Matches | Win rate | Wins – Losses |
|---|---|---|---|
| 0–1 | 4 | 75% | 3–1 |
| 2 | 5 | 60% | 3–2 |
| 3+ | 5 | **0%** | 0–5 |

Taking wickets matters too: with 2+ powerplay wickets taken, CSK won 80% (4 of 5), vs 22% (2 of 9) with 0–1 taken.

**3. Sanju Samson surviving the powerplay is close to a binary predictor of the result.**

| Samson's powerplay impact | Matches | Win rate | Avg runs | Avg SR |
|---|---|---|---|---|
| IMPACT | 4 | 100% (4–0) | 87.3 | 177.3 |
| MODERATE | 5 | 40% (2–3) | 19.4 | 140.6 |
| FAILED | 5 | 0% (0–5) | 5.8 | 119.8 |

When he survived the powerplay CSK won 4 of 4; when he was dismissed in it, CSK won 2 of 10 (20%).

**4. Middle-overs wickets are just as decisive on the bowling side.** With 3+ wickets in the middle overs, CSK won 85.71% (6 of 7). With 0–2 wickets, CSK won none.

**5. The season was decisive, not dramatic.** 11 of 14 matches were blowouts (6 blowout losses, 5 blowout wins) against only 3 close matches (2 close losses, 1 close win). Blowout losses are driven by wicket clusters rather than slow scoring: CSK loses roughly double the powerplay and middle-overs wickets in blowout losses compared with blowout wins.

**6. Bowling economy improves in every phase when Overton and Hosein bowl together**, compared with the rest of the attack:

| Phase | Overton + Hosein | Rest of bowling |
|---|---|---|
| Powerplay | 9.03 | 10.58 |
| Middle overs | 7.78 | 9.67 |
| Death overs | 8.96 | 12.55 |

**7. Designated middle- and death-overs batters underperformed their roles.** Kartik Sharma and Ruturaj Gaikwad (most used in the middle) and Shivam Dube and Prashant Veer (most used at death) scored below the strike-rate threshold generally needed to win T20 matches, while some of the squad's highest-impact batters were used out of position or given too few deliveries to influence the game.

**8. Anshul Kamboj's economy worsened as the tournament progressed:** 8.03 in Phase 1 (M1–M3), 10.97 in Phase 2 (M4–M10) and 11.50 in Phase 3 (M11–M14).

**9. Kagiso Rabada was the most dangerous opposition bowler**, taking 6 wickets against CSK across the season, ahead of Mohammed Siraj and Eshan Malinga (4 each).

**10. The season fell into three phases:** 3 straight losses to open, then 4 wins in 6, then 2 wins in the final 5. The heaviest defeat of the season (89 runs) came in the last match.

---

## Recommendations

1. **Build the batting order around protecting Sanju Samson through the powerplay.** CSK won 4 of 4 when he survived it and 2 of 10 (20%) when he didn't, the clearest single pattern in the season.
2. **Define clear roles across the batting order, not just at the top.** Several players suited to one position were used out of position all season.
3. **Establish one designated finisher instead of splitting death-overs duty across the squad.** Sarfaraz Khan, Samson and Kartik Sharma convert boundaries more efficiently than Dube in that phase.
4. **Field Overton and Hosein together consistently, not just when available.** Without both, middle-overs wicket-taking goes flat and the attack becomes one-dimensional.
5. **Manage player fitness and injuries proactively.** Roughly 6 players were unavailable for stretches of the season, reshaping the XI repeatedly.

---

## Data

- **Source:** ball-by-ball delivery data for all of CSK's 14 matches in the 2026 season (Kaggle), plus a `matches.csv` metadata file.
- **Verification:** all 14 match results were manually cross-checked against official Cricbuzz scorecards. Two matches had a scoring discrepancy from a double-counted `extras` column and were corrected by hand (see `Power BI/key_measures.md`).
- **Supplementary data:** the raw data has no `bowler_type` field (bowling style belongs to the player, not the delivery). A manual lookup table (bowler → Pace/Spin) was built for all 62 distinct bowlers who dismissed a CSK batter. It was used to show which bowlers dismissed CSK most often (Rabada, Siraj and Malinga topped the list) and which pace/spin split dismissed each CSK batter.

## Tools Used

- **Python:** pandas (Google Colab)
- **MySQL:** CTEs, window functions (`DENSE_RANK`, `ROW_NUMBER`, `MINX`, etc.)
- **Power BI:** Power Query, DAX

## Notes & Known Limitations

- Power BI connects via CSV export, not a live MySQL connection. The MySQL Connector/NET version that Power BI requires wasn't available, so pre-aggregated CSVs are loaded directly.
- Several segmentations run on very small samples (14 matches in total, some splits down to n=1). Every rate above is shown against its underlying match count for that reason, and the findings describe this season only, not a general rule.
- The bowler pace/spin lookup table is trimmed to a handful of example rows in the SQL script comments (the full list covers 62 bowlers). Extend it if you fork this analysis for a different team or season.

---

## 👤 Author

**Praises Kalintha**
📧 kalinthapraises777@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/praises-kalintha-30a621354/)
💻 [GitHub](https://github.com/PraisesKalintha)

## 📄 License
This project is licensed under the MIT License.
