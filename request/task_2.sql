SELECT AAA.trading_date as date, AAA.bond_id, AVG(coalesce(AR.`bid`, null)) over w as aBid, AVG(coalesce(AR.`ask`, null)) over w as aAsk
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
WHERE AAA.`bond_id` > 0
GROUP BY AAA.`bond_id`, AAA.`trading_date`
    WINDOW w AS (partition by AR.trading_date order by AR.bond_id)
order by AAA.trading_date desc, AR.`bond_id` desc