#!/bin/sh

PATH=$1

echo $PATH

for FILE in `ls $PATH`
do
	echo $FILE
done