source base.sh
search_res=$(bash search.sh "$1" 2>/dev/null)

start_time=$(echo $search_res |awk '{print $1}' )
end_time=$(echo $search_res |awk '{print $2}' )
file_name=$(echo $search_res |awk '{print $3}' )


vlc --start-time=$start_time --stop-time=$end_time --input-repeat=2 --play-and-exit  $file_name 2&>/dev/null
