#!/bin/bash
export PATH=$PATH:.
#UTC
dt="2016-09-01 00:00:00.00000"
# dt=`date -u +"%Y-%m-%d %H:%M:%S.00000"` # non-UTC
# dt=`date +"%Y-%m-%d %H:%M:%S.00000"`
echo ""
echo "Building DB"
dbaccess sysmaster - <<EOF1
drop database if exists iot;
create database iot in datadbs1 with buffered log ; EOF1
echo ""
echo "Building row types, tables, and other objects" dbaccess iot - <<EOF2
drop table if exists sensors;
drop table if exists sensors_vti;
drop row type if exists sensors_row_t restrict; drop table if exists sensors_avg;
insert into calendartable(c_name, c_calendar)
values ("ts_1sec", 'startdate($dt), pattstart($dt), pattern( {1 on} second)' );
create row type sensors_row_t
(
tstamp datetime year to fraction(5),
   json_data  bson
);
create table sensors
(
id varchar(255) not null primary key, data timeseries(sensors_row_t)
);
create table sensors_avg (
id int not null primary key, data timeseries(sensors_row_t)
) with crcols;
execute procedure tscontainercreate('sens_cont1','datadbs1','sensors_row_t', 1024, 1024);
execute procedure tscreatevirtualtab('sensors_vti',
'sensors', 'calendar(ts_1sec), origin($dt), irregular');
execute procedure tscreatevirtualtab('sensors_avg_vti', 'sensors_avg',
'calendar(ts_1sec), origin($dt), irregular' );
{
insert into sensors values ('1',tscreateirr('ts_1sec','$dt', 0,0,0,'sens_cont1')); insert into sensors_avg values (1,tscreateirr('ts_1sec','$dt', 0,0,0,'sens_cont1')); }
EOF2