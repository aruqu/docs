#!/bin/bash

start=($(grep -n '^subroutine' src/lib_gkba.f90 | cut -f1 -d: ))
finish=($(grep -n '^end subroutine' src/lib_gkba.f90 | cut -f1 -d: ))
names=($(grep '^end subroutine' src/lib_gkba.f90 | cut -f3 -d ' ' ))

for index in "${!start[@]}";
do
echo "$index ->  ${start[$index]} - ${finish[$index]}  ${names[$index]}"
cat intro.txt >> src/libsrc/${names[$index]}.f90  
sed -i 's/filename/'${names[$index]}'/g' src/libsrc/${names[$index]}.f90  
sed -n ${start[$index]},${finish[$index]}p src/lib_gkba.f90 >> src/libsrc/${names[$index]}.f90
#rm src/libsrc/${names[$index]}.f90
done

start=($(grep -n '^function' src/lib_gkba.f90 | cut -f1 -d: ))
finish=($(grep -n '^end function' src/lib_gkba.f90 | cut -f1 -d: ))
names=($(grep '^end function' src/lib_gkba.f90 | cut -f3 -d ' ' ))

for index in "${!start[@]}";
do
echo "$index ->  ${start[$index]} - ${finish[$index]}  ${names[$index]}"
cat intro.txt >> src/libsrc/${names[$index]}.f90  
sed -i 's/filename/'${names[$index]}'/g' src/libsrc/${names[$index]}.f90  
sed -n ${start[$index]},${finish[$index]}p src/lib_gkba.f90 >> src/libsrc/${names[$index]}.f90
#rm src/libsrc/${names[$index]}.f90
done


