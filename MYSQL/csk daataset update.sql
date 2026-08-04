use csk_2026;
show tables;

select * from ipl_2026_deliveries;
SHOW COLUMNS FROM ipl_2026_deliveries;

USE csk_2026;

WITH csk_batting_pp AS (
    SELECT
        match_id,
        SUM(runs_of_bat) + SUM(extras) AS pp_runs_scored,
        SUM(CASE WHEN player_dismissed IS NOT NULL AND player_dismissed != ''
                 THEN 1 ELSE 0 END) AS pp_wickets_lost
    FROM ipl_2026_deliveries
    WHERE batting_team = 'CSK'
      AND FLOOR(over_num) <= 5
    GROUP BY match_id
),
csk_bowling_pp AS (
    SELECT
        match_id,
        SUM(runs_of_bat) + SUM(extras) - SUM(byes) - SUM(legbyes) AS pp_runs_conceded,
        SUM(CASE WHEN player_dismissed IS NOT NULL AND player_dismissed != ''
                 THEN 1 ELSE 0 END) AS pp_wickets_taken,
        SUM(CASE WHEN wide = 0 AND noballs = 0 THEN 1 ELSE 0 END) AS pp_legal_balls
    FROM ipl_2026_deliveries
    WHERE bowling_team = 'CSK'
      AND FLOOR(over_num) <= 5
    GROUP BY match_id
),
csk_matches AS (
    SELECT DISTINCT match_id, date_raw,
           CASE WHEN batting_team = 'CSK' THEN bowling_team ELSE batting_team END AS opponent
    FROM ipl_2026_deliveries
    WHERE batting_team = 'CSK' OR bowling_team = 'CSK'
),
innings_totals AS (
    SELECT match_id, innings, batting_team,
           SUM(runs_of_bat) + SUM(extras) AS final_score
    FROM ipl_2026_deliveries
    WHERE match_id IN (SELECT match_id FROM csk_matches)
    GROUP BY match_id, innings, batting_team
),
match_results AS (
    SELECT
        a.match_id,
        a.batting_team AS team1,
        a.final_score AS score1,
        b.batting_team AS team2,
        b.final_score AS score2,
        CASE
            WHEN a.final_score > b.final_score THEN a.batting_team
            WHEN b.final_score > a.final_score THEN b.batting_team
            ELSE 'TIE/CHECK'
        END AS winner
    FROM innings_totals a
    JOIN innings_totals b
        ON a.match_id = b.match_id
        AND a.innings = 1
        AND b.innings = 2
)
SELECT
    m.match_id,
    DATE_FORMAT(STR_TO_DATE(m.date_raw, '%b %d, %Y'), '%d-%m-%Y') AS match_date,
    m.opponent,
    bt.pp_runs_scored,
    bt.pp_wickets_lost,
    bl.pp_runs_conceded,
    bl.pp_wickets_taken,
    bl.pp_legal_balls,
    ROUND(bl.pp_runs_conceded / (bl.pp_legal_balls / 6.0), 2) AS pp_economy_conceded,
    CASE
        WHEN m.match_id = 202603 THEN 'LOSS'
        WHEN m.match_id = 202607 THEN 'LOSS'
        WHEN mr.winner = 'CSK' THEN 'WIN'
        ELSE 'LOSS'
    END AS result
FROM csk_matches m
LEFT JOIN csk_batting_pp bt ON m.match_id = bt.match_id
LEFT JOIN csk_bowling_pp bl ON m.match_id = bl.match_id
LEFT JOIN match_results mr ON m.match_id = mr.match_id
ORDER BY STR_TO_DATE(m.date_raw, '%b %d, %Y');
