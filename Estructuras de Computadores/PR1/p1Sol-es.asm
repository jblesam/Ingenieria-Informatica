section .data               
;Cambiar Nombre y Apellido1 por vuestros datos.
developer db "_Nombre_ _Apellido1_"

DimMatrix    equ 4		;Constantes que también están definidas en C.
SizeMatrix   equ 16
RowScreenIni equ 10
ColScreenIni equ 16	

section .text            

;Variables definidas en Ensamblador.
global developer                        

;Subrutinas de ensamblador que se llaman des de C.
global showNumberP1, updateBoardP1, rotateMatrixRP1, copyMatrixP1
global shiftNumbersLP1, addPairsLP1
global readKeyP1, playP1

;Variables definidas en C.
extern m, mRotated, score, state, moved
extern rowCur, colCur, charac, number, row, col, indexMat

;Funciones de C que se llaman desde ensamblador
extern clearScreen_C, printBoard_C, gotoxy_C, getch_C, printch_C
extern insertTileP1_C, printMessageP1_C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Situar el cursor en una fila y una columna de la pantalla
; en función de la fila (row_num) y de la columna (col_num) 
; recibidos como parámetro llamando a la función gotoxy_C.
;
; Variables utilizadas:  
; rowCur: Fila 
; colCur: Columna
; 
; Parámetros de entrada: 
; Ninguno
;    
; Parámetros de salida : 
; Ninguno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Cuando llamamos a la función gotoxy_C(int row_num, int col_num) 
   ; desde ensamblador, el primer parámetro (rowCur) se tiene que pasar 
   ; por el registro rdi(edi) y el segundo parámetro (colCur) se tiene
   ; pasar por el registro rsi(esi).
   mov edi,DWORD[rowCur]
   mov esi,DWORD[colCur]
   call gotoxy_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Mostrar un carácter en pantalla, guardado en la variable (charac),
; en la posición donde está el cursor, llamando la función printch_C


; Variables utilizadas:  
; charac: Carácter que queremos mostrar en pantalla.
; 
; Parámetros de entrada: 
; Ninguno
;    
; Parámetros de salida : 
; Ninguno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Cuando llamamos la función printch_C(char c) desde ensamblador, 
   ; el parámetro (c) se tiene que pasar por el registro rdi(dil).
   mov  rdi, 0
   mov  dil, BYTE[charac]
   call printch_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla y retornar el carácter asociado sin mostrarlo en 
; pantalla llamando la función getch_C y dejarlo en la variable (charac).
; 
; Variables utilizadas:  
; charac: Carácter leído de teclado
; 
; Parámetros de entrada: 
; Ninguno
;    
; Parámetros de salida : 
; Ninguno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Llamamos a la función getch_C(char c) desde ensamblador, 
   ; devuelve sobre el registro rax(al) el carácter leído.
   call getch_C
   mov BYTE[charac],al
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 


