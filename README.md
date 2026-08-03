CSK 2026 Season Performance Analysis
A full-season data pipeline and Power BI deep-dive into Chennai Super Kings'
IPL 2026 campaign — built end-to-end from raw ball-by-ball data to answer one
question: what actually predicts a win, and why did the losses happen?
Stack: Python (Pandas) → MySQL → Power BI (DAX)
---
🔑 Key Findings
Mid-innings wickets predict wins almost perfectly — 86% win rate with
3+ wickets taken in the middle overs, 0% with fewer than 3 (7 matches each
way).
A single top-order batter's powerplay survival is CSK's clearest single
win predictor this season — 100% win rate when he survives the
powerplay, 11% when he's dismissed early.
Blowout losses trace to a top-order batting collapse, not slow scoring
or bowling — two specific batters show the sharpest form swings between
wins and losses of anyone in the squad.
CSK has no designated death-overs finisher — death-overs batting
responsibility is split across 11 different players, including bowlers,
with no consistent specialist taking on the role.
CSK's season overall was decisive rather than dramatic — 11 of 14 matches
were blowouts (either way), with only 3 genuine nail-biters.
---
🛠 Pipeline
1. Data Loading & Cleaning (Python)
Loaded and merged multi-season ball-by-ball delivery and match data in
Pandas. Validated null values and match-ID overlaps across ~20,000+ rows,
engineered match- and player-level features (entry over, strike rate,
dot-ball %, phase classification), and exported cleaned datasets.
→ `/python`
2. Relational Modeling & Querying (MySQL)
Designed a normalized schema (`batting`, `bowling`, `result` tables) and
wrote complex queries — CTEs, window functions (`ROW_NUMBER`, `DENSE_RANK`),
multi-table joins, and a bowler-style reference table merged in via a
JOIN-based `UPDATE` — to quantify win-rate drivers by phase, bowler, and
batting position.
→ `/sql`
3. Visualization & Reporting (Power BI + DAX)
Built a 7-page interactive report translating the SQL/Python findings into
an executive-ready story, with custom DAX measures for phase-based
economy, win-rate buckets, and match-closeness classification.
→ `CSK_2026.pbix`
---
📊 Report Structure
Season Overview — headline KPIs and full match results
Powerplay Audit — early-wicket impact on win rate
Batting Performance / Bowling Performance — foundational phase-by-phase stats
The Wicket Effect — the middle-overs wicket threshold and bowling partnership
Loss Autopsy — match closeness and the batting-collapse diagnosis
Results & Recommendations — five data-backed, actionable recommendations
See `/screenshots` for full-page views.
---
🐛 Data Quality — Bugs Caught & Fixed
Three real data-integrity issues were identified and corrected mid-analysis
rather than patched over:
A match-type field (batting first vs. chasing) was mislabeled for 5 of
14 matches — caught by cross-checking against real match scorecards and
corrected at the source.
A disconnected lookup table was silently producing a single flat,
repeated value instead of real per-player results — traced to a missing
table relationship and rebuilt from the ball-by-ball source table.
A DAX filter-context bug caused a measure to silently discard an
active slicer/legend split — fixed using `KEEPFILTERS`.
Full writeup with before/after DAX: `/dax/key_measures.md`
