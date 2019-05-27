
###########################################################################################################################
####                                             查询删除MySQL所有表的语句                                             ####
###########################################################################################################################

SELECT 
    CONCAT('drop table `',
            TABLE_SCHEMA,
            '`.`',
            TABLE_NAME,
            '`;')
FROM
    `information_schema`.`tables`
WHERE
    `table_schema` IN ('database_name');

#############################################################################################################################
####                                             查询删除MySQL所有外键的语句                                             ####
#############################################################################################################################

SELECT 
    CONCAT('alter table `',
            TABLE_NAME,
            '` drop FOREIGN  KEY  ',
            CONSTRAINT_NAME,
            ';')
FROM
    `information_schema`.`key_column_usage`
WHERE
    `table_schema` = 'database_name'
        AND `referenced_table_name` IS NOT NULL;

##############################################################################################################################
####                                                      查询表结构                                                      ####
##############################################################################################################################
SELECT 
    c.COLUMN_NAME,
    c.COLUMN_TYPE,
    c.IS_NULLABLE,
    c.COLUMN_DEFAULT,
    c.COLUMN_COMMENT,
    c.ORDINAL_POSITION,
    c.TABLE_SCHEMA,
    c.TABLE_NAME,
    t.TABLE_COMMENT
FROM
    information_schema.COLUMNS c
        LEFT JOIN
    information_schema.TABLES t ON c.TABLE_NAME = t.TABLE_NAME
WHERE
    c.TABLE_SCHEMA = 'database_name'
        AND c.TABLE_NAME = 'table_name'
ORDER BY c.ORDINAL_POSITION;

##############################################################################################################################
####                                                    查询库的所有表                                                    ####
##############################################################################################################################
SELECT 
    TABLE_NAME,TABLE_COMMENT
FROM
    information_schema.TABLES
WHERE
    TABLE_SCHEMA = 'database_name';

##############################################################################################################################
####                                                  生成Java实体类属性                                                  ####
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
    ) as j 
FROM
    information_schema.`COLUMNS`
WHERE
    TABLE_SCHEMA = 'database_name'
AND TABLE_NAME = 'table_name'; 

##############################################################################################################################
####                                                      查询库大小                                                      ####
##############################################################################################################################
SELECT 
    (SUM(DATA_LENGTH) + SUM(INDEX_LENGTH)) / 1024 / 1024
FROM
    information_schema.tables
WHERE
    table_schema = 'database_name';
