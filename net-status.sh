#/bin/bash
#author fangyh

declare -a arr=("www.baidu.com" "www.github.com" 
"www.126.com")

echo "Testing..."
for i in "${arr[@]}"
do
    time=`ping -c 2 "$i" | tail -1| awk '{print $4}' | cut -d '/' -f 3`
    echo "$i it's time = $time ms"
done

echo "Finish..."

