#!/bin/bash
export PATH=$PATH:.
#UTC
dt="2016-09-01 00:00:00.00000"
# dt='date -u +"%Y-%m-%d %H:%M:%S.00000"'' # non-UTC
# dt='date +"%Y-%m-%d %H:%M:%S.00000"''
echo ""
echo "Building row types, tables, and other objects" dbaccess stu_13 - <<EOF2
drop table if exists sensors_avg_vti;
drop table if exists sensors_avg;
drop row type if exists sensors_row_t restrict;
delete from calendartable where c_name matches "ts_1sec";
execute procedure tscontainerdestroy("sens_cont1");
insert into calendartable(c_name, c_calendar)
values ("ts_1sec", 'startdate($dt), pattstart($dt), pattern( {1 on} second)' );
create row type sensors_row_t
(
tstamp datetime year to fraction(5), json_data bson
);
create table sensors_avg
(
id int not null primary key, data timeseries(sensors_row_t)
) with crcols;
execute procedure tscontainercreate('sens_cont1','stu13_data_2','sensors_row_t', 1024, 1024);
execute procedure tscreatevirtualtab('sensors_avg_vti', 'sensors_avg',
'calendar(ts_1sec), origin($dt), irregular' );
insert into sensors_avg values (1,tscreateirr('ts_1sec','$dt', 0,0,0,'sens_cont1'));
EOF2
echo ""
echo "Building traditional db structures" dbaccess stu_13 - <<EOF3
drop table if exists customer;
create table customer
( cust_no smallint not null primary key,
n_ame varchar(25), addr_1 varchar(20), c_ity varchar(20), s_tate char(2), z_ip char(5)
) in stu13_data_1;
insert into customer values (1, "Joe User", "1550 Aberdeen Dr.", "Flower Mound", "TX", "75222");
EOF3
echo ""
echo "Done building the db"

