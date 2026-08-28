create database CSK_2026;
use csk_2026;

show tables;
SELECT table_schema, table_name
FROM information_schema.tables;

use health;
show tables;
select * from batting;
rename table  csk_batting_2026 to batting;
rename table csk_bowling_2026 to bowling;
rename table csk_results_2026 to result;

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name IN ('batting', 'bowling', 'results');
USE health;

USE health;
select * from batting;

-- Safe to drop — only 14 summary rows
DROP TABLE IF EXISTS result;

CREATE TABLE result (
    match_id    INT,
    date        VARCHAR(20),
    venue       VARCHAR(100),
    opponent    VARCHAR(10),
    csk_score   INT,
    csk_wkts    INT,
    opp_score   INT,
    result      VARCHAR(4)
);

INSERT INTO result VALUES
(202603,'Mar 30, 2026','MA Chidambaram Stadium, Chennai',                         'RR',   127,10,128,'LOSS'),
(202607,'Apr 3, 2026', 'Barsapara Cricket Stadium, Guwahati',                     'PBKS', 209, 5,210,'LOSS'),
(202611,'Apr 5, 2026', 'M.Chinnaswamy Stadium, Bengaluru',                        'RCB',  207,10,250,'LOSS'),
(202618,'Apr 11, 2026','MA Chidambaram Stadium, Chennai',                         'DC',   212, 1,189,'WIN'),
(202622,'Apr 14, 2026','MA Chidambaram Stadium, Chennai',                         'KKR',  192, 5,160,'WIN'),
(202627,'Apr 18, 2026','Rajiv Gandhi International Stadium, Hyderabad',           'SRH',  184, 8,194,'LOSS'),
(202633,'Apr 23, 2026','Wankhede Stadium, Mumbai',                                'MI',   207, 6,104,'WIN'),
(202637,'Apr 26, 2026','MA Chidambaram Stadium, Chennai',                         'GT',   158, 7,162,'LOSS'),
(202644,'May 2, 2026', 'MA Chidambaram Stadium, Chennai',                         'MI',   160, 2,159,'WIN'),
(202648,'May 5, 2026', 'Arun Jaitley Stadium, Delhi',                             'DC',   159, 2,155,'WIN'),
(202653,'May 10, 2026','MA Chidambaram Stadium, Chennai',                         'LSG',  208, 5,203,'WIN'),
(202659,'May 15, 2026','Bharat Ratna Atal Bihari Vajpayee Ekana Stadium, Lucknow','LSG',  187, 5,188,'LOSS'),
(202663,'May 18, 2026','MA Chidambaram Stadium, Chennai',                         'SRH',  180, 7,181,'LOSS'),
(202666,'May 21, 2026','Narendra Modi Stadium, Ahmedabad',                        'GT',   140,10,229,'LOSS');

-- Verify
SELECT date, opponent, csk_score,
       opp_score, result
FROM result
ORDER BY date;

SELECT result, COUNT(*) AS matches
FROM result
GROUP BY result;

USE health;

SELECT match_id, date, opponent, 
       csk_score, opp_score, result
FROM result
ORDER BY date;

USE health;

-- Step 1: Confirm table is empty first
DELETE FROM result;

-- Step 2: Verify it's empty
SELECT COUNT(*) FROM result;

USE health;

-- Force delete all rows
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE result;
SET FOREIGN_KEY_CHECKS = 1;

-- Verify empty
SELECT COUNT(*) FROM result;

USE health;

-- Check if truncate works
TRUNCATE TABLE result;

-- Immediately check
SELECT COUNT(*) FROM result;

-- Check table structure
SHOW CREATE TABLE result;

USE health;

