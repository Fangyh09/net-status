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

all_sub_pids=()
for item in $info;
do
    sub_pids=`ps -ef | grep $item | grep -v "grep" | awk '$2!="$item" {print $2}'`
    for sub_pid in $sub_pids;
    do
        all_sub_pids+=(${sub_pid})
    done
done

d1="d1.txt"
d2="d2.txt"
> "$d1"
> "$d2"
printf '%s\n' ${all_sub_pids[@]} > "$d1"
cat "tmp.txt" | awk '{print $2}' > "$d2"
# merge pids and sub-pids
merge_pids=`sort $d2 $d1 $d1 | uniq -u`
echo ${merge_pids}
#ps -ef | grep 25863 | grep -v "grep" | awk '$2!="25863" {print $2}''}