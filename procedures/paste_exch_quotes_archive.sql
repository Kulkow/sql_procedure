TRUNCATE TABLE `exch_quotes_archive`;

DELIMITER $$

DROP FUNCTION IF EXISTS rand_ceil$$
CREATE FUNCTION rand_ceil(start INTEGER, end INTEGER) RETURNS INTEGER
    DETERMINISTIC
BEGIN
    DECLARE result INTEGER;
    SET result = FLOOR(start + RAND() * end);
    RETURN (result);
END;
$$

DROP FUNCTION IF EXISTS rand_array$$
CREATE FUNCTION rand_array(array VARCHAR(255), count INTEGER) RETURNS INTEGER
    DETERMINISTIC
BEGIN
    RETURN CEIL(JSON_EXTRACT(array, CONCAT('$[', FLOOR(RAND() * count), ']')));
END;
$$



DROP FUNCTION IF EXISTS rand_float$$
CREATE FUNCTION rand_float(start FLOAT, end FLOAT) RETURNS FLOAT
    DETERMINISTIC
BEGIN
    RETURN start + RAND() * end;
END;
$$

DROP PROCEDURE IF EXISTS paste_exch_quotes_archive$$
CREATE PROCEDURE paste_exch_quotes_archive(IN start DATE, IN days INTEGER)
BEGIN
    DECLARE indexDay,exchangeId,boundId,isNullRand,isNullRandVariable,dayWeek,boundIdStart,boundIdEnd,indExchangeId,countExchangeIds INT;
    DECLARE bid, ask FLOAT;
    DECLARE exchangeIds VARCHAR(255);
    IF days = 0 OR days IS NULL THEN
        SET days = 65;
    END IF;


    SET exchangeIds = '[1,4,72,99,250,399,502,600]';

    SET indexDay = 1;
    SET countExchangeIds =  JSON_LENGTH(exchangeIds);
    WHILE indexDay <= days
        DO
            SET start = DATE_SUB(start, INTERVAL 1 DAY);
            SET dayWeek = DAYOFWEEK(start);
            IF dayWeek!=1 AND dayWeek!=7 THEN
                SET indExchangeId = 0;
                SET boundIdStart = 1;
                SET boundIdEnd = 200;
                REPEAT
                    SET exchangeId = JSON_EXTRACT(exchangeIds, CONCAT('$[', indExchangeId, ']'));

                    select CONCAT('exchangeId -', exchangeId,' - ',indExchangeId);

                    WHILE boundIdStart <= boundIdEnd
                        DO
                            SET isNullRandVariable = 'bid';
                            SET isNullRand = 0;
                            IF RAND() > 0.5 THEN
                                SET isNullRand = 1;
                                IF RAND() > 0.5 THEN
                                    SET isNullRandVariable = 'ask';
                                END IF;
                            END IF;
                            SET bid = rand_float(-0.02, 2);
                            SET ask = rand_float(-0.02, 2);
                            IF isNullRand = 1 THEN
                                IF isNullRandVariable = 'bid' THEN
                                    SET bid = null;
                                ELSE
                                    SET ask = null;
                                END IF;
                            END IF;
                            SET boundId = boundIdStart;
                            select CONCAT(exchangeId,',', boundId, ',',start);
                            INSERT INTO `exch_quotes_archive`(`exchange_id`, `bond_id`, `trading_date`, `bid`, `ask`)
                            VALUES (exchangeId, boundId, start, bid, ask);
                            SET boundIdStart = boundIdStart + 1;
                    END WHILE;

                SET indExchangeId = indExchangeId + 1;

                UNTIL indExchangeId = countExchangeIds  END REPEAT;
            END IF;
            SET indexDay = indexDay + 1;
    END WHILE;
END;
$$
DELIMITER ;

## CALL paste_exch_quotes_archive(CURRENT_DATE(), 0);