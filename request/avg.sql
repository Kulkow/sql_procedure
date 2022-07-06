SELECT `trading_date`, AVG(`bid`, `ask`)
FROM `exch_quotes_archive`
WHERE `trading_date` BETWEEN SUBDATE(CURRENT_DATE(), INTERVAL 14 day) AND CURRENT_DATE();