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

WHERE match_id=202633;
UPDATE result SET csk_score=158, csk_wkts=7,  opp_score=162, result='LOSS' WHERE match_id=202637;
UPDATE result SET csk_score=160, csk_wkts=2,  opp_score=159, result='WIN'  WHERE match_id=202644;
UPDATE result SET csk_score=159, csk_wkts=2,  opp_score=155, result='WIN'  WHERE match_id=202648;
UPDATE result SET csk_score=208, csk_wkts=5,  opp_score=203, result='WIN'  WHERE match_id=202653;
UPDATE result SET csk_score=187, csk_wkts=5,  opp_score=188, result='LOSS' WHERE match_id=202659;
UPDATE result SET csk_score=180, csk_wkts=7,  opp_score=181, result='LOSS' WHERE match_id=202663;
UPDATE result SET csk_score=140, csk_wkts=10, opp_score=229, result='LOSS' WHERE match_id=202666;

)




    

