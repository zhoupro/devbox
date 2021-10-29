source base.sh

start_time=$(echo $1 | awk  '{print $1}')
end_time=$(echo $1 | awk    '{print $2}')

start_hour=$(echo $start_time | awk  -F ":" '{print $1}')
start_min=$(echo $start_time | awk  -F ":" '{print $2}')


end_hour=$(echo $end_time | awk  -F ":" '{print $1}')
end_min=$(echo $end_time | awk  -F ":" '{print $2}')


start_sec_m_str=$(echo $start_time | awk  -F ":" '{print $3}')
start_sec=$(echo $start_sec_m_str | awk  -F "," '{print $1}')
start_m=$(echo $start_sec_m_str | awk  -F "," '{print $2}')

end_sec_m_str=$(echo $end_time | awk  -F ":" '{print $3}')
end_sec=$(echo $end_sec_m_str | awk  -F "," '{print $1}')
end_m=$(echo $end_sec_m_str | awk  -F "," '{print $2}')


python -c  "print((int(\"$start_hour\")*3600)+(int(\"$start_min\")*60)+int(\"$start_sec\")+(int(\"$start_m\")/1000.0))"
python -c "print(((int(\"$end_hour\")*3600)+(int(\"$end_min\")*60)+int(\"$end_sec\")+(int(\"$end_m\")/1000.0)))"
