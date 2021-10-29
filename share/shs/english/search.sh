source base.sh

file_info=$(grep -nwi   "$1" $FRIENDS_DIR/*.srt  | shuf | head -n 1)

file_name=$(echo $file_info | awk -F ":" '{print $1}')

file_line=$(echo $file_info | awk -F ":" '{print $2}')
begin_line=$((file_line-2))

bash times.sh "`sed -n "$begin_line,${file_line}p"  $file_name | grep -E -o "([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3})"`"
echo $file_name | sed 's/srt/mkv/g'
