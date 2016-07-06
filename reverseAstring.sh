#!/bin/bash

echo "****** Programe to reverse a string  *******"

read -p "Enter text here : " text

echo "Entered text : " $text

len=${#text[@]}
for ((i=$len-1; i>=0; i--))
do
 echo $len
 echo "Kanaka"
done
