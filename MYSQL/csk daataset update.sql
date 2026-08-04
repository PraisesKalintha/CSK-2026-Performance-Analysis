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

SELECT DISTINCT bowler
FROM ipl_2026_deliveries
WHERE batting_team = 'CSK'
  AND player_dismissed IS NOT NULL
  AND player_dismissed != ''
  AND wicket_type NOT IN ('run out')
ORDER BY bowler;

SELECT 
    bowler,
    COUNT(*) AS wickets_vs_csk
FROM ipl_2026_deliveries
WHERE batting_team = 'CSK'
  AND player_dismissed IS NOT NULL
  AND player_dismissed != ''
  AND wicket_type NOT IN ('run out')
GROUP BY bowler
ORDER BY wickets_vs_csk DESC;

CREATE TABLE bowler_type_reference (
    bowler VARCHAR(40) PRIMARY KEY,
    bowling_type VARCHAR(10),
    bowling_style VARCHAR(40)
);

INSERT INTO bowler_type_reference (bowler, bowling_type, bowling_style) VALUES
('AM Ghazanfar','Spin','Off-break'),
('Abhinandan Singh','Pace','Right-arm medium-fast'),
('Abhishek Sharma','Spin','Left-arm orthodox'),
('Aiden Markram','Spin','Off-break'),
('Akash Singh','Pace','Left-arm medium-fast'),
('Akeal Hosein','Spin','Left-arm orthodox'),
('Anukul Roy','Spin','Left-arm orthodox'),
('Anshul Kamboj','Pace','Right-arm seam'),
('Arshad Khan','Pace','Left-arm medium'),
('Arshdeep Singh','Pace','Left-arm medium-fast'),
('Ashwani Kumar','Pace','Left-arm fast-medium'),
('Auqib Nabi','Pace','Right-arm medium-fast'),
('Avesh Khan','Pace','Right-arm fast-medium'),
('Axar Patel','Spin','Left-arm orthodox'),
('Bhuvneshwar Kumar','Pace','Right-arm medium'),
('Brijesh Sharma','Pace','Right-arm medium-fast'),
('Cameron Green','Pace','Right-arm fast-medium'),
('Cooper Connolly','Spin','Left-arm orthodox'),
('David Payne','Pace','Left-arm fast-medium'),
('Digvesh Singh Rathi','Spin','Leg-break/mystery'),
('Eshan Malinga','Pace','Right-arm fast-medium'),
('Glenn Phillips','Spin','Off-break'),
('Hardik Pandya','Pace','Right-arm fast-medium'),
('Harsh Dubey','Spin','Left-arm orthodox'),
('Harshal Patel','Pace','Right-arm medium-fast'),
('Jacob Duffy','Pace','Right-arm fast-medium'),
('Jamie Overton','Pace','Right-arm fast'),
('Jason Holder','Pace','Right-arm fast-medium'),
('Jasprit Bumrah','Pace','Right-arm fast'),
('Jaydev Unadkat','Pace','Left-arm medium-fast'),
('Jofra Archer','Pace','Right-arm fast'),
('Kagiso Rabada','Pace','Right-arm fast'),
('Kartik Tyagi','Pace','Right-arm fast'),
('Khaleel Ahmed','Pace','Left-arm medium-fast'),
('Krish Bhagat','Pace','Right-arm medium'),
('Krunal Pandya','Spin','Left-arm orthodox'),
('Kuldeep Yadav','Spin','Left-arm wrist/chinaman'),
('Lungi Ngidi','Pace','Right-arm fast'),
('Manav Suthar','Spin','Left-arm orthodox'),
('Marco Jansen','Pace','Left-arm fast'),
('Marcus Stoinis','Pace','Right-arm medium'),
('Matt Henry','Pace','Right-arm fast-medium'),
('Matthew Short','Pace','Right-arm medium'),
('Mayank Yadav','Pace','Right-arm fast'),
('Mitchell Marsh','Pace','Right-arm fast-medium'),
('Mitchell Santner','Spin','Left-arm orthodox'),
('Mitchell Starc','Pace','Left-arm fast'),
('Mohammed Shami','Pace','Right-arm fast'),
('Mohammed Siraj','Pace','Right-arm fast'),
('Mukesh Choudhary','Pace','Left-arm medium-fast'),
('Mukesh Kumar','Pace','Right-arm fast-medium'),
('Nandre Burger','Pace','Left-arm fast'),
('Natarajan','Pace','Left-arm fast-medium'),
('Nitish Reddy','Pace','Right-arm medium-fast'),
('Noor Ahmad','Spin','Left-arm wrist'),
('Pat Cummins','Pace','Right-arm fast'),
('Praful Hinge','Pace','Right-arm seam'),
('Prasidh Krishna','Pace','Right-arm fast-medium'),
('Prince Yadav','Pace','Right-arm fast'),
('Raghu Sharma','Spin','Leg-break'),
('Rashid Khan','Spin','Leg-break'),
('Ravi Bishnoi','Spin','Leg-break'),
('Ravindra Jadeja','Spin','Left-arm orthodox'),
('Romario Shepherd','Pace','Right-arm fast-medium'),
('Sakib Hussain','Pace','Right-arm medium-fast'),
('Sandeep Sharma','Pace','Right-arm medium'),
('Shahbaz Ahmed','Spin','Left-arm orthodox'),
('Shardul Thakur','Pace','Right-arm medium-fast'),
('Shivang Kumar','Spin','Left-arm wrist/chinaman'),
('Spencer Johnson','Pace','Left-arm fast'),
('Sunil Narine','Spin','Off-break'),
('Suyash Sharma','Spin','Leg-break/googly'),
('Trent Boult','Pace','Left-arm fast-medium'),
('Vaibhav Arora','Pace','Right-arm swing'),
('Varun Chakaravarthy','Spin','Leg-break/mystery'),
('Vijaykumar Vyshak','Pace','Right-arm medium-fast'),
('Vipraj Nigam','Spin','Leg-break'),
('Washington Sundar','Spin','Off-break'),
('Xavier Bartlett','Pace','Right-arm fast-medium'),
('Yuzvendra Chahal','Spin','Leg-break');