;;;;;
; Convierte el valor de la variable (number) de tipo int (DWORD)
; a caracteres ASCII que representen su valor. 
; Hay que dividir el valor entre 10,  de forma iterativa, 
; hasta que el cociente de la división sea 0.
; A cada iteración, el residuo de la división que es un valor
; entre (0-9) indica el valor del dígito que tenemos que convertir
; a ASCII ('0' - '9') sumando '0' (48 decimal) para poderlo mostrar.
; Se tienen que mostrar los dígitos (carácter ASCII) desde la posición 
; indicada por las variables (rowCur) y (colCur), posición de les 
; unidades, hacia la izquierda.
; Como el primer dígito que obtenemos son las unidades, después las decenas,
; ..., para mostrar el valor se tiene que desplazar el cursor una posición
; a la izquierda en cada iteración.
; Para posicionar el cursor se llamada a la función gotoxyP1 y para 
; mostrar los caracteres a la función printchP1.
;
; Variables utilizadas: 	
; rowCur : Fila para posicionar el cursor a la pantalla.
; colCur : Columna para posicionar el cursor a la pantalla.
; charac : Carácter que queremos mostrar
; number : Valor que queremos mostrar.
;
; Parámetros de entrada: 
; Ninguno
;
; Parámetros de salida : 
; Ninguno.
;;;;;
showNumberP1:
	push rbp
	mov  rbp, rsp
	
	push rax
	push rbx
	push rcx
	push rdx

	mov ecx, DWORD[colCur] ;Guardamos colCur para restaurarlo antes de salir.
	mov eax, DWORD[number] ;Número que queremos mostrar

	showNumberP1_While:
		cmp eax, 0
		jle showNumberP1_End
		
		mov edx, 0
		mov ebx,10
		div ebx	    ;EAX=EDX:EAX/EBX, EDX=EDX:EAX mod EBX
     
		add dl,'0'	;convertimos el valor a caracteres ASCII

		;Mostrar dígits
		;Fila rowCur y columna colCur
		call gotoxyP1
		
		mov  BYTE[charac], dl
		call printchP1
				
		dec  DWORD[colCur]     ;desplazamos cursor a la izquierda.
		jmp  showNumberP1_While
  
	showNumberP1_End:
	mov DWORD[colCur], ecx
	
	pop rdx
	pop rcx
	pop rbx
	pop rax
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;
; Actualizar el contenido del Tablero de Juego con los datos de 
; la matriz (m) y los puntos del marcador (score) que se han hecho.  
; Se tiene que recorrer toda la matriz (m), y para cada elemento de 
; la matriz posicionar el cursor en pantalla y mostrar el número de 
; esa posición de la matriz.
; Después, mostrar el marcador (score) en la parte inferior del tablero.
; Finalmente posicionar el cursor a la derecha de la última fila del tablero.
; Para posicionar el cursor se llama a la función gotoxyP1, y para 
; mostrar los números de la matriz y el marcador de puntos a la función 
; showNumberP1.
;
; Variables utilizadas: 	
; rowCur : Fila para posicionar el cursor en pantalla.
; colCur : Columna per a posicionar el cursor en pantalla.
; number : Número que queremos mostrar.
; m      : matriz 4x4 donde hay los números del tablero de juego.
; score  : puntos acumulados en el marcador hasta el momento.
;
; Parámetros de entrada: 
; Ninguno
;
; Parámetros de salida : 
; Ninguno
;;;;;  
updateBoardP1:
	push rbp
	mov  rbp, rsp
	
	push rax
	push rbx
	push rcx
	push rdx
	
	mov DWORD[rowCur], RowScreenIni      ;fila inicial del cursor
	mov DWORD[colCur], ColScreenIni      ;columna inicial del cursor
	
	mov eax, 0       ;fila (0-3)
	mov ebx, 0       ;columna (0-3)
	mov ecx, 0       ;índice para a acceder a la matriz m. (0-15)
					 ;índice=(fila*DimMatrix)+(columna)
		
	;Iniciamos el bucle para mostrar la matriz.
	updateBoardP1_bucle:
		
		
		movsx  edx, WORD[m+ecx] 	  ;number = (int)m[i][j];
		mov  DWORD[number], edx
		call showNumberP1
		
		add ecx, 2            ;incrementamos el índice para acceder a la matriz
		add DWORD[colCur], 8  ;Actualizamos la columna del cursor

		inc eax               ;Actualizamos la columna.
		cmp eax, DimMatrix
		jl  updateBoardP1_bucle
		
		mov eax, 0            ;columna inicial
		mov DWORD[colCur], ColScreenIni ;columna inicial del cursor
		add DWORD[rowCur], 2  ;Actualizamos la fila del cursor		
		inc ebx               ;Actualizamos la fila.
		cmp ebx, DimMatrix
		jl  updateBoardP1_bucle

		;Actualizamos el valor del marcador en pantalla.
		mov DWORD[colCur], ColScreenIni+8
		mov edx, DWORD[score]
		mov DWORD[number], edx
		call showNumberP1
		
		mov DWORD[colCur], ColScreenIni+24
		call gotoxyP1
		
	updateBoardP1_end:
	pop rdx
	pop rcx	
	pop rbx
	pop rax
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;  
; Calcular el valor del índice para acceder a una matriz (4x4) que 
; guardaremos en la variable (indexMat) a partir de la fila indicada 
; por la variable (row) y la columna indicada por la variable (col).
; indexMat=((row*DimMatrix)+(col))*2
; multiplicamos por 2 porque es una matriz de tipo short (WORD) 2 bytes.
;
; Esta subrutina no tiene una función en C equivalente.
;
; Variables utilizadas: 	
; row	  : fila para acceder a la matriz m.
; col	  : columna para acceder a la matriz m.
; indexMat: índice para acceder a la matriz m.
;
; Parámetros de entrada: 
; Ninguno
;
; Parámetros de salida : 
; Ninguno
;;;;;  
calcIndexP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx
	push rdx

	  
	mov rax, 0
	mov rbx, 0
	mov rdx, 0
	mov eax, DWORD[row]
	mov ebx, DimMatrix
	mul ebx		         ;multiplicamos por 4 (EDX:EAX = EAX; fuente)
	add eax, DWORD[col]  ;eax = ([row]*DimMatrix)+([col])
	shl eax, 1           ;eax = (([row]*DimMatrix)+([col]))*2
	mov DWORD[indexMat], eax   ;indexMat=(([row]*DimMatrix)+([col]))*2
 