SET SQL_SAFE_UPDATES = 0;
UPDATE result SET csk_score=127, csk_wkts=10, opp_score=128, result='LOSS' WHERE match_id=202603;
UPDATE result SET csk_score=209, csk_wkts=5,  opp_score=210, result='LOSS' WHERE match_id=202607;
UPDATE result SET csk_score=207, csk_wkts=10, opp_score=250, result='LOSS' WHERE match_id=202611;
UPDATE result SET csk_score=212, csk_wkts=1,  opp_score=189, result='WIN'  WHERE match_id=202618;
UPDATE result SET csk_score=192, csk_wkts=5,  opp_score=160, result='WIN'  WHERE match_id=202622;
UPDATE result SET csk_score=184, csk_wkts=8,  opp_score=194, result='LOSS' WHERE match_id=202627;
UPDATE result SET csk_score=207, csk_wkts=6,  opp_score=104, result='WIN'  WHERE match_id=202633;
UPDATE result SET csk_score=158, csk_wkts=7,  opp_score=162, result='LOSS' WHERE match_id=202637;
UPDATE result SET csk_score=160, csk_wkts=2,  opp_score=159, result='WIN'  WHERE match_id=202644;
UPDATE result SET csk_score=159, csk_wkts=2,  opp_score=155, result='WIN'  WHERE match_id=202648;
UPDATE result SET csk_score=208, csk_wkts=5,  opp_score=203, result='WIN'  WHERE match_id=202653;
UPDATE result SET csk_score=187, csk_wkts=5,  opp_score=188, result='LOSS' WHERE match_id=202659;
UPDATE result SET csk_score=180, csk_wkts=7,  opp_score=181, result='LOSS' WHERE match_id=202663;
UPDATE result SET csk_score=140, csk_wkts=10, opp_score=229, result='LOSS' WHERE match_id=202666;

-- Verify
SELECT date, opponent, csk_score, opp_score, result
FROM result
ORDER BY date;

-- Confirm counts
SELECT result, COUNT(*) AS matches
FROM result
GROUP BY result;

USE health;

-- ================================================
-- QUERY 1: POWERPLAY LAW
-- ================================================

SELECT
    CASE
        WHEN pp_wkts <= 1 THEN '0-1 Wickets'
        WHEN pp_wkts  = 2 THEN '2 Wickets'
        ELSE                   '3+ Wickets'
    END                             AS pp_band,
    COUNT(*)                        AS matches,
    COUNT(DISTINCT CASE WHEN result = 'WIN'
        THEN match_id END)          AS wins,
    COUNT(DISTINCT CASE WHEN result = 'LOSS'
        THEN match_id END)          AS losses,
    CONCAT(ROUND(
        COUNT(DISTINCT CASE WHEN result = 'WIN'
            THEN match_id END) * 100.0
        / COUNT(*), 0
    ), '%')                         AS win_rate
FROM (
    SELECT
        r.match_id,
        r.result,
        COUNT(
            CASE
                WHEN b.`over` <= 5
                AND b.player_dismissed IS NOT NULL
                AND b.player_dismissed != ''
                THEN 1
            END
        )                           AS pp_wkts
    FROM result r
    JOIN batting b ON r.match_id = b.match_id
    GROUP BY r.match_id, r.result
) AS pp_data
GROUP BY pp_band
ORDER BY wins DESC;

-- ================================================
-- QUERY 2: SAMSON LAW
-- ================================================

SELECT
    innings_type,
    COUNT(*)                        AS matches,
    COUNT(DISTINCT CASE WHEN result = 'WIN'
        THEN match_id END)          AS wins,
    COUNT(DISTINCT CASE WHEN result = 'LOSS'
        THEN match_id END)          AS losses,
    CONCAT(ROUND(
        COUNT(DISTINCT CASE WHEN result = 'WIN'
            THEN match_id END) * 100.0
        / COUNT(*), 0
    ), '%')                         AS win_rate,
    ROUND(AVG(samson_runs), 1)      AS avg_runs,
    ROUND(AVG(samson_sr), 1)        AS avg_sr
FROM (
    SELECT
        r.match_id,
        r.result,
        SUM(b.runs_of_bat)          AS samson_runs,
        ROUND(
            SUM(b.runs_of_bat) * 100.0 /
            NULLIF(SUM(CASE WHEN b.wide = 0
                   THEN 1 ELSE 0 END), 0)
        , 1)                        AS samson_sr,
        CASE
            WHEN SUM(b.runs_of_bat) >= 30
            AND ROUND(
                SUM(b.runs_of_bat) * 100.0 /
                NULLIF(SUM(CASE WHEN b.wide = 0
                       THEN 1 ELSE 0 END), 0)
            , 1) >= 140
            THEN 'IMPACT'
            WHEN SUM(CASE WHEN b.wide = 0
                THEN 1 ELSE 0 END) <= 7
            AND SUM(b.runs_of_bat) <= 10
            THEN 'FAILED'
            ELSE 'MODERATE'
        END                         AS innings_type
    FROM result r
    JOIN batting b
        ON  r.match_id = b.match_id
        AND b.striker  = 'Sanju Samson'
    GROUP BY r.match_id, r.result
) AS samson_data
GROUP BY innings_type
ORDER BY win_rate DESC;

