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
    DECLARE indexDay,randomExchangeId,randomBoundId,isNullRand,isNullRandVarieble,dayWeek INT;
    DECLARE bid, ask FLOAT;
    IF days = 0 OR days IS NULL THEN
        SET days = 65;
    END IF;

    SET isNullRandVarieble = 'bid';
    SET isNullRand = 0;
    IF RAND() > 0.5 THEN
        SET isNullRand = 1;
        IF RAND() > 0.5 THEN
            SET isNullRandVarieble = 'ask';
        END IF;
    END IF;

    SET indexDay = 1;
    WHILE indexDay <= days
        DO
            SET randomExchangeId = rand_array('[1,4,72,99,250,399,502,600]', 8);
            SET randomBoundId = rand_ceil(2, 200);
            SET bid = rand_float(-0.02, 2);
            SET ask = rand_float(-0.02, 2);

           IF isNullRand = 1 THEN
                IF isNullRandVarieble = 'bid' THEN
                    SET bid = null;
                ELSE
                    SET ask = null;
                END IF;
            END IF;

            SET start = DATE_SUB(start, INTERVAL 1 DAY);
            SET dayWeek = DAYOFWEEK(start);
            IF dayWeek!=1 AND dayWeek!=7 THEN
                INSERT INTO `exch_quotes_archive`(`exchange_id`, `bond_id`, `trading_date`, `bid`, `ask`)
                VALUES (randomExchangeId, randomBoundId, start, bid, ask);
            END IF;
            SET indexDay = indexDay + 1;
        END WHILE;
END;
$$
DELIMITER ;

## CALL paste_exch_quotes_archive(CURRENT_DATE(), 0);