calcIndexP1_End:
	pop rdx
	pop rbx
	pop rax
			
	mov rsp, rbp
	pop rbp
	ret


;;;;;		
; Rotar a la derecha la matriz (m), sobre la matriz (mRotated). 
; La primera fila pasa a ser la cuarta columna, la segunda fila pasa 
; a ser la tercera columna, la tercera fila pasa a ser la segunda
; columna y la cuarta fila pasa a ser la primer columna.
; En el enunciado se explica con más detalle como hacer la rotación.
; NOTA: NO es lo mismo que fer la matriz traspuesta.
; La matriz (m) no se tiene que modificar, 
; los cambios se tiene que hacer en la matriz (mRotated).
; Para acceder a matrices desde ensamblador hay que calcular el índice 
; a partir de la fila y la columna llamando a la subrutina calcIndexP1. 
; m[row][col], en C, es equivalente a WORD[m+eax], en ensamblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és DWORD[m+12].
; No se tiene que mostrar la matriz.
;
; Variables utilizadas: 	
; m       : matriz 4x4 donde hay los números del tablero de juego.
; mRotated: matriz 4x4 para hacer la rotación.
; row	  : fila para acceder a la matriz m.
; col	  : columna para acceder a la matriz m.
; indexMat: índice para acceder a la matriz m.
;
; Parámetros de entrada: 
; Ninguno.
;
; Parámetros de salida : 
; Ninguno.
;;;;;  
rotateMatrixRP1:
	push rbp
	mov  rbp, rsp
	
	push rax
	push rbx
	push r8
	push r9
	push r10
	
	mov r8d, 0					;i = r8d
	rotateMatrixRP1_Rows:
		
		mov r9d , 0				;j = r9d
		rotateMatrixRP1_Cols:
				
		mov DWORD[row], r8d
		mov DWORD[col], r9d
		call calcIndexP1
		mov eax, DWORD[indexMat]
		mov bx, WORD[m+eax]			;m[i][j]
		mov r10d, DimMatrix
		dec r10d
		sub r10d, r8d
		mov DWORD[row], r9d
		mov DWORD[col], r10d        ;DimMatrix-1-i
		call calcIndexP1
		mov eax, DWORD[indexMat]
		mov WORD[mRotated+eax], bx	;mRotated[j][DimMatrix-1-i] = m[i][j]
		
		inc r9d
		cmp r9d, DimMatrix
		jl  rotateMatrixRP1_Cols

	inc r8d
	cmp r8d, DimMatrix
	jl  rotateMatrixRP1_Rows
	

	rotateMatrixRP1_End:
	pop r10
	pop r9
	pop r8
	pop rbx
	pop rax
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;  
; Copiar los valores de la matriz (mRotated) a la matriz (m).
; 
; Variables utilizadas: 	
; m       : matriz 4x4 donde hay los números del tablero de juego.
; mRotated: matriz 4x4 para hacer la rotación.
;
; Parámetros de entrada: 
; Ninguno.
;
; Parámetros de salida : 
; Ninguno.
;;;;;  
copyMatrixP1:
	push rbp
	mov  rbp, rsp
	
	push rax
	push rbx
	push r8
	push r9

    mov eax, 0
	mov r8d, 0					;i = r8d
	copyMatrixP1_Rows:
		
		mov r9d , 0				;j = r9d
		copyMatrixP1_Cols:
				
		mov bx, WORD[mRotated+eax] ;mRotated[i][j]
		mov WORD[m+eax], bx	       ;m[i][j] = mRotated[i][j]
		
		add eax, 2                 ;incrementamos el índice
		inc r9d
		cmp r9d, DimMatrix
		jl  copyMatrixP1_Cols

	inc r8d
	cmp r8d, DimMatrix
	jl  copyMatrixP1_Rows
	

	copyMatrixP1_End:
	pop r9
	pop r8
	pop rbx
	pop rax
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;  
; Desplazar a la izquierda los números de cada fila de la matriz (m), 
; manteniendo el orden de los números y poniendo los ceros a la derecha.
; Recorrer la matriz por filas de izquierda a derecha y de arriba a bajo.  
; Si se desplaza un número (NO LOS CEROS) pondremos la variable 
; (moved) a 1.
; Si una fila de la matriz es: [0,2,0,4] y moved = 0, quedará [2,4,0,0] 
; y moved = 1.
; Para acceder a matrices desde ensamblador hay que calcular el índice 
; a partir de la fila y la columna llamando a la subrutina calcIndexP1. 
; m[row][col], en C, es equivalente a WORD[m+eax], en ensamblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és DWORD[m+12].
; Los cambios se tienen que hacer sobre la misma  matriz.
; No se tiene que mostrar la matriz.
;
; Variables utilizadas: 	
; moved   : Para indicar si se han hecho cambios en la matriz.
; m       : matriz 4x4 donde hay los números del tablero de juego.
; row	  : fila para acceder a la matriz m.
; col	  : columna para acceder a la matriz m.
; indexMat: índice para acceder a la matriz m.
;
; Parámetros de entrada: 
; Ninguno.
;
; Parámetros de salida : 
; Ninguno.
;;;;;  
shiftNumbersLP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx
	push r8
	push r9
	push r10
	
	mov r8d, 0							;i = r8d
	shiftNumbersLP1_Rows:
	mov r9d , 0							;j = r9d
		shiftNumbersLP1_Cols:
		mov DWORD[row], r8d
		mov DWORD[col], r9d
		call calcIndexP1
		mov eax, DWORD[indexMat]
		cmp WORD[m+eax], 0  			;if (m[i][j] == 0)
		jne shiftNumbersLP1_IsZero
			mov r10d, r9d
			inc r10d	    ;k = j+1;Buscamos un número diferente de cero
			shiftNumbersLP1_While:
			cmp r10d, DimMatrix	    	;k<DimMatrix
			jge shiftNumbersLP1_EndWhile
				mov DWORD[row], r8d
				mov DWORD[col], r10d
				call calcIndexP1
				mov eax, DWORD[indexMat]
				cmp WORD[m+eax], 0 	    ;m[i][k]==0
				jne shiftNumbersLP1_EndWhile
					inc r10d			;k++;
				jmp shiftNumbersLP1_While
			shiftNumbersLP1_EndWhile:
			cmp r10d, DimMatrix			;k==DimMatrix
			je shiftNumbersLP1_Next
				mov bx, WORD[m+eax]
				mov WORD[m+eax], 0		;m[i][k]= 0
				mov DWORD[row], r8d
				mov DWORD[col], r9d
				call calcIndexP1
				mov eax, DWORD[indexMat]
				mov WORD[m+eax], bx		;m[i][j]=m[i][k]
				mov DWORD[moved], 1		;moved=1;
		shiftNumbersLP1_IsZero:
		inc r9d
		cmp r9d, DimMatrix-1 			;j<DimMatrix-1
		jl  shiftNumbersLP1_Cols
	shiftNumbersLP1_Next:
	inc r8d
	cmp r8d, DimMatrix					;i<DimMatrix
	jl  shiftNumbersLP1_Rows


