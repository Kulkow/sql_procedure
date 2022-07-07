SELECT `bond_id`,
       `trading_date`                                                            as date,
       AVG(coalesce(`bid`, 0)) over (partition by trading_date order by bond_id) as aBid,
       AVG(coalesce(`ask`, 0)) over (partition by trading_date order by bond_id) as aAsk
FROM `exch_quotes_archive`
WHERE `trading_date`
          BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
GROUP BY `bond_id`, `trading_date`
ORDER BY bond_id ASC;


SELECT *
FROM ((SELECT `bond_id`,
              `trading_date`                                                            as date,
              AVG(coalesce(`bid`, 0)) over (partition by trading_date order by bond_id) as aBid,
              AVG(coalesce(`ask`, 0)) over (partition by trading_date order by bond_id) as aAsk
       FROM `exch_quotes_archive`
       WHERE `trading_date`
                 BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
       GROUP BY `bond_id`, `trading_date`
       ORDER BY bond_id ASC)
      UNION
      (SELECT ADDDATE(CURRENT_DATE(), INTERVAL 1 day)  as date)
      )
ORDER BY date;

(SELECT `bond_id`,
       `trading_date`                                                            as date,
       AVG(coalesce(`bid`, 0)) over (partition by trading_date order by bond_id) as aBid,
       AVG(coalesce(`ask`, 0)) over (partition by trading_date order by bond_id) as aAsk
FROM `exch_quotes_archive`
WHERE `trading_date`
          BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE()
GROUP BY `bond_id`, `trading_date`
ORDER BY bond_id ASC)
UNION ALL (SELECT ADDDATE(CURRENT_DATE(), INTERVAL 1 day)  as date)
;


