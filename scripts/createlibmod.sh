#!/bin/bash
LIBPATH=`pwd`/src/libsrc
FILE=lib_gkba
if [ ! -f $FILE.f90 ]; then
    > $FILE.f90
    {
    echo 'module '$FILE
    echo 'implicit none' 
    echo  'contains' 
    echo ' '
    echo ' '
    echo ' '
    echo ' '
    echo 'end module '$FILE 
} > $FILE.f90
fi
i=6
sed '/^include/ d' $FILE.f90 > .$FILE.f90
mv .$FILE.f90 $FILE.f90
for file in $(ls $LIBPATH | grep \.f90); do
  sed -i $i'i include "'$LIBPATH/${file%.*}'.f90"' $FILE.f90
  i=$((i+1))
done

sed -i '$ a export LGKBADIR='`pwd` ~/.bashrc
source ~/.bashrc