shiftNumbersLP1_End:  
	pop r10
	pop r9
	pop r8
	pop rbx
	pop rax         
	
	mov rsp, rbp
	pop rbp
	ret
		

;;;;;  
; Emparejar números iguales des la izquierda de la matriz (m) y acumular 
; los puntos en el marcador sumando los puntos de las parejas que se hagan.
; Recorrer la matriz por filas de izquierda a derecha y de arriba a bajo. 
; Cuando se encuentre una pareja, dos casillas consecutivas con el mismo 
; número, juntamos la pareja poniendo la suma de los números de la 
; pareja en la casilla de la izquierda y un 0 en la casilla de la derecha y 
; acumularemos esta suma puntos que se ganan).
; Si una fila de la matriz es: [8,4,4,2] y moved = 0, quedará [8,8,0,2], 
; p = (4+4)= 8 y moved = 1.
; Si al final se ha juntado alguna pareja (puntos>0), pondremos la variable 
; (moved) a 1 para indicar que se ha movido algún número y actualizaremos
; la variable (score) con los puntos obtenidos de hacer las parejas.
; Para acceder a matrices desde ensamblador hay que calcular el índice 
; a partir de la fila y la columna llamando a la subrutina calcIndexP1. 
; m[row][col], en C, es equivalente a WORD[m+eax], en ensamblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és DWORD[m+12].
; No se tiene que mostrar la matriz.
; 
; Variables utilizadas: 	
; moved   : Para indicar si se han hecho los cambios en la matriz.
; score   : Puntos acumulados hasta el momento.
; m       : matriz 4x4 donde hay los números del tablero de juego.
; row	  : fila para acceder a la matriz m.
; col	  : columna para acceder a la matriz m.
; indexMat: índice para acceder a la matriz m.
;
; Parámetros de entrada: 
; Ninguno.
;
; Parámetros de salida : 
; Ninguno.
;;;;;  
addPairsLP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx
	push rcx
	push r8
	push r9
	push r10
	
	mov r10, 0 						;p = 0
	mov rbx, 0
	
	mov r8d, 0						;i = r8d
	addPairsLP1_Rows:
	mov r9d , 0						;j = r9d
		addPairsLP1_Cols:
		mov DWORD[row], r8d
		mov DWORD[col], r9d
		call calcIndexP1
		mov eax, DWORD[indexMat]
		mov ecx, eax				;índice de [i][j]
		mov bx, WORD[m+ecx]			
		cmp bx, 0					;m[i][j]!=0
		je  addPairsLP1_EndIf
			inc DWORD[col]
			call calcIndexP1
			mov eax, DWORD[indexMat]
			cmp bx, WORD[m+eax]	 	;m[i][j]==m[i][j+1]
			jne addPairsLP1_EndIf
				shl bx,1			;m[i][j]*2
				mov WORD[m+ecx], bx		;m[i][j]  = m[i][j]*2
				mov WORD[m+eax], 0	;m[i][j+1]= 0
				add r10w, bx		;p = p + m[i][j]
				inc r9d				;j++
		addPairsLP1_EndIf:
		inc r9d
		cmp r9d, DimMatrix-1 		;j<DimMatrix-1
		jl  addPairsLP1_Cols
	addPairsLP1_Next:
	inc r8d
	cmp r8d, DimMatrix				;i<DimMatrix
	jl  addPairsLP1_Rows

	cmp r10d, 0						;p > 0
	je  addPairsLP1_End	
	mov DWORD[moved], 1				;moved=1;

	addPairsLP1_End:
	add DWORD[score], r10d			;score = score + p;
		
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rbx
	pop rax       
	
	mov rsp, rbp
	pop rbp
	ret
	