ALTER TABLE ipl_2026_deliveries ADD COLUMN bowling_type VARCHAR(10);
ALTER TABLE ipl_2026_deliveries ADD COLUMN bowling_style VARCHAR(40);

    SET SQL_SAFE_UPDATES = 0;
    UPDATE ipl_2026_deliveries d
JOIN bowler_type_reference r ON d.bowler = r.bowler
SET d.bowling_type = r.bowling_type,
    d.bowling_style = r.bowling_style;
    
    SELECT bowler, bowling_type, bowling_style 
FROM ipl_2026_deliveries 
LIMIT 20;

SELECT 
    bowler,
    bowling_type,
    bowling_style,
    COUNT(*) AS wickets_vs_csk
FROM ipl_2026_deliveries
WHERE batting_team = 'CSK'
  AND player_dismissed IS NOT NULL
  AND player_dismissed != ''
  AND wicket_type != 'run out'
GROUP BY bowler, bowling_type, bowling_style
ORDER BY wickets_vs_csk DESC;

SELECT 
    player_dismissed AS player,
    bowler,
    bowling_type,
    bowling_style,
    COUNT(*) AS dismissals
FROM ipl_2026_deliveries
WHERE batting_team = 'CSK'
  AND player_dismissed IS NOT NULL
  AND player_dismissed != ''
  AND wicket_type != 'run out'
GROUP BY player_dismissed, bowler, bowling_type, bowling_style
ORDER BY player, dismissals DESC;
USE health;

