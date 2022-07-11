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

SELECT trading_date as date, NULL as bond_id, NULL as aBid, NUll as aAsk
FROM
    (
        SELECT
                MAKEDATE(YEAR(current_date()), DAYOFYEAR(current_date())) - INTERVAL daynum DAY trading_date
        FROM
            (
                SELECT 0 daynum
                UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
                UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
                UNION SELECT 7    UNION SELECT 8 UNION SELECT 9
                UNION SELECT 10    UNION SELECT 11 UNION SELECT 12
            ) AA
    ) AAA
LEFT join




select *
from (
         (SELECT
              `trading_date`                                                            as date,
              `bond_id` as bond_id,
              AVG(coalesce(`bid`, 0)) over (partition by trading_date order by bond_id) as aBid,
              AVG(coalesce(`ask`, 0)) over (partition by trading_date order by bond_id) as aAsk
          FROM `exch_quotes_archive` WHERE `trading_date`  BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
         )
             union all
         (
             SELECT
                     MAKEDATE(YEAR(NOW()),1) +
                     INTERVAL (MONTH(NOW())-1) MONTH +
                     INTERVAL daynum DAY date_field,
             		 NULL,
             NULL,
             NULL

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
ORDER BY `trading_date` DESC;

