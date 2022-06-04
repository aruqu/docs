#!/bin/bash
# This script prepends an header of comments to .f90 files 
# which is for Doxygen preformatted for Doxygen
# The scripts autodetects the arguments of both functions
# and subroutines and add a field in the Dox-comments for each of them

if [ ! -d backup ]; then
	mkdir backup
fi

for file in $(ls *f90)
do

filename=$(basename -- "$file")
extension="${filename##*.}"
filename="${filename%%.*}"

type=($(grep '^end subroutine' $file | cut -f2 -d ' ' ))

if [[ -z $type ]]; then
	type=($(grep '^end function' $file | cut -f2 -d ' ' ))
fi

start=$( grep -n "^${type}" $file | cut -d ':' -f1 )
finish=($(grep -n "^end ${type}" $file | cut -f1 -d: ))
name=($(grep "^end $type" $file | cut -f3 -d ' ' ))

echo $file, $type, $start, $finish, $name


if [ ! -z $start ]; then


	if [ -f tmp.txt ]; then 
		rm tmp.txt
	fi
	touch tmp.txt
	echo '!> \name ' ${name^^} >> tmp.txt
	cat intro.txt >> tmp.txt
	#string=$(grep "^$type" $file | grep -o -P '(?<=\().*(?=\))') 
	string=$(grep "^$type" $file | cut -d ' ' -f2 |  grep -o -P '(?<=\().*(?=\))'),

	if [ -z $string ]; then
		echo $file 'HAS EMPTY STRING'
		echo $string
	fi


	var=$( cut -d ',' -f1 <<< $string )
	i=1
	while [[ $var != '' ]]
	do
	echo $i, $var
		sed -i '1 c !> \param[] '$var body.txt
		cat body.txt >> tmp.txt

		i=$((i+1))
		var=$( cut -d ',' -f$i <<< $string )

	done
	cat footer.txt >> tmp.txt
	mv tmp.txt tmp$filename.txt

	sed -n ${start},${finish}p $file >> tmp$filename.txt

	mv $file backup/old_${filename}.$extension
	mv tmp$filename.txt $file

fi

done
