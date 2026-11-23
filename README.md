![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=flat&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-FF6F00?style=flat&logo=microsoft&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

# 🏏 CSK 2026 Performance Analysis

**What decided Chennai Super Kings' IPL 2026 season?** A ball-by-ball analysis of all 14 matches, built as a full pipeline from raw delivery data to a 7-page interactive Power BI report, with every finding traced back to a SQL query.

**Season record: 6 wins, 8 losses (42.86% win rate). Home 4W-3L, away 2W-5L.**

📄 **[Read the one-page summary (PDF)](CSK_2026_One_Page_Summary.pdf)**

<!-- Uncomment once the dashboard is published to web:
🔗 **[Open the live Power BI dashboard](PASTE-LINK-HERE)**
-->

> **Headline finding:** CSK lost all 5 matches in which they lost 3+ powerplay wickets, and won 6 of the 7 matches in which they took 3+ wickets in the middle overs (and none of the other 7). The season was decided by early wickets on both sides of the ball.

*Unofficial, fan-built analysis of public data. Not affiliated with Chennai Super Kings or the IPL.*

---

## Dashboard preview

<img width="1130" height="652" alt="Batting roles dashboard" src="https://github.com/user-attachments/assets/f07ce527-dff3-4b46-9ad2-2ed1cae6708f" />
<img width="1115" height="635" alt="Match closeness dashboard" src="https://github.com/user-attachments/assets/b060ebe1-e5a4-4cd0-a76c-2a5a06ab2bb6" />
<img width="1120" height="631" alt="Samson impact and recommendations dashboard" src="https://github.com/user-attachments/assets/785b430c-9621-4fea-b66f-8c80f8202962" />
<img width="1121" height="627" alt="Bowling combination dashboard" src="https://github.com/user-attachments/assets/c6ddaa75-bc20-4796-9e8f-fa8954d41701" />

---

## Key findings

*Every rate is shown with its match count, because the sample is small (14 matches). These are patterns in one season, not proof of cause.*

### 1. Overton + Hosein together: the biggest swing in results

| Combination status | Matches | Win rate | Wins-Losses |
|---|---|---|---|
| Both played | 6 | 83.3% | 5-1 |
| Overton only (Hosein absent) | 4 | 25.0% | 1-3 |
| Hosein only (Overton absent) | 1 | 0.0% | 0-1 |
| Neither played | 3 | 0.0% | 0-3 |

Individually: with Akeal Hosein playing, CSK won 71% (5 of 7) vs 14% (1 of 7) without him. With Jamie Overton playing, CSK won 60% (6 of 10) vs 0% (0 of 4) without him.

*Caveat: opposition, venue and toss were not controlled for, so other factors could explain part of this gap.*

### 2. Early powerplay wickets were associated with losses

| Wickets lost in powerplay | Matches | Win rate | Wins-Losses |
|---|---|---|---|
| 0-1 | 4 | 75% | 3-1 |
| 2 | 5 | 60% | 3-2 |
| 3+ | 5 | **0%** | 0-5 |

Taking wickets mattered too: with 2+ powerplay wickets taken, CSK won 80% (4 of 5), vs 22% (2 of 9) with 0-1 taken.

### 3. Sanju Samson surviving the powerplay closely tracked the result

| Samson's powerplay impact | Matches | Win rate | Avg runs | Avg SR |
|---|---|---|---|---|
| Impact | 4 | 100% (4-0) | 87.3 | 177.3 |
| Moderate | 5 | 40% (2-3) | 19.4 | 140.6 |
| Failed | 5 | 0% (0-5) | 5.8 | 119.8 |

When he survived the powerplay CSK won 4 of 4. When he was dismissed in it, CSK won 2 of 10 (20%).

*Note: Samson's dismissal is itself one of the powerplay wickets in Finding 2, so these two findings overlap and are not independent evidence.*

### 4. Middle-overs wickets were just as decisive on the bowling side

With 3+ wickets in the middle overs, CSK won 85.71% (6 of 7). With 0-2 wickets, CSK won none (0 of 7).

### 5. A decisive season, not a dramatic one

11 of 14 matches were blowouts (6 blowout losses, 5 blowout wins) against only 3 close matches (2 close losses, 1 close win). Blowout losses were driven by wicket clusters rather than slow scoring: CSK lost roughly double the powerplay and middle-overs wickets in blowout losses compared with blowout wins.

### 6. Bowling economy improved in every phase when Overton and Hosein bowled together

| Phase | Overton + Hosein | Rest of bowling |
|---|---|---|
| Powerplay | 9.03 | 10.58 |
| Middle overs | 7.78 | 9.67 |
| Death overs | 8.96 | 12.55 |

### 7. Role fit in the middle and death overs

Several batters were used in roles that did not match their output. Shivam Dube and Prashant Veer (most used at the death) had slower strike rates and needed more balls per boundary than Sarfaraz Khan and Samson in that phase, while some of the squad's most effective batters were used out of position or given too few deliveries to influence the game.

### 8. Anshul Kamboj's economy worsened through the season

8.03 in M1-M3, 10.97 in M4-M10, and 11.50 in M11-M14.

### 9. Kagiso Rabada was the most dangerous opposition bowler

6 wickets against CSK across the season, ahead of Mohammed Siraj and Eshan Malinga (4 each).

### 10. The season arc

3 straight losses to open, then 4 wins in the next 6, then 2 wins in the final 5. The heaviest defeat of the season (89 runs) came in the last match.

---

## Recommendations (hypotheses worth testing)

1. **Protect Sanju Samson through the powerplay.** CSK won 4 of 4 when he survived it and 2 of 10 when he didn't. Worth testing whether batting-order changes can improve his survival rate.
2. **Define clear roles across the whole batting order, not just the top.** Several players suited to one position were used out of position.
3. **Use one designated finisher instead of splitting death-overs duty.** Sarfaraz Khan, Samson and Kartik Sharma hit boundaries more efficiently than Dube in that phase (small ball counts, so treat as indicative).
4. **Field Overton and Hosein together consistently.** Without both, middle-overs wicket-taking went flat and the attack became one-dimensional.
5. **Manage fitness and availability proactively.** Around 6 players missed stretches of the season, reshaping the XI repeatedly.

---

## Pipeline

```
Python (pandas, Google Colab)  ->  MySQL (CTEs, window functions)  ->  Power BI (Power Query + DAX)
        cleaning                      querying / analysis                  visualization
```

Raw ball-by-ball data (`ipl_2026_deliveries.csv`, cross-referenced against `matches.csv`) is filtered down to CSK's 14 matches in Python, loaded into MySQL for analysis with CTEs and window functions, then visualized in Power BI via CSV export.

## Repository structure

```
├── README.md
├── CSK_2026_One_Page_Summary.pdf                  <- one-page findings summary
├── Dataset/                                       <- source and processed CSVs
├── Python/
│   └── ipl_2026_stage_1_data_loading.py           <- pandas cleaning + match-result pipeline
├── MYSQL/
│   ├── 02_schema_setup_and_win_rate_queries.sql   <- schema, powerplay & combination queries
│   └── 03_advanced_analysis_window_functions.sql  <- CTEs, DENSE_RANK, full batting audit
├── Power BI/
│   ├── CSK_2026_Performance_Analysis.pbix         <- 7-page report
│   └── key_measures.md                            <- DAX measures + bugs fixed, with before/after
└── Screenshots/
    └── *.png                                      <- dashboard views
```

## How to reproduce

1. Download the IPL 2026 ball-by-ball data (Kaggle) and place it in `Dataset/`.
2. Run the Python script to filter to CSK's 14 matches and build the match-result table.
3. Run the SQL scripts in order (`02_...` then `03_...`) in MySQL.
4. Export the result tables to CSV and open the `.pbix` in Power BI Desktop (refresh the CSV source paths if needed).

## Data

- **Source:** ball-by-ball delivery data for all of CSK's 14 matches in the 2026 season (Kaggle), plus a `matches.csv` metadata file.
- **Verification:** all 14 match results were manually cross-checked against official Cricbuzz scorecards. Two matches had a scoring discrepancy from a double-counted `extras` column and were corrected by hand (see `Power BI/key_measures.md`).
- **Supplementary data:** the raw data has no `bowler_type` field (bowling style belongs to the player, not the delivery). A manual lookup table (bowler -> Pace/Spin) was built for all 62 distinct bowlers who dismissed a CSK batter, used to show which bowlers dismissed CSK most often (Rabada, Siraj and Malinga topped the list) and the pace/spin split for each CSK batter.

## Skills demonstrated

- **Python:** data cleaning and transformation with pandas
- **SQL (MySQL):** CTEs, window functions (`DENSE_RANK`, `ROW_NUMBER`), multi-step analysis
- **Power BI:** Power Query, DAX measures, 7-page report design
- **Analytical practice:** data validation against an external source, sample-size awareness, turning findings into recommendations

## Limitations

- **Small sample.** 14 matches in total, with some splits down to n=1. Rates are shown with match counts for that reason.
- **Association, not causation.** Opposition strength, venue, toss and batting first vs chasing were not controlled for.
- **Overlapping findings.** Samson's powerplay dismissals are part of the powerplay wickets lost, so Findings 2 and 3 are related.
- **Public data only.** No tracking, ball-speed, pitch or fitness data.
- **Power BI uses CSV exports,** not a live MySQL connection (the required MySQL Connector/NET version wasn't available), so pre-aggregated CSVs are loaded directly.
- **Bowler pace/spin lookup** is trimmed to a few example rows in the SQL comments (the full list covers 62 bowlers). Extend it if you fork this for another team or season.

## Next steps

- Extend to multiple IPL seasons to test whether these patterns hold.
- Compare CSK against the other nine teams to see if the powerplay and middle-overs patterns are CSK-specific or league-wide.
- Control for batting first vs chasing, venue and opposition.
- Build a simple win-probability model from powerplay state.

---

## Author

**Praises Kalintha** | Data Analyst (SQL, Power BI, Python)

📧 kalinthapraises777@gmail.com
💼 [LinkedIn](https://www.linkedin.com/in/praises-kalintha-30a621354)
🐙 [GitHub](https://github.com/PraisesKalintha)

Feedback is welcome. If you spot an error or have suggestions, please open an issue or message me.
📧 kalinthapraises777@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/praises-kalintha-30a621354/)
💻 [GitHub](https://github.com/PraisesKalintha)

## 📄 License
This project is licensed under the MIT License.
