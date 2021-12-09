#!/bin/bash

function plot(){
  dirs=`find skils -mindepth 1 -maxdepth 1 -type d`
  start_date='20211110'
  today=$(date "+%Y%m%d")
  for dir in $dirs;
  do
    md_files=($(ls $dir/*.md))
    arr=()
    for md_file in ${md_files[*]};
    do
      arr+=(`basename $md_file .md`)
    done 

    echo 'date count' > data/`basename $dir`.csv
    for i in ${!arr[*]}
    do
      echo ${arr[$i]} $((i+1)) >> data/`basename $dir`.csv
    done
  done


  gnuplot -e "
    set term png; 
    set xdata time; 
    set timefmt '%Y%m%d'; 
    set xrange ['$start_date':'$today'];
    plot for [i in system('find data -mindepth 1 -maxdepth 1')] i using 1:2 w lp  pt 7 title system('basename '.i)
  " > "commit.png"
}

cd `git rev-parse --show-toplevel`
plot