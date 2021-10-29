pro=$(sdcv $1 | grep -o "BrE *\[[^.]*\]" |sed 's#BrE##g' | head -n 1)

echo $1 $pro " "
