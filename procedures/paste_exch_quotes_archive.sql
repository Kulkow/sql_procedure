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
CREATE PROCEDURE paste_exch_quotes_archive(IN start datetime)
BEGIN
    DECLARE countParse, indexPaste,randomExchangeId,randomBoundId INT;
    DECLARE bid, ask FLOAT;
    IF start = ''
        THEN SET start = CURDATE();
    END IF;

    SET countParse = 100;
    SET indexPaste = 1;
    WHILE indexPaste <= countParse
        DO
            SET randomExchangeId = rand_array('[1,4,72,99,250,399,502,600]', 8);
            SET randomBoundId = rand_ceil(2, 200);
            SET bid = rand_float(-0.02, 200);
            SET ask = rand_float(-0.02, 200);
            SET start = DATE_SUB(start, INTERVAL 1 DAY);
            INSERT INTO `exch_quotes_archive`(`exchange_id`, `bond_id`, `trading_date`, `bid`, `ask`)
            VALUES (randomExchangeId, randomBoundId, start, bid, ask);
            SET indexPaste = indexPaste + 1;
        END WHILE;
END;
$$
DELIMITER ;

## CALL paste_exch_quotes_archive('2022-07-06');