#!/bin/bash
COUNTER=0
while [ $COUNTER -lt 5 ]; do
dbaccess iot chk_inserts.sql sleep 2
let COUNTER=COUNTER+1
done