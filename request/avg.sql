SELECT `bond_id`,
       `trading_date`                                                            as date,
       AVG(coalesce(`bid`, 0)) over (partition by trading_date order by bond_id) as aBid,
       AVG(coalesce(`ask`, 0)) over (partition by trading_date order by bond_id) as aAsk
FROM `exch_quotes_archive`
WHERE `trading_date`
          BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
GROUP BY `bond_id`, `trading_date`
ORDER BY bond_id ASC
    WINDOW w AS (ORDER BY t)
;

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


SELECT date,d.trading_date,d.aBid,d.aAsk
FROM
    (
        SELECT
                MAKEDATE(YEAR(NOW()),1) +
                INTERVAL (MONTH(NOW())-1) MONTH +
                INTERVAL daynum DAY date
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
left join (
        SELECT `bond_id`,
               `trading_date`                                                            as trading_date,
               AVG(coalesce(`bid`, 0)) over (partition by trading_date order by bond_id) as aBid,
               AVG(coalesce(`ask`, 0)) over (partition by trading_date order by bond_id) as aAsk
        FROM `exch_quotes_archive`
    ) as d USING (trading_date)
WHERE MONTH(date) = MONTH(NOW())
    AND d.`trading_date`   BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
GROUP BY d.`bond_id`, d.`trading_date`
ORDER BY d.bond_id ASC
LIMIT 31;

