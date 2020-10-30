-- no, the tables and field's abbreviations stay: i don't like them too, but i
-- need to avoid both reserved words _and_ backticks nightmares.
-- i'll be forced to use backtitis in the databases inserted, but not in this.

-- obs: with the actual IDEs with colors, make no sense to differentiate
-- anything with uppercases and lowercases, so i use underlines: they are
-- harmless and enforce readability and cleanliness as no other way.

create user if not exists 'mauro'@'localhost' identified by 'mauro123';
grant all on mauro.* to 'mauro'@'localhost';

drop database if exists mauro_db;
create database mauro_db;

use mauro_db;

create table dbs (

  dbs_name varchar(32) not null,
  ins_at   timestamp not null default current_timestamp,
  upd_at   timestamp not null default current_timestamp on update current_timestamp,

  primary key (dbs_name)

) engine=myisam;

create table tbls (

  dbs_name varchar(32) not null,
  tbl_name varchar(32) not null,
  ins_at   timestamp not null default current_timestamp,
  upd_at   timestamp not null default current_timestamp on update current_timestamp,

  primary key (dbs_name,tbl_name)

) engine=myisam;

create table cols (

  dbs_name        varchar(32) not null,
  tbl_name        varchar(32) not null,
  seq_in_tbl      integer not null auto_increment,
  col_name        varchar(32) not null,
  col_type        enum(

    'integer','int','smallint','tinyint','mediumint','bigint',
    'decimal','numeric','float','double','bit',
    'date','datetime','timestamp','time','year',
    'char','varchar','binary','varbinary',
    'tinytext','text','mediumtext','longtext',
    'tinyblob','blob','mediumblob','longblob',
    'enum','set',
    'json'
  ) not null,

  col_length      integer,
  col_dec         integer,
  col_values      varchar(256),
  col_default     varchar(32),
  col_extra       varchar(32),
  col_nullable    boolean,
  col_form_title  varchar(32) not null default col_name,
  col_table_title varchar(32) not null default col_name,
  ins_at          timestamp not null default current_timestamp,
  upd_at          timestamp not null default current_timestamp on update current_timestamp,

  primary key (dbs_name,tbl_name,seq_in_tbl),
  unique key  (dbs_name,tbl_name,col_name),
  key         (dbs_name,col_name,tbl_name)

) engine=myisam;

create table idxs (

  dbs_name varchar(32) not null,
  tbl_name varchar(32) not null,
  idx_name varchar(32) not null,
  idx_type enum('primary','unique','key') not null default 'key',
  ins_at   timestamp not null default current_timestamp,
  upd_at   timestamp not null default current_timestamp on update current_timestamp,

  primary key (dbs_name,tbl_name,idx_name)

) engine=myisam;

create table idx_cols (

  dbs_name    varchar(32) not null,
  tbl_name    varchar(32) not null,
  idx_name    varchar(32) not null,
  seq_in_idx  integer not null auto_increment,
  col_name    varchar(32) not null,
  asc_desc    enum('A','D') not null default 'A',
  ins_at      timestamp not null default current_timestamp,
  upd_at      timestamp not null default current_timestamp on update current_timestamp,

  primary key (dbs_name,tbl_name,idx_name,seq_in_idx),
  key         (dbs_name,col_name,tbl_name)

) engine=myisam;

create table aliases (

  dbs_name    varchar(32) not null,
  tbl_name_1  varchar(32) not null,
  col_name_1  varchar(32) not null,
  tbl_name_2  varchar(32) not null,
  col_name_2  varchar(32) not null,
  ins_at      timestamp not null default current_timestamp,
  upd_at      timestamp not null default current_timestamp on update current_timestamp,

  primary key (dbs_name,tbl_name_1,col_name_1,tbl_name_2,col_name_2),
  unique  key (dbs_name,tbl_name_1,tbl_name_2),
  key         (dbs_name,tbl_name_2,col_name_2,tbl_name_1,col_name_1)

) engine=myisam;
