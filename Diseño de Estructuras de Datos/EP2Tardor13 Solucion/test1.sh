#!/bin/bash

echo Compilant, executant i comparant sortides:

rm --force out1.txt
rm --force --recursive class/uoc
javac -encoding "ISO-8859-15" -g -classpath .:lib/tads.jar -d class src/uoc/ei/practica/*.java

if [ "$?" -eq 0 ]  # si no hi ha cap error
then
   java -classpath class:lib/tads.jar uoc.ei.practica.TestPractica in1.txt out1.txt
fi

if [ "$?" -eq 0 ]  # si no hi ha cap error
then
   diff --ignore-all-space hopedOut1.txt out1.txt && echo OK! || echo KO!
fi