SELECT 
    b.bowler,
    COUNT(DISTINCT b.match_id) AS matches_played,
    COUNT(DISTINCT CASE WHEN r.result = 'WIN' THEN b.match_id END) AS wins,
    COUNT(DISTINCT CASE WHEN r.result = 'LOSS' THEN b.match_id END) AS losses,
    ROUND(
        COUNT(DISTINCT CASE WHEN r.result = 'WIN' THEN b.match_id END) * 100.0 /
        COUNT(DISTINCT b.match_id), 1
    ) AS win_rate,

    COUNT(CASE
        WHEN b.player_dismissed IS NOT NULL
         AND b.player_dismissed <> ''
        THEN 1
    END) AS wickets,

    SUM(CASE
        WHEN b.wide = 0 AND b.noballs = 0
        THEN 1 ELSE 0
    END) AS legal_balls,

    ROUND(
        SUM(b.runs_of_bat + b.wide + b.noballs) * 6.0 /
        NULLIF(SUM(CASE WHEN b.wide = 0 AND b.noballs = 0 THEN 1 ELSE 0 END), 0),
        2
    ) AS economy,

    COUNT(CASE
        WHEN b.`over` <= 5
         AND b.player_dismissed IS NOT NULL
         AND b.player_dismissed <> ''
        THEN 1
    END) AS pp_wickets,

    ROUND(
        SUM(CASE WHEN b.`over` <= 5 THEN b.runs_of_bat + b.wide + b.noballs ELSE 0 END) * 6.0 /
        NULLIF(SUM(CASE WHEN b.`over` <= 5 AND b.wide = 0 AND b.noballs = 0 THEN 1 ELSE 0 END), 0),
        2
    ) AS pp_economy,

    SUM(CASE
        WHEN b.`over` <= 5 AND b.wide = 0 AND b.noballs = 0
        THEN 1 ELSE 0
    END) AS pp_balls,

    COUNT(CASE
        WHEN b.`over` BETWEEN 6 AND 14
         AND b.player_dismissed IS NOT NULL
         AND b.player_dismissed <> ''
        THEN 1
    END) AS mid_wickets,

    ROUND(
        SUM(CASE WHEN b.`over` BETWEEN 6 AND 14 THEN b.runs_of_bat + b.wide + b.noballs ELSE 0 END) * 6.0 /
        NULLIF(SUM(CASE WHEN b.`over` BETWEEN 6 AND 14 AND b.wide = 0 AND b.noballs = 0 THEN 1 ELSE 0 END), 0),
        2
    ) AS mid_economy,

    SUM(CASE
        WHEN b.`over` BETWEEN 6 AND 14
         AND b.wide = 0
         AND b.noballs = 0
        THEN 1 ELSE 0
    END) AS mid_balls,

    COUNT(CASE
        WHEN b.`over` >= 15
         AND b.player_dismissed IS NOT NULL
         AND b.player_dismissed <> ''
        THEN 1
    END) AS death_wickets,

    ROUND(
        SUM(CASE WHEN b.`over` >= 15 THEN b.runs_of_bat + b.wide + b.noballs ELSE 0 END) * 6.0 /
        NULLIF(SUM(CASE WHEN b.`over` >= 15 AND b.wide = 0 AND b.noballs = 0 THEN 1 ELSE 0 END), 0),
        2
    ) AS death_economy,

    SUM(CASE
        WHEN b.`over` >= 15
         AND b.wide = 0
         AND b.noballs = 0
        THEN 1 ELSE 0
    END) AS death_balls,

    SUM(b.wide) AS wides_bowled,
    SUM(b.noballs) AS noballs_bowled,
    SUM(b.wide + b.noballs) AS extras_bowled

FROM bowling b
JOIN result r
    ON b.match_id = r.match_id
GROUP BY b.bowler
HAVING matches_played >= 2
ORDER BY wickets DESC;

USE health;

