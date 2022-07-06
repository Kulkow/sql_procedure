DROP TABLE IF EXISTS `exch_quotes_archive`;
CREATE TABLE `exch_quotes_archive`
(
    `id`                int(11) NOT NULL AUTO_INCREMENT,
    `exchange_id`       int(11) NOT NULL,
    `bond_id`           int(11) NOT NULL,
    `trading_date`      DATE,
    `bid`           DECIMAL(17, 2) NULL,
    `ask`           DECIMAL(17, 2) NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `IDX_QUETE` (`exchange_id`, `bond_id`, `trading_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