-- ================================================
-- QUERY 3: BOWLER WIN RATE
-- ================================================

SELECT
    b.bowler,
    COUNT(DISTINCT b.match_id)          AS matches_played,
    COUNT(DISTINCT CASE WHEN r.result = 'WIN'
        THEN b.match_id END)            AS wins,
    COUNT(DISTINCT CASE WHEN r.result = 'LOSS'
        THEN b.match_id END)            AS losses,
    CONCAT(ROUND(
        COUNT(DISTINCT CASE WHEN r.result = 'WIN'
            THEN b.match_id END) * 100.0
        / COUNT(DISTINCT b.match_id), 0
    ), '%')                             AS win_rate,
    COUNT(CASE
        WHEN b.player_dismissed IS NOT NULL
        AND  b.player_dismissed != ''
        THEN 1 END)                     AS wickets,
    ROUND(
        SUM(b.runs_of_bat + b.wide + b.noballs)
        / (COUNT(CASE WHEN b.wide = 0
                 AND b.noballs = 0
                 THEN 1 END) / 6.0)
    , 2)                                AS economy
FROM bowling b
JOIN result r ON b.match_id = r.match_id
WHERE b.bowler IN (
    'Akeal Hosein',
    'Jamie Overton',
    'Anshul Kamboj',
    'Noor Ahmad',
    'Mukesh Choudhary'
)
GROUP BY b.bowler
ORDER BY win_rate DESC;

-- ================================================
-- QUERY 4A: INDIVIDUAL BOWLER PRESENCE IMPACT
-- ================================================

