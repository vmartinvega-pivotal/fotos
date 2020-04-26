INPUT="/c/Users/vegav/Downloads/fotos/entrada/Camera"
OUTPUT="/c/Users/vegav/Downloads/fotos/salida"

for FILE in `ls "$INPUT"`
do
	echo "Analyzing file: ${FILE}"

	REGEX='^([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])\s(.*)$'

	LAST_MODIFIED=$(stat -c %y $INPUT/$FILE)

	if [[ ${LAST_MODIFIED} =~ $REGEX ]]
	then
	  YEAR=${BASH_REMATCH[1]}
	  MONTH=${BASH_REMATCH[2]}
	  DAY=${BASH_REMATCH[3]}

	  if [ ! -d ${OUTPUT}/${YEAR} ]; then
		mkdir ${OUTPUT}/${YEAR}
	  fi

	  if [ ! -d ${OUTPUT}/${YEAR}/${MONTH} ]; then
		mkdir ${OUTPUT}/${YEAR}/${MONTH}
	  fi

	  if [ ! -d ${OUTPUT}/${YEAR}/${MONTH}/${DAY} ]; then
		mkdir ${OUTPUT}/${YEAR}/${MONTH}/${DAY}
	  fi

	  mv ${INPUT}/${FILE} ${OUTPUT}/${YEAR}/${MONTH}/${DAY}/
	fi
done