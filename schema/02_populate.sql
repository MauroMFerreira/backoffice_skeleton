use mauro_db;

drop procedure if exists database_scan;

delimiter ;;
create procedure database_scan(db_name varchar(32))
begin
  declare xtmp varchar(255);
  declare tb_name varchar(32);
  declare done bool default false;
  declare tbls_cursor cursor for
    select tbl_name from mauro_db.tbls
    where  dbs_name=db_name order by tbl_name;
  declare continue handler for not found set done = true;
  set done = false;

  replace dbs set dbs_name=db_name;
  delete from tbls where dbs_name=db_name;
  delete from cols where dbs_name=db_name;
  delete from idx_cols where dbs_name=db_name;
  delete from idxs where dbs_name=db_name;

  insert into tbls (dbs_name,tbl_name)
    select  db_name, TABLE_NAME tbl_name
      from  information_schema.TABLES 
      where TABLE_SCHEMA=db_name
      order by TABLE_NAME;

  insert into cols (dbs_name,tbl_name,seq_in_tbl,col_name,col_type,col_length,col_dec,col_values,col_default,col_extra,col_nullable,col_form_title,col_table_title) 
    select  TABLE_SCHEMA     dbs_name,
            TABLE_NAME       tbl_name,
            ORDINAL_POSITION seq_in_tbl,
            COLUMN_NAME      col_name,
            DATA_TYPE        col_type,
            coalesce(CHARACTER_MAXIMUM_LENGTH,NUMERIC_PRECISION) col_length,
            NUMERIC_SCALE    col_dec,
            if(data_type in('enum','set'),substring_index(substring_index(COLUMN_TYPE,"(",-1),")",1),null) col_values,
            COLUMN_DEFAULT   col_default,
            EXTRA            col_extra,
            if(IS_NULLABLE='NO',false,true) col_nullable,
            COLUMN_NAME      col_form_title,
            COLUMN_NAME      col_table_title
      from  information_schema.COLUMNS 
      where TABLE_SCHEMA=db_name
      order by TABLE_NAME,ORDINAL_POSITION;

  drop table if exists tmp;
  create table tmp (
    tbl_name    varchar(32),
    non_unique  tinyint,
    idx_name    varchar(32),
    seq_in_idx  integer,
    col_name    varchar(32),
    asc_desc    varchar(1),
    xCardinality varchar(32),
    xSub_part varchar(32),
    xPacked varchar(32),
    xNull varchar(32),
    xIndex_type varchar(32),
    xComment varchar(32),
    xIndex_comment varchar(32),
    key  (idx_name,seq_in_idx)
  );
  select sys_eval('rm -f /tmp/lixo') into xtmp;
  select sys_eval('touch /tmp/lixo') into xtmp;

  open tbls_cursor;
  repeat
    fetch tbls_cursor into tb_name;
    if not done then

      select sys_eval(concat('mariadb -umauro -pmauro123 -ANrse"show index from ',db_name,'.',tb_name,'" > /tmp/lixo')) into xtmp;
      select sys_eval(concat('mariadb -umauro -pmauro123 -e"load data infile ''/tmp/lixo'' into table mauro_db.tmp"')) into xtmp;

    end if;
  until done end repeat;
  close tbls_cursor;
  set done = false;
  select sys_eval('rm -f /tmp/lixo') into xtmp;

  insert into idx_cols (dbs_name,tbl_name,idx_name,seq_in_idx,col_name,asc_desc)
    select db_name,tbl_name,idx_name,seq_in_idx,col_name,asc_desc 
      from tmp order by tbl_name,idx_name,seq_in_idx;

  insert into idxs (dbs_name,tbl_name,idx_name,idx_type)
    select db_name,tbl_name,idx_name,if(idx_name='PRIMARY','primary',if(non_unique,'key','unique')) idx_type
      from tmp group by tbl_name,idx_name;

  drop table if exists tmp;

end;;
delimiter ;

call database_scan('mauro_db');
