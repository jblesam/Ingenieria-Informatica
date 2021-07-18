#!/bin/bash

mod=0
num=1
val=0
res=0

while [ $mod -eq 0 ]
do
  let num+=1
  let val=($1 % $num)

  if (($val == 0))
  then
    let mod=$num

    let res=($1 / $num)
    echo $1 "es producte de" $res "i" $num
  fi
done
