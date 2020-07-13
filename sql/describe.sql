SELECT
column_name "Name",
nullable "Null?",
concat(concat(concat(data_type,'('),data_length),')') "Type"
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = 'TABLE_NAME'
order by "Name"