#!/bin/bash

BASE=`pwd`
TEST=uoc.ded.practica.MyLimonTest
LIBS=$BASE/lib/tads_cast.jar:$BASE/lib/junit-4.12.jar:$BASE/lib/hamcrest-core-1.3.jar:$BASE/class/main/java/:$BASE/class/test/java/:.
#OPTS="-Xlint:unchecked -encoding UTF-8 -g"
OPTS="-encoding UTF-8 -g"

echo
echo ">> Compilant : "
echo

if [ -d "class" ]; then
   rm -r class
fi
mkdir -p class/main/java
mkdir -p class/test/java

cd $BASE/src/main/java
javac $OPTS -classpath $LIBS -d $BASE/class/main/java uoc/ded/practica/model/*.java
javac $OPTS -classpath $LIBS -d $BASE/class/main/java uoc/ded/practica/util/*.java
javac $OPTS -classpath $LIBS -d $BASE/class/main/java uoc/ded/practica/*.java

cd $BASE/src/test/java
javac $OPTS -classpath $LIBS -d $BASE/class/test/java uoc/ded/practica/*.java


if [ "$?" -eq 0 ]  # si no hi ha cap error
then
   echo
   echo ">> Executant JUnit tests : "
   echo
   cd $BASE/src/main/java
   java -classpath $LIBS org.junit.runner.JUnitCore $TEST
fi
