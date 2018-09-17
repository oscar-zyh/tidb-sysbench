#!/bin/bash

# load configurations
. ./conf.sh

# set global parameters
if [ $# -ne 2 ]; then
  echo "usage: $0 <benchtype> <threads>"
  echo "benchtype:(0:readonly,1:writeonly,2:readwrite,3:pointselect)"
  exit -1
fi
btype=$1
threads=$2
logfile=$(readlink -f ./bench-B${btype}-T${threads}-$(date '+%Y%m%d-%H%M%S').log)
lua_dir=../src/lua

# redirect output to the log file
exec > $logfile
exec 2>&1

# bench
cd ${lua_dir}

echo "======================== Start Sysbench ========================"
echo "bench log append to: ${logfile}"

if [ ${btype} -eq 0 ]; then
  echo "-------------------- bench read-only --------------------"
  echo "-------------------- threads: ${threads} --------------------"
  ../sysbench oltp_read_only.lua \
    --db-driver=mysql \
    --mysql-host=${host} \
    --mysql-port=${port} \
    --mysql-db=${dbname} \
    --mysql-user=${user} \
    --mysql-password=${password} \
    --table_size=${tsize} \
    --tables=${tcount} \
    --threads=${threads} \
    --events=${maxevents} \
    --report-interval=${interval} \
    --time=${maxtime} \
    run
elif [ ${btype} -eq 1 ]; then
  echo "-------------------- bench write-only --------------------"
  echo "-------------------- threads: ${threads} --------------------"
  ../sysbench oltp_write_only.lua \
    --db-driver=mysql \
    --mysql-host=${host} \
    --mysql-port=${port} \
    --mysql-db=${dbname} \
    --mysql-user=${user} \
    --mysql-password=${password} \
    --table_size=${tsize} \
    --tables=${tcount} \
    --threads=${threads} \
    --events=${maxevents} \
    --report-interval=${interval} \
    --time=${maxtime} \
    run
elif [ ${btype} -eq 2 ]; then
  echo "-------------------- bench read-write --------------------"
  echo "-------------------- threads: ${threads} --------------------"
  ../sysbench oltp_read_write.lua \
    --db-driver=mysql \
    --mysql-host=${host} \
    --mysql-port=${port} \
    --mysql-db=${dbname} \
    --mysql-user=${user} \
    --mysql-password=${password} \
    --table_size=${tsize} \
    --tables=${tcount} \
    --threads=${threads} \
    --events=${maxevents} \
    --report-interval=${interval} \
    --time=${maxtime} \
    run
elif [ ${btype} -eq 3 ]; then
  echo "-------------------- bench point-select --------------------"
  echo "-------------------- threads: ${threads} --------------------"
  ../sysbench oltp_point_select.lua \
    --db-driver=mysql \
    --mysql-host=${host} \
    --mysql-port=${port} \
    --mysql-db=${dbname} \
    --mysql-user=${user} \
    --mysql-password=${password} \
    --table_size=${tsize} \
    --tables=${tcount} \
    --threads=${threads} \
    --events=${maxevents} \
    --report-interval=${interval} \
    --time=${maxtime} \
    run
fi


