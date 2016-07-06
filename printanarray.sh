#!/bin/bash
array=("kanaka" "daroji" "bhavya" "dimpy")
len=${#array[@]}
echo "Printing array"
for element in ${array[@]}
do 
	echo $element
done

echo "Printing array in reverse order"
for (( i=$len-1; i>=0; i-- ))
do
	echo ${array[i]}
done

echo "No of elements : " ${#array[@]}
