select a.n_ame customer_name, a.c_ity city, a.s_tate state, to_char(b.tstamp, '%a, %D %H:%M:%S') time_stamp,
json_data.ambient_avg::json avg_temp
from customer a, sensors_avg_vti b
where a.cust_no = b.id