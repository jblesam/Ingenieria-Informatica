#!/bin/bash

mod=0
num=0
val=0

echo "l'invers de "$1 "mod" $2 "es:"

while [ $mod -eq 0 ]
do
  let num+=1
  let val=($1 * num)
  let res=($val % $2)

  if (($res == 1))
  then
    let mod=$val

    #echo $num ":" $val ":" $res
    echo $num
  fi
done
