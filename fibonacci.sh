#!/bin/bash

first=0
second=1

echo "$first"
echo "$second"

for (( i=1; i<=10; i++ ))
do
	next=$(($first+$second))
	first=$second
	second=$next
	echo "$next"
done	

