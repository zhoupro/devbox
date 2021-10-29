#!/bin/bash
source base.sh
total_num=$(sqlite3 $ENG_DIR/dict/stardict.db "select count(*) from stardict where oxford=1 and collins=5")
plan_day=$1
per_day_num=$((($total_num+$plan_day-1)/plan_day))


cur_day=$(date +%j |tr "0" "1")
cur_cycle_day=$(($cur_day%$plan_day))
offset=$((($cur_cycle_day-1)*$per_day_num))

sqlite3 $ENG_DIR/dict/stardict.db "select word from stardict where oxford=1 and collins=5 limit $offset, $per_day_num"
