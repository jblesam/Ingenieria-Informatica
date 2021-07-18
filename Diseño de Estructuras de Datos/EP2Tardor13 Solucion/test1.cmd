@echo off
echo ===========================================================
echo La sortida ha de dir "no s'han trobat diferencies"
echo Les seguents linies son una sortida correcta (en angles):
echo.
echo -Comparing files hopedOut.txt and out.txt
echo -FC: no differences encountered
echo ===========================================================
echo.
echo Compilant, executant i comparant sortides:
if exist out1.txt erase out1.txt
if exist class\uoc rd class\uoc /q /s
javac -encoding "ISO-8859-15" -g -classpath .;lib\tads.jar -d class src\uoc\ei\practica\*.java
if %ERRORLEVEL%==0 java -classpath class;lib\tads.jar uoc.ei.practica.TestPractica in1.txt out1.txt
echo.
if %ERRORLEVEL%==0 FC /L /N /W hopedOut1.txt out1.txt
pause
