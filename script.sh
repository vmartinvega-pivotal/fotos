#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

PHOTOS_PATH=$1

# Loop for years
for YEAR in `ls "$PHOTOS_PATH"`
do
        echo "Analyzing year: $YEAR"
		echo "Creating folder: $YEAR-ori"
		mkdir "$PHOTOS_PATH/$YEAR-ori"
		
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
				
				echo "Creating folder: $YEAR-ori/$MONTH-$MONTH_HUMAN"
				mkdir "$PHOTOS_PATH/$YEAR-ori/$MONTH-$MONTH_HUMAN"
				
                # Loop for folders
                for FOLDER in `ls "$PHOTOS_PATH/$YEAR/$MONTH"`
                do
                        echo "Analyzing folder: $FOLDER"
                        for FILE_JPG in `ls "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER" | grep -E '.jpg|.JPG'` # Grep jpg or JPG
                        do
                                echo "Analyzing file: $FILE_JPG"
								INDEX_FOTO=$((INDEX_FOTO + 1))
								INDEX_FOTO_LENGTH=${#INDEX_FOTO}
								INDEX_FOTO_STRING=$INDEX_FOTO
								if [[ $INDEX_FOTO_LENGTH = "1" ]]
								then
									INDEX_FOTO_STRING="0$INDEX_FOTO"
								fi
								cp "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER/$FILE_JPG" "$PHOTOS_PATH/$YEAR-ori/$MONTH-$MONTH_HUMAN/$YEAR-$MONTH-$MONTH_HUMAN-FOTO-$INDEX_FOTO_STRING-$FOLDER.jpg"
                        done
						
						INDEX_VIDEO=$((INDEX_VIDEO + 1))
						INDEX_VIDEO_LENGTH=${#INDEX_VIDEO}
						INDEX_VIDEO_STRING=$INDEX_VIDEO
						if [[ $INDEX_VIDEO_LENGTH = "1" ]]
						then
							INDEX_VIDEO_STRING="0$INDEX_VIDEO"
						fi
						
						VIDEO_AUX="0"
						EXTENSION="mp4"
						mkdir /temp_volume/mp4
						for FILE_MP4 in `ls "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER" | grep -E '.mp4|.MP4'` # Grep mp4 or MP4
                        do
							VIDEO_AUX=$((VIDEO_AUX + 1))
							cp "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER/$FILE_MP4" "/temp_volume/mp4/$VIDEO_AUX.mp4"
							echo "file '/temp_volume/mp4/$VIDEO_AUX.mp4'" >> /temp_volume/list
						done

						ffmpeg -f concat -safe 0 -i /temp_volume/list -c copy "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER/output"
						rm -Rf /temp_volume/mp4
						
						#touch "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER/output"
						cp "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER/output" "$PHOTOS_PATH/$YEAR-ori/$MONTH-$MONTH_HUMAN/$YEAR-$MONTH-$MONTH_HUMAN-VIDEO-$INDEX_VIDEO_STRING-$FOLDER.mp4"
						rm /temp_volume/list
						rm "$PHOTOS_PATH/$YEAR/$MONTH/$FOLDER/output"
	                done
        done
done
