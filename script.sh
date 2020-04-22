#!/bin/sh

PHOTOS_PATH=$1

# Loop for years
for YEAR in `ls $PHOTOS_PATH`
do
	# Loop for months
	for MONTH in `ls $PHOTOS_PATH/$YEAR`
	do
		# Loop for folders
		for FOLDER in `ls $PHOTOS_PATH/$YEAR/$MONTH`
		do
			for FILE in `ls $PHOTOS_PATH/$YEAR/$MONTH/$FOLDER`
			do
				echo "File to analyze: $FILE"
			done
		done
	done
done