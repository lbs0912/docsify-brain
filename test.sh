#!/bin/bash
# get all filename in specified path

path=$2
files=$(ls $path)
for filename in $files
do
   echo $filename
   # echo $filename >> filename.txt
done