#!/bin/bash

OIFS="$IFS"
IFS=$'\n'

PHOTOS_PATH=$1

# Loop for years
for YEAR in `ls "$PHOTOS_PATH"`
do
        echo "Analyzing year: $YEAR"
		echo "Creating folder: $YEAR-photos"
		mkdir "$PHOTOS_PATH/$YEAR-photos"
		
		echo "Creating folder: $YEAR-movies"
		mkdir "$PHOTOS_PATH/$YEAR-movies"
		
		INDEX_FOTO=0
		INDEX_VIDEO=0
        # Loop for months
        for MONTH in `ls "$PHOTOS_PATH/$YEAR"`
        do
				MONTH_HUMAN=""
                echo "Analyzing month: $MONTH"
				if [[ $MONTH = "01" ]]
				then
					MONTH_HUMAN="ENERO"
				elif [[ $MONTH = "02" ]]
				then
					MONTH_HUMAN="FEBRERO"
				elif [[ $MONTH = "03" ]]
				then
					MONTH_HUMAN="MARZO"
				elif [[ $MONTH = "04" ]]
				then
					MONTH_HUMAN="ABRIL"
				elif [[ $MONTH = "05" ]]
				then
					MONTH_HUMAN="MAYO"
				elif [[ $MONTH = "06" ]]
				then
					MONTH_HUMAN="JUNIO"
				elif [[ $MONTH = "07" ]]
				then
					MONTH_HUMAN="JULIO"
				elif [[ $MONTH = "08" ]]
				then
					MONTH_HUMAN="AGOSTO"
				elif [[ $MONTH = "09" ]]
				then
					MONTH_HUMAN="SEPTIEMBRE"
				elif [[ $MONTH = "10" ]]
				then
					MONTH_HUMAN="OCTUBRE"
				elif [[ $MONTH = "11" ]]
				then
					MONTH_HUMAN="NOVIEMBRE"
				elif [[ $MONTH = "12" ]]
				then
					MONTH_HUMAN="DICIEMBRE"
				fi
				
				echo "Creating folder: $YEAR-photos/$MONTH-$MONTH_HUMAN"
				mkdir "$PHOTOS_PATH/$YEAR-photos/$MONTH-$MONTH_HUMAN"
				
				echo "Creating folder: $YEAR-movies/$MONTH-$MONTH_HUMAN"
				mkdir "$PHOTOS_PATH/$YEAR-movies/$MONTH-$MONTH_HUMAN"
				
                # Loop for folders
                for FOLDER in `ls "$PHOTOS_PATH/$YEAR/$MONTH"`
                do
						TEMP_FOLDER="tmp"
						
                        echo "Analyzing folder: $FOLDER"
						
						extensions=( "jpg" "arw" "dng")
						
						for EXTENSION in "${extensions[@]}"
						do
							touch /$TEMP_FOLDER/list-files-fotos.$EXTENSION
							
							if [[ $EXTENSION = "jpg" ]]
							then
								ls "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER" | grep -E '.jpg|.JPG' >> /$TEMP_FOLDER/list-files-fotos.$EXTENSION # Grep jpg or JPG
							elif [[ $EXTENSION = "arw" ]]
							then
								ls "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER" | grep -E '.arw|.ARW' >> /$TEMP_FOLDER/list-files-fotos.$EXTENSION # Grep arw or ARW
							elif [[ $EXTENSION = "dng" ]]
							then
								ls "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER" | grep -E '.dng|.DNG' >> /$TEMP_FOLDER/list-files-fotos.$EXTENSION # Grep arw or ARW
							fi
							
							NUMBER_OF_FILES=$(cat /$TEMP_FOLDER/list-files-fotos.$EXTENSION | wc -l)
							if [[ $NUMBER_OF_FILES = "0" ]]
							then
								echo "No photo files for extension $EXTENSION"
							else
								mkdir $PHOTOS_PATH/$YEAR-photos/$MONTH-$MONTH_HUMAN/$FOLDER
								
								for FILE_JPG in `cat /$TEMP_FOLDER/list-files-fotos.$EXTENSION` 
								do
										echo "Analyzing file: $FILE_JPG"
										INDEX_FOTO=$((INDEX_FOTO + 1))
										INDEX_FOTO_LENGTH=${#INDEX_FOTO}
										INDEX_FOTO_STRING=$INDEX_FOTO
										if [[ $INDEX_FOTO_LENGTH = "1" ]]
										then
											INDEX_FOTO_STRING="0$INDEX_FOTO"
										fi
										cp "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER/$FILE_JPG" "$PHOTOS_PATH/$YEAR-photos/$MONTH-$MONTH_HUMAN/$FOLDER/$YEAR-$MONTH-$MONTH_HUMAN-FOTO-$INDEX_FOTO_STRING-$FOLDER.$EXTENSION"
								done
							fi
							
							rm /$TEMP_FOLDER/list-files-fotos.$EXTENSION
						done
						
						extensions=( "mp4" "mov" "m2ts")
						
						for EXTENSION in "${extensions[@]}"
						do
							VIDEO_AUX="9"
							mkdir /$TEMP_FOLDER/$EXTENSION
							touch /$TEMP_FOLDER/list.$EXTENSION
							
							if [[ $EXTENSION = "mp4" ]]
							then
								ls "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER" | grep -E '.mp4|.MP4' > /$TEMP_FOLDER/list-files.$EXTENSION
							elif [[ $EXTENSION = "mov" ]]
							then
								ls "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER" | grep -E '.mov|.MOV' > /$TEMP_FOLDER/list-files.$EXTENSION
							elif [[ $EXTENSION = "m2ts" ]]
							then
								ls "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER" | grep -E '.m2ts|.M2TS' > /$TEMP_FOLDER/list-files.$EXTENSION
							fi
							
							NUMBER_OF_FILES=$(cat /$TEMP_FOLDER/list-files.$EXTENSION | wc -l)
							if [[ $NUMBER_OF_FILES = "0" ]]
							then
								echo "No movie files for extension $EXTENSION"
							else
								mkdir $PHOTOS_PATH/$YEAR-movies/$MONTH-$MONTH_HUMAN/$FOLDER
								
								# Creates video index
								INDEX_VIDEO=$((INDEX_VIDEO + 1))
								INDEX_VIDEO_LENGTH=${#INDEX_VIDEO}
								INDEX_VIDEO_STRING=$INDEX_VIDEO
								if [[ $INDEX_VIDEO_LENGTH = "1" ]]
								then
									INDEX_VIDEO_STRING="0$INDEX_VIDEO"
								fi
						
								for FILE in `cat /$TEMP_FOLDER/list-files.$EXTENSION` # Grep mp4 or MP4
								do
									VIDEO_AUX=$((VIDEO_AUX + 1))
									echo "Copying file: $FILE to /$TEMP_FOLDER/$EXTENSION/$VIDEO_AUX.$EXTENSION"
									ln -s "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER/$FILE" "/$TEMP_FOLDER/$EXTENSION/$VIDEO_AUX.$EXTENSION"
									echo "file '/$TEMP_FOLDER/$EXTENSION/$VIDEO_AUX.$EXTENSION'" >> /$TEMP_FOLDER/list.$EXTENSION
									echo "rm /$TEMP_FOLDER/$EXTENSION/$VIDEO_AUX.$EXTENSION" >> /$TEMP_FOLDER/ln.$EXTENSION
								done
								
								echo "Concating files..."
								cat /$TEMP_FOLDER/list.$EXTENSION
								echo "... to file /$TEMP_FOLDER/output-$VIDEO_AUX.$EXTENSION"
								ffmpeg -f concat -safe 0 -i /$TEMP_FOLDER/list.$EXTENSION -c copy /$TEMP_FOLDER/output.$EXTENSION
								
								ffmpeg -y -i /$TEMP_FOLDER/output.$EXTENSION -f mjpeg -ss 10 -vframes 1 /$TEMP_FOLDER/output.jpg
								
								# TODO: Create nfo file
								touch /$TEMP_FOLDER/output.nfo
								
								echo "Moving concatenated file ..."
								mv /$TEMP_FOLDER/output.$EXTENSION "$PHOTOS_PATH/$YEAR-movies/$MONTH-$MONTH_HUMAN/$FOLDER/$YEAR-$MONTH-$MONTH_HUMAN-VIDEO-$INDEX_VIDEO_STRING-$FOLDER.$EXTENSION"								
								mv /$TEMP_FOLDER/output.jpg "$PHOTOS_PATH/$YEAR-movies/$MONTH-$MONTH_HUMAN/$FOLDER/$YEAR-$MONTH-$MONTH_HUMAN-VIDEO-$INDEX_VIDEO_STRING-$FOLDER.jpg"
								mv /$TEMP_FOLDER/output.nfo "$PHOTOS_PATH/$YEAR-movies/$MONTH-$MONTH_HUMAN/$FOLDER/$YEAR-$MONTH-$MONTH_HUMAN-VIDEO-$INDEX_VIDEO_STRING-$FOLDER.nfo"								
																
								echo "Removing temp files ..."
								chmod +x /$TEMP_FOLDER/ln.$EXTENSION
								/$TEMP_FOLDER/ln.$EXTENSION
								rm /$TEMP_FOLDER/ln.$EXTENSION
								rm /$TEMP_FOLDER/list.$EXTENSION
							fi
							
							rm -Rf /$TEMP_FOLDER/$EXTENSION
							rm /$TEMP_FOLDER/list-files.$EXTENSION
						done
	                done
        done
done
