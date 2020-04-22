#!/bin/bash

PATH=$1

for FILE in `ls $PATH` 
do
	echo $FILE
done