#!/bin/bash

gpu_id=-1
if [ $1 == "-gpu" ];then
	gpu_id=$2
fi

num_gpus=`lspci | grep VGA | grep 'NVIDIA' | wc -l`
lines_date=7
pre_lines=$(( $lines_date + $num_gpus * 3 + 6))
str=${pre_lines},"$"p
info=`nvidia-smi|sed -n $str | sed '$d' | awk -v var="${gpu_id}" '$2==var {print $3}'`

save_pids=()
for item in $info;
do
	subpids=`ps -ef | grep $item | grep -v "grep" | awk '$2!="$item" {print $2}'`
	for sub_pid in $subpids;
	do
		save_pids+=(${sub_pid})
	done
done


d1="d1.txt"
d2="d2.txt"
> "$d1"
> "$d2"
printf '%s\n' ${save_pids[@]} > "$d1"
cat "tmp.txt" | awk '{print $2}' > "$d2"
info=`sort $d2 $d1 $d1 | uniq -u`
echo $info
#ps -ef | grep 25863 | grep -v "grep" | awk '$2!="25863" {print $2}''}