SELECT 
    r.match_id,
    r.date,
    r.opponent,
    r.result,
    MAX(CASE WHEN b.bowler = 'Akeal Hosein' THEN 'YES' ELSE 'NO' END) AS akeal_played,
    MAX(CASE WHEN b.bowler = 'Jamie Overton' THEN 'YES' ELSE 'NO' END) AS overton_played,
    MAX(CASE WHEN b.bowler = 'Noor Ahmad' THEN 'YES' ELSE 'NO' END) AS noor_played,
    MAX(CASE WHEN b.bowler = 'Mukesh Choudhary' THEN 'YES' ELSE 'NO' END) AS mukesh_played,
    MAX(CASE WHEN b.bowler = 'Khaleel Ahmed' THEN 'YES' ELSE 'NO' END) AS khaleel_played,
    MAX(CASE WHEN b.bowler = 'Gurjapneet Singh' THEN 'YES' ELSE 'NO' END) AS gurjapneet_played
FROM result r
JOIN bowling b ON r.match_id = b.match_id
GROUP BY r.match_id, r.date, r.opponent, r.result
ORDER BY STR_TO_DATE(r.date, '%b %d, %Y');

USE health;

SELECT 
    ROW_NUMBER() OVER (ORDER BY STR_TO_DATE(r.date, '%b %d, %Y')) AS match_no,
    r.date,
    r.opponent,
    r.result,
    MAX(CASE WHEN b.bowler = 'Akeal Hosein' THEN 'YES' ELSE 'NO' END) AS akeal_played,
    MAX(CASE WHEN b.bowler = 'Jamie Overton' THEN 'YES' ELSE 'NO' END) AS overton_played,
    CASE 
        WHEN MAX(CASE WHEN b.bowler = 'Akeal Hosein' THEN 1 ELSE 0 END) = 1
        AND MAX(CASE WHEN b.bowler = 'Jamie Overton' THEN 1 ELSE 0 END) = 1
        THEN 'Both Played'
        WHEN MAX(CASE WHEN b.bowler = 'Akeal Hosein' THEN 1 ELSE 0 END) = 0
        AND MAX(CASE WHEN b.bowler = 'Jamie Overton' THEN 1 ELSE 0 END) = 0
        THEN 'Both Absent'
        WHEN MAX(CASE WHEN b.bowler = 'Akeal Hosein' THEN 1 ELSE 0 END) = 0
        THEN 'Akeal Absent Only'
        ELSE 'Overton Absent Only'
    END AS combination_status
FROM result r
JOIN bowling b ON r.match_id = b.match_id
GROUP BY r.match_id, r.date, r.opponent, r.result
ORDER BY STR_TO_DATE(r.date, '%b %d, %Y');

use csk_2026;
USE health;

-- Economy by over, split by WIN vs LOSS matches
USE csk_2026;
USE csk_2026;

USE csk_2026;

SELECT 
    FLOOR(b.over_num) + 1 AS over_number,
    b.bowler,
    COUNT(DISTINCT b.match_id) AS matches_bowled,
    SUM(CASE WHEN b.wide=0 AND b.noballs=0 THEN 1 ELSE 0 END) AS legal_balls,
    SUM(b.runs_of_bat + b.wide + b.noballs) AS runs_conceded,
    ROUND(SUM(b.runs_of_bat + b.wide + b.noballs) * 6.0 / 
          NULLIF(SUM(CASE WHEN b.wide=0 AND b.noballs=0 THEN 1 ELSE 0 END),0), 2) AS economy,
    COUNT(CASE WHEN b.player_dismissed IS NOT NULL 
               AND b.player_dismissed != '' THEN 1 END) AS wickets,
    ROUND(COUNT(DISTINCT CASE WHEN r.result='WIN' THEN b.match_id END) * 100.0 /
          COUNT(DISTINCT b.match_id), 1) AS win_rate
FROM ipl_2026_deliveries b
JOIN health.result r ON b.match_id = r.match_id
WHERE b.bowling_team = 'CSK'
GROUP BY FLOOR(b.over_num) + 1, b.bowler
HAVING legal_balls >= 6
ORDER BY over_number, economy ASC;