msg.payload = { id : 1,
tstamp : {$date : ( new Date() ).getTime()},
json_data : {ambient_avg : msg.payload} }
return msg;