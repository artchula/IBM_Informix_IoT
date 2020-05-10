#!/bin/bash
dbaccess sysmaster - <<EOF1
select name dbname, created dt_cr8ed from sysdatabases; EOF1