;;;;;; 
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla. Guardar la tecla leída en el registro al.
; Según la tecla leída llamaremos a las subrutinas que corresponda.
;    ['i' (arriba),'j'(izquierda),'k' (a bajo) o 'l'(derecha)] 
; Desplazar los números y hacer las parejas según la dirección escogida.
; Según la tecla pulsada, rotar la matriz llamando (rotateMatrixRP1) y 
; (copyMatrixP1) para copiar la matriz rotada (mRotated) sobre la matriz 
; (m) para poder hacer los desplazamientos de los números hacia la izquierda
; (shiftNumbersLP1),  hacer las parejas hacia la izquierda (addPairsLP1) 
; y volver a desplazar los números hacia la izquierda (shiftNumbersLP1) 
; con las parejas hechas, después seguir rotando llamando (rotateMatrixRP1) 
; y (copyMatrixP1) hasta dejar la matriz en la posición inicial. 
; Para la tecla 'j' (izquierda) no hay que hacer rotaciones, para el
; resto se tienen que hacer 4 rotaciones.
;    '<ESC>' (ASCII 27)  poner (state = 0) para salir del juego.
; Si no es ninguna de estas teclea no hacer nada.
; Los cambios producidos por estas funciones no se tiene que mostrar en 
; pantalla, por lo tanto, hay que actualizar después el tablero llamando 
; la subrutina UpdateBoardP1_C.
;
; Variables utilizadas: 
; charac     : Carácter que leemos de teclado.
; state   : Indica el estado del juego. 0:salir, 1:jugar
;
; Parámetros de entrada: 
; Ninguno
;
; Parámetros de salida : 
; Ninguno
;;;;;  
readKeyP1:
		push rbp
		mov  rbp, rsp

		push rax 
		
		call getchP1    ; Leer una tecla y dejarla en el registro al.
		mov  al, BYTE[charac]
		
	readKeyP1_i:
		cmp al, 'i'		; arriba
		jne  readKeyP1_j
			call rotateMatrixRP1
			call copyMatrixP1
			call rotateMatrixRP1
			call copyMatrixP1
			call rotateMatrixRP1
			call copyMatrixP1
			call shiftNumbersLP1
			call addPairsLP1
			call shiftNumbersLP1  
			call rotateMatrixRP1
			call copyMatrixP1
			jmp  readKeyP1_End
		
	readKeyP1_j:
		cmp al, 'j'		; izquierda
		jne  readKeyP1_k
			call shiftNumbersLP1
			call addPairsLP1
			call shiftNumbersLP1  
			jmp  readKeyP1_End
		
	readKeyP1_k:
		cmp al, 'k'		; derecha
		jne  readKeyP1_l
			
			call rotateMatrixRP1
			call copyMatrixP1
			call shiftNumbersLP1
			call addPairsLP1
			call shiftNumbersLP1  
			call rotateMatrixRP1
			call copyMatrixP1
			call rotateMatrixRP1
			call copyMatrixP1
			call rotateMatrixRP1
			call copyMatrixP1
			jmp  readKeyP1_End
		
	readKeyP1_l:
		cmp al, 'l'		; a bajo
		jne  readKeyP1_ESC
			call rotateMatrixRP1
			call copyMatrixP1
			call rotateMatrixRP1
			call copyMatrixP1
			call shiftNumbersLP1
			call addPairsLP1
			call shiftNumbersLP1  
			call rotateMatrixRP1
			call copyMatrixP1
			call rotateMatrixRP1
			call copyMatrixP1
			jmp  readKeyP1_End
		
	readKeyP1_ESC:
		cmp al, 27		; Salir del programa.
		jne  readKeyP1_End
			mov DWORD[state], 0

	readKeyP1_End:
		pop rax
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;
; Juego del 2048
; Función principal del juego
; Permite jugar al juego del 2048 llamando todas las funcionalidades.
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
;
; Pseudo-código:
; Inicializar estado del juego, (state=1)
; Indicar que no se han hecho movimientos, (moved=0)
; Borrar pantalla (llamar a la función clearScreen_C).
; Mostrar el tablero de juego (llamar a la funciónPrintBoard_C).
; Actualizar el contenido del Tablero de Juego y los puntos que se han 
; hecho (llamar a la función updateBoardP1).
; Mientras (state==1) hacer
;   Leer una tecla (llamar a la función readKeyP1). Según la tecla 
;     leída llamar a las funciones que corresponda.
;     - ['i','j','k' o 'l'] desplazar los números y hacer las parejas 
;                           según la dirección escogida.
;     - '<ESC>'  (código ASCII 27) poner (state = 0) para salir.   
;   Si hemos movido algún número al hacer los desplazamientos o al hacer
;   las parejas (moved==1) generar una nueva ficha (llamando a la función
;   insertTileP1_C) y poner la variable moved a 0 (moved=0).
;   Mostrar el tablero de juego (llamar a la función PrintBoard_C).
;   Actualizar el contenido del Taublero de Juego y los puntos que se han
;   hecho (llamar a la función updateBoardP1).
; Fin mientras.
; Mostrar un mensaje debajo del tablero según el valor de la variable 
; (state). (llamar a la función printMessageP1_C).
; Salir: 
; Se ha terminado el juego.

