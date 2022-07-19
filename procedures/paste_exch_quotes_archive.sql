SET GLOBAL log_bin_trust_function_creators = 1;
TRUNCATE TABLE `exch_quotes_archive`;

DELIMITER $$

DROP FUNCTION IF EXISTS rand_ceil$$
CREATE FUNCTION rand_ceil(start INTEGER, end INTEGER) RETURNS INTEGER
    NOT DETERMINISTIC
BEGIN
    DECLARE result INTEGER;
    SET result = FLOOR(start + RAND() * end);
    RETURN (result);
END;
$$

DROP FUNCTION IF EXISTS rand_array$$
CREATE FUNCTION rand_array(array VARCHAR(255), count INTEGER) RETURNS INTEGER
    NOT DETERMINISTIC
BEGIN
    RETURN CEIL(JSON_EXTRACT(array, CONCAT('$[', FLOOR(RAND() * count), ']')));
END;
$$



DROP FUNCTION IF EXISTS rand_float$$
CREATE FUNCTION rand_float(start FLOAT, end FLOAT) RETURNS FLOAT
    NOT DETERMINISTIC
BEGIN
    RETURN start + RAND() * end;
END;
$$

DROP PROCEDURE IF EXISTS paste_exch_quotes_archive$$
CREATE PROCEDURE paste_exch_quotes_archive(IN start DATE, IN days INTEGER)
BEGIN
    DECLARE indexDay,exchangeId,exchangeStartId, exchangeEndId, isNullRand,dayWeek,boundId,boundIdStart,boundIdEnd INT;
    DECLARE bid, ask FLOAT;
    DECLARE exchangeIds,isNullRandVariable VARCHAR(255);
    DECLARE ins TEXT;
    IF days = 0 OR days IS NULL THEN
        SET days = 65;
    END IF;

    SET ins = NULL;
    SET exchangeIds = '[1,4,72,99,250,399,502,600]';
    SET indexDay = 1;
    
    Start transaction;
    
    WHILE indexDay <= days DO
            SET dayWeek = DAYOFWEEK(start);
            IF dayWeek!=1 AND dayWeek!=7 THEN
            	select dayWeek; 
                SET exchangeStartId = 0;
                SET exchangeEndId = JSON_LENGTH(exchangeIds);
                WHILE exchangeStartId < exchangeEndId    DO
                        SET exchangeId = JSON_EXTRACT(exchangeIds, CONCAT('$[', exchangeStartId, ']'));
                        SET boundIdStart = 1;
                        SET boundIdEnd = 200;
                    WHILE boundIdStart <= boundIdEnd DO
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
                            
                            INSERT INTO `exch_quotes_archive`(`exchange_id`, `bond_id`, `trading_date`, `bid`, `ask`) VALUES (exchangeId,boundId,start,bid,ask);

                            #IF @ins = NULL THEN
                    	    	#SET @ins = CONCAT('INSERT INTO `exch_quotes_archive`(`exchange_id`, `bond_id`, `trading_date`, `bid`, `ask`) VALUES (',exchangeId,',', boundId,',',CAST(start as CHAR),',',ifnull(bid, 'NULL'),',',ifnull(ask, 'NULL'),')');                            	
                    	    #ELSE
                    	    	#SET @ins = CONCAT(CAST(@ins as char), ',(',exchangeId,',', boundId,',',CAST(start as CHAR),',',ifnull(bid, 'NULL'),',',ifnull(ask, 'NULL'),')');            	
                            #END IF;
                            #select LENGTH(@ins);
                            SET boundIdStart = boundIdStart + 1;
                    END WHILE;
                    SET exchangeStartId = exchangeStartId + 1;
                END WHILE;
            END IF;
            SET indexDay = indexDay + 1;
            SET start = DATE_SUB(start, INTERVAL 1 DAY);
    END WHILE;
    commit;
#    PREPARE stmt_ins FROM @ins;
#    EXECUTE stmt_ins;
END;
$$
DELIMITER ;

## CALL paste_exch_quotes_archive(CURRENT_DATE(), 0);
