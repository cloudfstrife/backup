
##########################################################################################################################
####                                                                                                        查询删除MySQL所有表的语句                                                                                                        ####
##########################################################################################################################

SELECT 
    CONCAT('drop table `',
            TABLE_SCHEMA,
            '`.`',
            TABLE_NAME,
            '`;')
FROM
    `information_schema`.`tables`
WHERE
    `table_schema` IN ('demo');

############################################################################################################################
####                                                                                                        查询删除MySQL所有外键的语句                                                                                                        ####
############################################################################################################################

SELECT 
    CONCAT('alter table `',
            TABLE_NAME,
            '` drop FOREIGN  KEY  ',
            CONSTRAINT_NAME,
            ';')
FROM
    `information_schema`.`key_column_usage`
WHERE
    `table_schema` = 'demo'
        AND `referenced_table_name` IS NOT NULL;

#############################################################################################################################
####                                                                                                                             查询表结构                                                                                                                             ####
#############################################################################################################################
SELECT 
    t.`table_name`,
    t.`table_comment`,
    c.`column_name`,
    c.`column_type`,
    c.`column_key`,
    c.`is_nullable`,
    c.`column_comment`
FROM
    `information_schema`.`tables` AS t
        INNER JOIN
    `information_schema`.`columns` AS c ON t.`table_name` = c.`table_name`
        AND t.`table_schema` = c.`table_schema`
WHERE
    t.`table_schema` = 'demo'
        AND t.`table_type` IN ('base table' , 'view')
        AND t.`table_schema` LIKE '%'
ORDER BY t.`table_schema` , t.`table_name` , c.`ordinal_position`;

------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    c.TABLE_SCHEMA,
    c.TABLE_NAME,
    t.TABLE_COMMENT,
    c.COLUMN_NAME,
    c.COLUMN_TYPE,
    c.IS_NULLABLE,
    c.COLUMN_DEFAULT,
    c.COLUMN_COMMENT
FROM
    information_schema.COLUMNS c left join information_schema.TABLES t on c.TABLE_NAME = t.TABLE_NAME 
WHERE
    c.TABLE_SCHEMA = 'demo';

#############################################################################################################################
####                                                                                                                         查询库的所有表                                                                                                                         ####
#############################################################################################################################
SELECT 
    TABLE_NAME,TABLE_COMMENT
FROM
    information_schema.TABLES
WHERE
    TABLE_SCHEMA = 'demo';

##############################################################################################################################
####                                                                                                                     生成Java实体类属性                                                                                                                     ####
##############################################################################################################################
SELECT
    CONCAT_WS(
        ' ',
        'private',
        CASE DATA_TYPE
    WHEN 'varchar' THEN
        'String'
    WHEN 'bigint' THEN
        'long'
    WHEN 'longtext' THEN
        'String'
    WHEN 'datetime' THEN
        'Date'
    WHEN 'int' THEN
        'int'
    WHEN 'decimal' THEN
        'BigDecimal'
    WHEN 'double' THEN
        'double'
    WHEN 'timestamp' THEN
        'Timestamp'
    WHEN 'longblob' THEN
        'byte[]'
    WHEN 'tinyint' THEN
        'int'
    WHEN 'text' THEN
        'String'
    WHEN 'char' THEN
        'char'
    WHEN 'date' THEN
        'Date'
    WHEN 'float' THEN
        'float'
    WHEN 'varbinary' THEN
        'byte[]'
    WHEN 'mediumtext' THEN
        'String'
    WHEN 'enum' THEN
        'String'
    WHEN 'blob' THEN
        'byte[]'
    WHEN 'set' THEN
        'String'
    WHEN 'time' THEN
        'Time'
    WHEN 'smallint' THEN
        'int'
    WHEN 'tinytext' THEN
        'String'
    WHEN 'binary' THEN
        'byte[]'
    WHEN 'bit' THEN
        'boolean'
    END,
    column_name,
    ';//',
    COLUMN_COMMENT
    )
FROM
    information_schema.`COLUMNS`
WHERE
    TABLE_SCHEMA = 'TABLE_SCHEMA'
AND TABLE_NAME = 'TABLE_NAME'; 