; Variables utilizadas: 
; state  : Indica el estado del juego. 0:salir, 1:jugar
; moved  : Para indicar si se han hecho cambios en la matriz.
;
; Parámetros de entrada: 
; Ninguno
;
; Parámetros de salida : 
; Ninguno
;;;;;  
playP1:
	push rbp
	mov  rbp, rsp
	
	mov DWORD[state], 1   ;state = 1;  //estat per a començar a jugar	
	mov DWORD[moved], 0	  ;moved = 0;  //No s'han fet moviments
	
	call clearScreen_C
	call printBoard_C
	call updateBoardP1

	playP1_Loop:              ;while  {  	//Bucle principal.
	cmp  DWORD[state], 1	  ;(state == 1)
	jne  playP1_End
		
		call readKeyP1		  ;readKeyP1_C();
		cmp DWORD[moved], 1   ;moved == 1 //Si s'ha fet algun moviment,
		jne playP1_Next 
			call insertTileP1_C  ;insertTileP1_C(); //Afegir fitxa (2 o 4)
			mov DWORD[moved],0;moved = 0;
		playP1_Next
		call printBoard_C	  ;printBoard_C();
		call updateBoardP1	  ;updateBoardP1_C();
		
	jmp playP1_Loop

	playP1_End:
	call printMessageP1_C ;printMessageP1_C();//Mostra el missatge per a indicar com acaba.

	mov rsp, rbp
	pop rbp
	ret
