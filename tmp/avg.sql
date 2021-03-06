SELECT
       `trading_date`                                                            as date,
       `bond_id`,
       AVG(coalesce(`bid`, 0)) over w as aBid,
       AVG(coalesce(`ask`, 0)) over w as aAsk
FROM `exch_quotes_archive`
WHERE `trading_date`
          BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
GROUP BY `bond_id`, `trading_date`
WINDOW w AS (partition by trading_date order by bond_id)
ORDER BY trading_date DESC;



select *
from (
         SELECT
             `trading_date`                                                            as date,
             `bond_id`,
             AVG(coalesce(`bid`, 0)) over w as aBid,
             AVG(coalesce(`ask`, 0)) over w as aAsk
         FROM `exch_quotes_archive` WHERE `trading_date`  BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
        union all
         (
             SELECT
                     MAKEDATE(YEAR(NOW()),1) +
                     INTERVAL (MONTH(NOW())-1) MONTH +
                     INTERVAL daynum DAY date_field
             FROM
                 (
                     SELECT t*10+u daynum
                     FROM
                         (SELECT 0 t UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) A,
                         (SELECT 0 u UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
                          UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
                          UNION SELECT 8 UNION SELECT 9) B
                     ORDER BY daynum
                 ) AA
         )

     ) a

GROUP BY `bond_id`, `trading_date`
WINDOW w AS (partition by trading_date order by bond_id)
ORDER BY trading_date DESC;

SELECT date_field
FROM
    (
        SELECT
                MAKEDATE(YEAR(NOW()),1) +
                INTERVAL (MONTH(NOW())-1) MONTH +
                INTERVAL daynum DAY date_field
        FROM
            (
                SELECT t*10+u daynum
                FROM
                    (SELECT 0 t UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) A,
                    (SELECT 0 u UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
                     UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
                     UNION SELECT 8 UNION SELECT 9) B
                ORDER BY daynum
            ) AA
    ) AAA
WHERE MONTH(date_field) = MONTH(NOW()) LIMIT 31;


SELECT date_field, NULL, NUll, NUll
FROM
    (
        SELECT
                MAKEDATE(
                    YEAR(NOW()),1
                    ) +
                INTERVAL (MONTH(NOW())-1) MONTH +
                INTERVAL daynum DAY date_field
        FROM
            (
                SELECT t*10+u as daynum
                FROM
                    (SELECT 0 t UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) A,
                    (SELECT 0 u UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7    UNION SELECT 8 UNION SELECT 9) B
                where t*10+u <= 14
                ORDER BY daynum desc
            ) AA

    ) AAA;

SELECT  2+x*100+y*10+z bond_id
FROM
    (SELECT 0 x UNION SELECT 1) BA,
    (SELECT 0 y UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
     UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
     UNION SELECT 8 UNION SELECT 9) BB,
    (SELECT 0 z UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
     UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
     UNION SELECT 8 UNION SELECT 9) BC
ORDER BY bond_id desc;

SELECT DISTINCT(bond_id) FROM `exch_quotes_archive`;

SELECT trading_date as date, bond_id, aBid, aAsk
FROM
    (
        SELECT
                MAKEDATE(YEAR(current_date()), DAYOFYEAR(current_date())) - INTERVAL daynum DAY as trading_date,bond_id,NULL as aBid, NUll as aAsk
        FROM
            (
                SELECT 0 daynum
                UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
                UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
                UNION SELECT 7    UNION SELECT 8 UNION SELECT 9
                UNION SELECT 10    UNION SELECT 11 UNION SELECT 12
               order by daynum
            ) AA
                JOIN
            (
                SELECT DISTINCT(ARR.bond_id) as bond_id  FROM `exch_quotes_archive` as ARR
            ) BB
        order by trading_date desc
    ) AAA

LIMIT 500;


SELECT AAA.trading_date as date, AAA.bond_id, AVG(coalesce(AR.`bid`, 0)) over w as aBid, AVG(coalesce(AR.`ask`, 0)) over w as aAsk
FROM
    (
        SELECT
                MAKEDATE(YEAR(current_date()), DAYOFYEAR(current_date())) - INTERVAL daynum DAY as trading_date,bond_id
        FROM
            (
                SELECT 0 daynum
                UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
                UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
                UNION SELECT 7    UNION SELECT 8 UNION SELECT 9
                UNION SELECT 10    UNION SELECT 11 UNION SELECT 12
                order by daynum
            ) AA
                JOIN
            (
                SELECT DISTINCT(ARR.bond_id) as bond_id  FROM `exch_quotes_archive` as ARR
            ) BB
        order by trading_date desc
    ) AAA
    LEFT JOIN `exch_quotes_archive` as AR ON (AR.`trading_date` = AAA.trading_date AND AR.`bond_id` = AAA.bond_id)
    WHERE AR.`trading_date`  BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
    GROUP BY AAA.`bond_id`, AAA.`trading_date`
    WINDOW w AS (partition by AR.trading_date order by AR.bond_id)
    order by AAA.trading_date desc, AR.`bond_id` desc;
;


SELECT AAA.trading_date as date, AAA.bond_id, AVG(coalesce(AR.`bid`, 0)) over w as aBid, AVG(coalesce(AR.`ask`, 0)) over w as aAsk
FROM
    (
        SELECT
                MAKEDATE(YEAR(current_date()), DAYOFYEAR(current_date())) - INTERVAL daynum DAY as trading_date,bond_id
        FROM
            (
                SELECT 0 daynum
                UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
                UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
                UNION SELECT 7    UNION SELECT 8 UNION SELECT 9
                UNION SELECT 10    UNION SELECT 11 UNION SELECT 12
                order by daynum
            ) AA
                JOIN
            (
                SELECT DISTINCT(ARR.bond_id) as bond_id  FROM `exch_quotes_archive` as ARR
            ) BB
        order by trading_date desc
    ) AAA
        JOIN `exch_quotes_archive` as AR ON (AR.`trading_date` = AAA.trading_date AND AR.`bond_id` = AAA.bond_id)
WHERE AR.`trading_date`  BETWEEN '2022-07-08' AND '2022-07-11' AND AAA.`bond_id` = 5
GROUP BY AAA.`bond_id`, AAA.`trading_date`
    WINDOW w AS (partition by AR.trading_date order by AR.bond_id)
order by AAA.trading_date desc, AR.`bond_id` desc;

UNION ALL(
    SELECT
        `trading_date` as date,
        `bond_id` as bond_id,
        AVG(coalesce(`bid`, 0)) over w as aBid,
        AVG(coalesce(`ask`, 0)) over w as aAsk
    FROM `exch_quotes_archive`
    WHERE `trading_date`
              BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
    GROUP BY `bond_id`, `trading_date`
        WINDOW w AS (partition by trading_date order by bond_id)
    ORDER BY `trading_date` DESC
)
GROUP BY `trading_date`;