SELECT
    bowler_status,
    COUNT(*)                        AS matches,
    SUM(CASE WHEN result = 'WIN'
        THEN 1 ELSE 0 END)          AS wins,
    SUM(CASE WHEN result = 'LOSS'
        THEN 1 ELSE 0 END)          AS losses,
    CONCAT(ROUND(
        SUM(CASE WHEN result = 'WIN'
            THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 0
    ), '%')                         AS win_rate
FROM (
    SELECT r.match_id, r.result,
        CASE
            WHEN r.match_id IN (
                SELECT DISTINCT match_id FROM bowling
                WHERE bowler = 'Akeal Hosein'
            )
            THEN 'Akeal Played'
            ELSE 'Akeal Absent'
        END AS bowler_status
    FROM result r

    UNION ALL

    SELECT r.match_id, r.result,
        CASE
            WHEN r.match_id IN (
                SELECT DISTINCT match_id FROM bowling
                WHERE bowler = 'Jamie Overton'
            )
            THEN 'Overton Played'
            ELSE 'Overton Absent'
        END AS bowler_status
    FROM result r
) AS individual_impact
GROUP BY bowler_status
ORDER BY
    CASE bowler_status
        WHEN 'Akeal Played'   THEN 1
        WHEN 'Akeal Absent'   THEN 2
        WHEN 'Overton Played' THEN 3
        WHEN 'Overton Absent' THEN 4
    END;


-- ================================================
-- QUERY 4B: COMBINED COMBINATION IMPACT
-- ================================================

SELECT
    combination_status,
    COUNT(*)                        AS matches,
    SUM(CASE WHEN result = 'WIN'
        THEN 1 ELSE 0 END)          AS wins,
    SUM(CASE WHEN result = 'LOSS'
        THEN 1 ELSE 0 END)          AS losses,
    CONCAT(ROUND(
        SUM(CASE WHEN result = 'WIN'
            THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 0
    ), '%')                         AS win_rate
FROM (
    SELECT
        r.match_id,
        r.result,
        CASE
            WHEN r.match_id IN (
                SELECT DISTINCT match_id FROM bowling
                WHERE bowler = 'Akeal Hosein'
            )
            AND r.match_id IN (
                SELECT DISTINCT match_id FROM bowling
                WHERE bowler = 'Jamie Overton'
            )
            THEN 'Both Played'
            WHEN r.match_id NOT IN (
                SELECT DISTINCT match_id FROM bowling
                WHERE bowler = 'Akeal Hosein'
            )
            AND r.match_id NOT IN (
                SELECT DISTINCT match_id FROM bowling
                WHERE bowler = 'Jamie Overton'
            )
            THEN 'Both Absent'
            WHEN r.match_id NOT IN (
                SELECT DISTINCT match_id FROM bowling
                WHERE bowler = 'Akeal Hosein'
            )
            THEN 'Akeal Absent Only'
            ELSE 'Overton Absent Only'
        END AS combination_status
    FROM result r
) AS combo
GROUP BY combination_status
ORDER BY
    CASE combination_status
        WHEN 'Both Played'         THEN 1
        WHEN 'Akeal Absent Only'   THEN 2
        WHEN 'Overton Absent Only' THEN 3
        WHEN 'Both Absent'         THEN 4
    END;

-- ================================================
-- QUERY 5: KAMBOJ TOURNAMENT PHASE ANALYSIS
-- Group 1: Matches 1-3  (struggled early)
-- Group 2: Matches 4-10 (found form)
-- Group 3: Matches 11-14 (decoded and expensive)
-- ================================================

SELECT
    tournament_phase,
    COUNT(DISTINCT match_id)            AS matches,

    -- Overall
    SUM(total_wickets)                  AS total_wickets,
    ROUND(AVG(economy), 2)              AS avg_economy,

    -- Powerplay
    SUM(pp_wickets)                     AS pp_wickets,
    ROUND(AVG(pp_economy), 2)           AS pp_avg_economy,

    -- Middle
    SUM(mid_wickets)                    AS mid_wickets,
    ROUND(AVG(mid_economy), 2)          AS mid_avg_economy,

    -- Death
    SUM(death_wickets)                  AS death_wickets,
    ROUND(AVG(death_economy), 2)        AS death_avg_economy

FROM (
    SELECT
        b.match_id,
        CASE
            WHEN ROW_NUMBER() OVER (
                ORDER BY r.date
            ) <= 3
            THEN 'Phase 1 — M1 to M3 '
            WHEN ROW_NUMBER() OVER (
                ORDER BY r.date
            ) <= 10
            THEN 'Phase 2 — M4 to M10 '
            ELSE
                 'Phase 3 — M11 to M14 '
        END                             AS tournament_phase,

        -- Overall
        ROUND(
            SUM(b.runs_of_bat + b.wide + b.noballs)
            / (COUNT(CASE WHEN b.wide = 0
                     AND b.noballs = 0
                     THEN 1 END) / 6.0)
        , 2)                            AS economy,

        COUNT(CASE
            WHEN b.player_dismissed IS NOT NULL
            AND  b.player_dismissed != ''
            THEN 1 END)                 AS total_wickets,

        -- Powerplay
        ROUND(
            SUM(CASE WHEN b.`over` <= 5
                THEN b.runs_of_bat + b.wide + b.noballs
                ELSE 0 END)
            / NULLIF(COUNT(CASE WHEN b.`over` <= 5
                     AND b.wide = 0
                     AND b.noballs = 0
                     THEN 1 END) / 6.0, 0)
        , 2)                            AS pp_economy,

        COUNT(CASE
            WHEN b.`over` <= 5
            AND  b.player_dismissed IS NOT NULL
            AND  b.player_dismissed != ''
            THEN 1 END)                 AS pp_wickets,

        -- Middle
        ROUND(
            SUM(CASE WHEN b.`over` BETWEEN 6 AND 14
                THEN b.runs_of_bat + b.wide + b.noballs
                ELSE 0 END)
            / NULLIF(COUNT(CASE WHEN b.`over` BETWEEN 6 AND 14
                     AND b.wide = 0
                     AND b.noballs = 0
                     THEN 1 END) / 6.0, 0)
        , 2)                            AS mid_economy,

        COUNT(CASE
            WHEN b.`over` BETWEEN 6 AND 14
            AND  b.player_dismissed IS NOT NULL
            AND  b.player_dismissed != ''
            THEN 1 END)                 AS mid_wickets,

        -- Death
        ROUND(
            SUM(CASE WHEN b.`over` >= 15
                THEN b.runs_of_bat + b.wide + b.noballs
                ELSE 0 END)
            / NULLIF(COUNT(CASE WHEN b.`over` >= 15
                     AND b.wide = 0
                     AND b.noballs = 0
                     THEN 1 END) / 6.0, 0)
        , 2)                            AS death_economy,

        COUNT(CASE
            WHEN b.`over` >= 15
            AND  b.player_dismissed IS NOT NULL
            AND  b.player_dismissed != ''
            THEN 1 END)                 AS death_wickets

    FROM bowling b
    JOIN result r ON b.match_id = r.match_id
    WHERE b.bowler = 'Anshul Kamboj'
    GROUP BY b.match_id, r.date
) AS kamboj_phases
GROUP BY tournament_phase
ORDER BY tournament_phase;

-- QUERY 6: COMPLETE BATTING AUDIT

WITH MatchEntry AS (
    -- 1. Calculate the batting entry order per match for each player
    SELECT 
        match_id,
        striker,
        MIN(`over`) AS first_over_faced,
        -- Ranks players by when they entered the crease in a match
        DENSE_RANK() OVER (PARTITION BY match_id ORDER BY MIN(`over`)) AS match_batting_position
    FROM batting
    GROUP BY match_id, striker
),
PlayerAvgOrder AS (
    -- 2. Find the average batting position for the player across the tournament
    SELECT 
        striker,
        ROUND(AVG(match_batting_position)) AS numeric_batting_order
    FROM MatchEntry
    GROUP BY striker
),
BaseData AS (
    -- 3. Core delivery data 
    SELECT 
        b.match_id,
        b.striker,
        b.runs_of_bat,
        CASE WHEN b.wide = 0 THEN 1 ELSE 0 END AS balls_faced,

        -- PP runs, balls, dismissals
        CASE WHEN b.`over` <= 5 THEN b.runs_of_bat ELSE 0 END AS pp_runs,
        CASE WHEN b.`over` <= 5 AND b.wide = 0 THEN 1 ELSE 0 END AS pp_balls,
        CASE WHEN b.`over` <= 5 AND b.player_dismissed = b.striker THEN 1 ELSE 0 END AS pp_dismissals,

        -- Middle runs, balls, dismissals
        CASE WHEN b.`over` BETWEEN 6 AND 14 THEN b.runs_of_bat ELSE 0 END AS mid_runs,
        CASE WHEN b.`over` BETWEEN 6 AND 14 AND b.wide = 0 THEN 1 ELSE 0 END AS mid_balls,
        CASE WHEN b.`over` BETWEEN 6 AND 14 AND b.player_dismissed = b.striker THEN 1 ELSE 0 END AS mid_dismissals,

        -- Death runs, balls, dismissals
        CASE WHEN b.`over` >= 15 THEN b.runs_of_bat ELSE 0 END AS death_runs,
        CASE WHEN b.`over` >= 15 AND b.wide = 0 THEN 1 ELSE 0 END AS death_balls,
        CASE WHEN b.`over` >= 15 AND b.player_dismissed = b.striker THEN 1 ELSE 0 END AS death_dismissals

    FROM batting b
),
AggregatedData AS (
    -- 4. Aggregate all stats into a single row per player
    SELECT 
        d.striker AS player,
        p.numeric_batting_order,
        COUNT(DISTINCT d.match_id) AS matches,
        SUM(d.runs_of_bat) AS total_runs,
        SUM(d.balls_faced) AS total_balls,
        ROUND(SUM(d.runs_of_bat) * 100.0 / NULLIF(SUM(d.balls_faced), 0), 1) AS overall_sr,
        
        SUM(d.pp_runs) AS pp_runs,
        ROUND(SUM(d.pp_runs) * 100.0 / NULLIF(SUM(d.pp_balls), 0), 1) AS pp_sr,
        SUM(d.pp_dismissals) AS pp_dismissals,
        
        SUM(d.mid_runs) AS mid_runs,
        ROUND(SUM(d.mid_runs) * 100.0 / NULLIF(SUM(d.mid_balls), 0), 1) AS mid_sr,
        SUM(d.mid_dismissals) AS mid_dismissals,
        
        SUM(d.death_runs) AS death_runs,
        ROUND(SUM(d.death_runs) * 100.0 / NULLIF(SUM(d.death_balls), 0), 1) AS death_sr,
        SUM(d.death_dismissals) AS death_dismissals

    FROM BaseData d
    JOIN PlayerAvgOrder p ON d.striker = p.striker
    GROUP BY d.striker, p.numeric_batting_order
)
-- 5. Final Select to replace NULLs with 0 and apply strict numeric ordering
SELECT 
    numeric_batting_order AS batting_order,
    player,
    COALESCE(matches, 0) AS matches,
    COALESCE(total_runs, 0) AS total_runs,
    COALESCE(total_balls, 0) AS total_balls,
    COALESCE(overall_sr, 0) AS overall_sr,
    COALESCE(pp_runs, 0) AS pp_runs,
    COALESCE(pp_sr, 0) AS pp_sr,
    COALESCE(pp_dismissals, 0) AS pp_dismissals,
    COALESCE(mid_runs, 0) AS mid_runs,
    COALESCE(mid_sr, 0) AS mid_sr,
    COALESCE(mid_dismissals, 0) AS mid_dismissals,
    COALESCE(death_runs, 0) AS death_runs,
    COALESCE(death_sr, 0) AS death_sr,
    COALESCE(death_dismissals, 0) AS death_dismissals
FROM AggregatedData
ORDER BY 
    numeric_batting_order ASC,
    total_runs DESC;
    
    USE health;
SELECT * FROM result
ORDER BY date;

SELECT STR_TO_DATE(date, '%b %d, %Y') AS converted_date
FROM result;

select * from result 
order by date;

SELECT
    match_id,
    DATE_FORMAT(STR_TO_DATE(date, '%b %d, %Y'), '%d-%m-%Y') AS date,
    venue,
    opponent,
    csk_score,
    csk_wkts,
    opp_score,
    result
FROM result;

use health;

-- bowling
USE health;

SELECT 
    b.bowler,
    COUNT(DISTINCT b.match_id) AS matches_played,
    COUNT(DISTINCT CASE WHEN r.result = 'WIN' THEN b.match_id END) AS wins,
    COUNT(DISTINCT CASE WHEN r.result = 'LOSS' THEN b.match_id END) AS losses,
    ROUND(COUNT(DISTINCT CASE WHEN r.result = 'WIN' THEN b.match_id END) * 100.0 
          / COUNT(DISTINCT b.match_id), 1) AS win_rate,
    COUNT(CASE WHEN b.player_dismissed IS NOT NULL 
               AND b.player_dismissed != '' THEN 1 END) AS wickets,
    SUM(CASE WHEN b.wide = 0 AND b.noballs = 0 THEN 1 ELSE 0 END) AS legal_balls,
    ROUND(SUM(b.runs_of_bat + b.wide + b.noballs) * 6.0 / 
          NULLIF(SUM(CASE WHEN b.wide = 0 AND b.noballs = 0 THEN 1 ELSE 0 END), 0), 2) AS economy,
    -- Powerplay
    COUNT(CASE WHEN b.`over` <= 5 AND b.player_dismissed IS NOT NULL 
               AND b.player_dismissed != '' THEN 1 END) AS pp_wickets,
    ROUND(SUM(CASE WHEN b.`over` <= 5 THEN b.runs_of_bat + b.wide + b.noballs ELSE 0 END) * 6.0 /
          NULLIF(SUM(CASE WHEN b.`over` <= 5 AND b.wide = 0 AND b.noballs = 0 THEN 1 ELSE 0 END), 0), 2) AS pp_economy,
    -- Middle
    COUNT(CASE WHEN b.`over` BETWEEN 6 AND 14 AND b.player_dismissed IS NOT NULL 
               AND b.player_dismissed != '' THEN 1 END) AS mid_wickets,
    ROUND(SUM(CASE WHEN b.`over` BETWEEN 6 AND 14 THEN b.runs_of_bat + b.wide + b.noballs ELSE 0 END) * 6.0 /
          NULLIF(SUM(CASE WHEN b.`over` BETWEEN 6 AND 14 AND b.wide = 0 AND b.noballs = 0 THEN 1 ELSE 0 END), 0), 2) AS mid_economy,
    -- Death
    COUNT(CASE WHEN b.`over` >= 15 AND b.player_dismissed IS NOT NULL 
               AND b.player_dismissed != '' THEN 1 END) AS death_wickets,
    ROUND(SUM(CASE WHEN b.`over` >= 15 THEN b.runs_of_bat + b.wide + b.noballs ELSE 0 END) * 6.0 /
          NULLIF(SUM(CASE WHEN b.`over` >= 15 AND b.wide = 0 AND b.noballs = 0 THEN 1 ELSE 0 END), 0), 2) AS death_economy
FROM bowling b
JOIN result r ON b.match_id = r.match_id
GROUP BY b.bowler
HAVING matches_played >= 2
ORDER BY wickets DESC;

show tables;
show databases;
use health;
use csk_2026;
show tables;
DESCRIBE ipl_2026_deliveries;

SELECT
    FLOOR(over_num) + 1 AS Over_Number,
    bowler,
    COUNT(DISTINCT match_no) AS MatchesBowled,
    SUM(runs_of_bat + extras) AS Runsconceded,
    SUM(CASE WHEN player_dismissed != '' AND player_dismissed IS NOT NULL THEN 1 ELSE 0 END) AS Wickets,
    ROUND(SUM(runs_of_bat + extras) / (SUM(CASE WHEN wide = 0 AND noballs = 0 THEN 1 ELSE 0 END) / 6.0), 2) AS Economy
FROM ipl_2026_deliveries
WHERE bowling_team = 'CSK'
GROUP BY FLOOR(over_num) + 1, bowler
ORDER BY over_number ASC, economy ASC;

SELECT
    bowling_style, 
    SUM(runs_of_bat + extras) AS runs_scored,
    COUNT(player_dismissed) AS wickets_lost,
    ROUND(SUM(runs_of_bat + extras) / NULLIF(COUNT(player_dismissed), 0), 2) AS average_runs_per_wicket,
    ROUND(SUM(runs_of_bat + extras) / (SUM(CASE WHEN wide = 0 AND noballs = 0 THEN 1 ELSE 0 END) / 6.0), 2) AS economy_against
FROM ipl_2026_deliveries
WHERE batting_team = 'CSK' 
  AND FLOOR(over_num) BETWEEN 6 AND 14
GROUP BY bowling_style
ORDER BY average_runs_per_wicket ASC;

SELECT
    striker AS batter,
    bowling_style,
    SUM(runs_of_bat) AS runs_scored,
    SUM(CASE WHEN wide = 0 THEN 1 ELSE 0 END) AS balls_faced,
    SUM(CASE WHEN player_dismissed != '' AND player_dismissed IS NOT NULL THEN 1 ELSE 0 END) AS dismissals_against_style,
    ROUND((SUM(runs_of_bat) * 100.0) / NULLIF(SUM(CASE WHEN wide = 0 THEN 1 ELSE 0 END), 0), 2) AS strike_rate
FROM ipl_2026_deliveries
WHERE batting_team = 'CSK' 
  AND FLOOR(over_num) BETWEEN 6 AND 14
GROUP BY striker, bowling_style
HAVING balls_faced >= 10  -- Filters out tiny sample sizes (e.g., facing only 2 balls)
ORDER BY batter ASC, strike_rate DESC;

SELECT
    striker AS batter,
    bowling_style,
    SUM(runs_of_bat) AS runs_scored,
    SUM(CASE WHEN wide = 0 THEN 1 ELSE 0 END) AS balls_faced,
    SUM(CASE WHEN player_dismissed != '' AND player_dismissed IS NOT NULL THEN 1 ELSE 0 END) AS dismissals_against_style,
    ROUND((SUM(runs_of_bat) * 100.0) / NULLIF(SUM(CASE WHEN wide = 0 THEN 1 ELSE 0 END), 0), 2) AS strike_rate
FROM ipl_2026_deliveries
WHERE batting_team = 'CSK' 
GROUP BY striker, bowling_style
HAVING balls_faced >= 10
ORDER BY batter ASC, strike_rate DESC;



    

