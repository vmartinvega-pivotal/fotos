#!/bin/sh

PHOTOS_PATH=$1

for FILE in `ls $PHOTOS_PATH`
do
	echo $FILE
done