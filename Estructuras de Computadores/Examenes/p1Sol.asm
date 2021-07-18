section .data               
;Canviar Nom i Cognom per les vostres dades.
developer db "_Nom_ _Cognom1_"

DimMatrix    equ 4		;Constants que també estan definides en C.
SizeMatrix   equ 16
RowScreenIni equ 10
ColScreenIni equ 16	

section .text            

;Variables definides en Assemblador.
global developer                        

;Subrutines d'assemblador que es criden des de C.
global showNumberP1, updateBoardP1, rotateMatrixRP1, copyMatrixP1
global shiftNumbersLP1, addPairsLP1
global readKeyP1, playP1

;Variables definides en C.
extern m, mRotated, score, state, moved
extern rowCur, colCur, charac, number, row, col, indexMat

;Funcions de C que es criden des de assemblador
extern clearScreen_C, printBoard_C, gotoxy_C, getch_C, printch_C
extern insertTileP1_C, printMessageP1_C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Situar el cursor en una fila i una columna de la pantalla
; en funció de la fila i columna indicats per les variables (rowCur) i 
; (colCur) cridant a la funció gotoxy_C.
;
; Variables utilitzades: 
; rowCur: Fila 
; colCur: Columna
; 
; Paràmetres d'entrada : 
; Cap
;    
; Paràmetres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
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

   ; Quan cridem la funció gotoxy_C(int row_num, int col_num) des d'assemblador 
   ; el primer paràmetre (rowCur) s'ha de passar pel registre rdi(edi), i
   ; el segon  paràmetre (colCur) s'ha de passar pel registre rsi(esi)		
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
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostrar un caràcter en la pantalla, guardat a la variable (charac),
; en la posició on està el cursor,  cridant a la funció printch_C.
; 
; Variables utilitzades: 
; charac: Caràcter que volem mostrar a la pantalla
; 
; Paràmetres d'entrada : 
; Cap
;    
; Paràmetres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
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

   ; Quan cridem la funció printch_C(char c) des d'assemblador, 
   ; el paràmetre (c) s'ha de passar pel registre rdi(dil).
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
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir un tecla i retornar el caràcter associat sense mostrar-lo 
; per pantalla cridant a la funció getch_C 
; i deixar-lo a la variable (charac).
; 
; 
; Variables utilitzades: 
; charac: Caràcter llegit de teclat
; 
; Paràmetres d'entrada : 
; Cap
;    
; Paràmetres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
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

   ; Cridem la funció getch_C(char c) des d'assemblador, 
   ; retorna sobre el registre rax(al) el caràcter llegit
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
; Convertir el valor de la variable (number) de tipus int (DWORD) 
; a caràcters ASCII que representen el seu valor.
; S'ha de dividir el valor entre 10, de forma iterativa, fins que el
; quocient de la divisió sigui 0.
; A cada iteració, el residu de la divisió que és un valor entre (0-9) 
; indica el valor del dígit que s'ha de convertir a ASCII ('0' - '9') 
; sumant '0' (48 decimal) per a poder-lo mostrar.
; S'han de mostrar els dígits (caràcters ASCII) des de la posició 
; indicada per les variables (rowcur) i (colcur), posició de les unitats, 
; cap a l'esquerra.
; Com el primer dígit que obtenim són les unitats, després les desenes,
; ..., per a mostrar el valor s'ha de desplaçar el cursor una posició
; a l'esquerra a cada iteració.
; Per a posicionar el cursor cridar a la subrutina gotoxyP1 i per a mostrar 
; els caràcters a la subrutina printchP1.
;
; Variables utilitzades:	
; rowCur : Fila per a posicionar el cursor a la pantalla.
; colCur : Columna per a posicionar el cursor a la pantalla.
; charac : Caràcter que volem mostrar
; number : Valor que volem mostrar.
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap.
;;;;;
showNumberP1:
	push rbp
	mov  rbp, rsp
	
	push rax
	push rbx
	push rcx
	push rdx

	mov ecx, DWORD[colCur] ;Guardem colCur per a restaurar-lo abans de sortir
	mov eax, DWORD[number] ;Número que volem mostrar

	showNumberP1_While:
		cmp eax, 0
		jle showNumberP1_End
		
		mov edx, 0
		mov ebx,10
		div ebx	    ;EAX=EDX:EAX/EBX, EDX=EDX:EAX mod EBX
     
		add dl,'0'	;convertim el valor a caràcters ASCII

		;Mostrar dígits
		;Fila rowCur i columna colCur
		call gotoxyP1
		
		mov  BYTE[charac], dl
		call printchP1
				
		dec  DWORD[colCur]     ;desplacem cursor a l'esquerra.
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
; Actualitzar el contingut del Tauler de Joc amb les dades de la matriu 
; (m) i els punts del marcador (score) que s'han fet.  
; S'ha de recórrer tota la matriu (m), i per a cada element de la matriu
; posicionar el cursor a la pantalla i mostrar el nombre d'aquella 
; posició de la matriu.
; Després, mostrar el marcador (score) a la part inferior del tauler.
; Finalment posicionar el cursor a la dreta de la darrera fila del tauler.
; Per a posicionar el cursor es crida a la subrutina gotoxyP1 i per a 
; mostrar els nombres de la matriu i el marcador de punts a la subrutina
; showNumberP1.
;
; Variables utilitzades:	
; rowCur : Fila per a posicionar el cursor a la pantalla.
; colCur : Columna per a posicionar el cursor a la pantalla.
; number : Número que volem mostrar.
; m      : matriu 4x4 on hi han els nombres del tauler de joc.
; score  : punts acumulats al marcador fins al moment.
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
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
	mov ecx, 0       ;índex per a accedir a la matriu m. (0-15)
					 ;índex=(fila*DimMatrix)+(columna)
		
	;Iniciem el bucle per a mostrar la matriu.
	updateBoardP1_bucle:
		
		
		movsx  edx, WORD[m+ecx] 	  ;number = (int)m[i][j];
		mov  DWORD[number], edx
		call showNumberP1
		
		add ecx, 2            ;incrementem l'índex per a accedir a la matriu
		add DWORD[colCur], 8  ;Actualitzem la columna del cursor

		inc eax               ;Actualitzem la columna.
		cmp eax, DimMatrix
		jl  updateBoardP1_bucle
		
		mov eax, 0            ;columna inicial
		mov DWORD[colCur], ColScreenIni ;columna inicial del cursor
		add DWORD[rowCur], 2  ;Actualitzem la fila del cursor		
		inc ebx               ;Actualitzem la fila.
		cmp ebx, DimMatrix
		jl  updateBoardP1_bucle

		;Actualitzem el valor del marcador a pantalla
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
; Calcular el valor de l'índex per a accedir a una matriu (4x4) que 
; guardarem a la variable (indexMat) a partir de la fila
; indicada per la variable (row) i la columna indicada per la variable 
; (col).
; indexMat=((row*DimMatrix)+(col))*2
; multipliquem per 2 perquè és una matriu de tipus short (WORD) 2 bytes.
;
; Aquesta subrutina no té una funció en C equivalent.
;
; Variables utilitzades:	
; row	  : fila per a accedir a la matriu m.
; col	  : columna per a accedir a la matriu m.
; indexMat: índex per a accedir a la matriu m.
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
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
	mul ebx		     ;multipliquem per 4 (EDX:EAX = EAX; font)
	add eax, DWORD[col]   ;eax = ([row]*DimMatrix)+([col])
	shl eax, 1       ;eax = (([row]*DimMatrix)+([col]))*2
	mov DWORD[indexMat], eax   ;indexMat=(([row]*DimMatrix)+([col]))*2
 
calcIndexP1_End:
	pop rdx
	pop rbx
	pop rax
			
	mov rsp, rbp
	pop rbp
	ret


;;;;;		
; Rotar a la dreta la matriu (m), sobre la matriu (mRotated). 
; La primera fila passa a ser la quarta columna, la segona fila passa 
; a ser la tercera columna, la tercera fila passa a ser la segona 
; columna i la quarta fila passa a ser la primer columna.
; A l'enunciat s'explica en més detall com fer la rotació.
; NOTA: NO és el mateix que fer la matriu transposada.
; La matriu (m) no s'ha de modificar, 
; els canvis s'han de fer a la matriu (mRotated).
; Per a accedir a les matrius des d'assemblador cal calcular l'índex 
; a partir de la fila i la columna cridant la subrutina calcIndexP1. 
; m[row][col], en C, és equivalent a WORD[m+eax], en assemblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és [m+12].
; No s'ha de mostrar la matriu.
; 
;
; Variables utilitzades:	
; m       : matriu 4x4 on hi han el números del tauler de joc.
; mRotated: matriu 4x4 per a fer la rotació.
; row	  : fila per a accedir a la matriu m.
; col	  : columna per a accedir a la matriu m.
; indexMat: índex per a accedir a la matriu m.
;
; Paràmetres d'entrada : 
; Cap.
;
; Paràmetres de sortida: 
; Cap.
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
; Copiar els valors de la matriu (mRotated) a la matriu (m).
; 
; Variables utilitzades:	
; m       : matriu 4x4 on hi han el números del tauler de joc.
; mRotated: matriu 4x4 per fer la rotació.
;
; Paràmetres d'entrada : 
; Cap.
;
; Paràmetres de sortida: 
; Cap.
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
		
		add eax, 2                 ;incrementem l'índex
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
; Desplaça a l'esquerra els nombres de cada fila de la matriu (m),
; mantenint l'ordre dels nombres i posant els zeros a la dreta.
; Recórrer la matriu per files d'esquerra a dreta i de dalt a baix.  
; Si es desplaça un número (NO ELS ZEROS), posarem la variable 
; (moved) a 1.
; Si una fila de la matriu és: [0,2,0,4] i moved = 0, quedarà [2,4,0,0] 
; i moved = 1.
; Per a accedir a les matrius des d'assemblador cal calcular l'índex 
; a partir de la fila i la columna cridant la subrutina calcIndexP1. 
; m[row][col], en C, és equivalent a WORD[m+eax], en assemblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és [m+12].
; Els canvis s'han de fer sobre la mateixa matriu.
; No s'ha de mostrar la matriu.
;
; Variables utilitzades:	
; moved   : Per a indicar si s'han fet canvis a la matriu.
; m       : matriu 4x4 on hi han el números del tauler de joc.
; row	  : fila per a accedir a la matriu m.
; col	  : columna per a accedir a la matriu m.
; indexMat: índex per a accedir a
;
; Paràmetres d'entrada : 
; Cap.
;
; Paràmetres de sortida: 
; Cap.
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
			inc r10d	     ;k = j+1;Busquem un nombre diferent de zero.
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
; Aparellar nombres iguals des de l'esquerra de la matriu (m) i acumular 
; els punts al marcador sumant el punts de les parelles que s'hagin fet.
; Recórrer la matriu per files d'esquerra a dreta i de dalt a baix. 
; Quan es trobi una parella, dos caselles consecutives amb el mateix 
; nombre, ajuntem la parella posant la suma dels nombres de la 
; parella a la casella de l'esquerra i un 0 a la casella de la dreta i 
; acumularem aquesta suma (punts que es guanyen).
; Si una fila de la matriu és: [8,4,4,2] i moved = 0, quedarà [8,8,0,2], 
; p = (4+4)= 8 i moved = 1.
; Si al final s'ha ajuntat alguna parella (punts>0), posarem la variable 
; (moved) a 1 per indicar que s'ha mogut algun nombre i actualitzarem la 
; variable (score) amb els punts obtinguts de fer les parelles.
; Per a accedir a les matrius des d'assemblador cal calcular l'índex 
; a partir de la fila i la columna cridant la subrutina calcIndexP1. 
; m[row][col], en C, és equivalent a WORD[m+eax], en assemblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és [m+12].
; No s'ha de mostrar la matriu.
;
; Variables utilitzades:	
; moved   : Per a indicar si s'han fet canvis a la matriu.
; score   : Punts acumulats fins el moment.
; m       : matriu 4x4 on hi han el números del tauler de joc.
; row	  : fila per a accedir a la matriu m.
; col	  : columna per a accedir a la matriu m.
; indexMat: índex per a accedir a
;
; Paràmetres d'entrada : 
; Cap.
;
; Paràmetres de sortida: 
; Cap.
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
		mov ecx, eax				;índex de [i][j]
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
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla. Guardar la tecla llegida en el registre al.
; Segons la tecla llegida cridarem a les subrutines corresponents.
;    ['i' (amunt),'j'(esquerra),'k' (avall) o 'l'(dreta)] 
; Desplaçar els números i fer les parelles segons la direcció triada.
; Segons la tecla premuda, rotar la matriu cridant (rotateMatrixRP1) i 
; (copyMatrixP1) per copiar la matriu rotada (mRotated) sobre la matriu 
; (m) per a poder fer els desplaçaments dels nombres cap a l'esquerra 
; (shiftNumbersLP1),  fer les parelles cap a l'esquerra (addPairsLP1) i 
; tornar a desplaçar els nombres cap a l'esquerra (shiftNumbersLP1) 
; amb les parelles fetes, després seguir rotant cridant (rotateMatrixRP1) 
; i (copyMatrixP1) fins deixar la matriu en la posició inicial. 
; Per a la tecla 'j' (esquerra) no cal fer rotacions, per a la resta 
; s'han de fer 4 rotacions.
;    '<ESC>' (ASCII 27)  posar (state = 0) per a sortir del joc.
; Si no és cap d'aquestes tecles no fer res.
; Els canvis produïts per aquestes subrutines no s'han de mostrar a la 
; pantalla, per tant, caldrà actualitzar després el tauler cridant la 
; subrutina UpdateBoardP1.
;
; Variables utilitzades:
; charac     : Caràcter que llegim de teclat.
; state   	 : Indica l'estat del joc. 0:sortir, 1:jugar
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;  
readKeyP1:
		push rbp
		mov  rbp, rsp

		push rax 
		
		call getchP1    ; Llegir una tecla i deixar-la al registre al.
		mov  al, BYTE[charac]
		
	readKeyP1_i:
		cmp al, 'i'		; amunt
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
		cmp al, 'j'		; esquerra
		jne  readKeyP1_k
			call shiftNumbersLP1
			call addPairsLP1
			call shiftNumbersLP1  
			jmp  readKeyP1_End
		
	readKeyP1_k:
		cmp al, 'k'		; dreta
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
		cmp al, 'l'		; avall
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
		cmp al, 27		; Sortir del programa
		jne  readKeyP1_End
			mov DWORD[state], 0

	readKeyP1_End:
		pop rax
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;
; Joc del 2048
; Funció principal del joc
; Permet jugar al joc del 2048 cridant totes les funcionalitats.
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
;
; Pseudo codi:
; Inicialitzar estat del joc, (state=1)
; Indicar que no s'ha fet cap moviment, (moved=0)
; Esborrar pantalla (cridar la funció clearScreen_C).
; Mostrar el tauler de joc (cridar la funció PrintBoard_C).
; Actualitza el contingut del Tauler de Joc i els punts que s'han fet
; (cridar la subrutina updateBoardP1).
; Mentre (state==1) fer
;   Llegir una tecla (cridar la subrutina readKeyP1). Segons la tecla 
;     llegida cridarem a les funcions corresponents.
;     - ['i','j','k' o 'l'] desplaçar els números i fer les parelles 
;                           segons la direcció triada.
;     - '<ESC>'  (codi ASCII 27) posar state = 0 per a sortir.   
;   Si hem mogut algun número al fer els desplaçaments o al fer les 
;   parelles (moved==1), generar una nova fitxa (cridant la funció 
;   insertTileP1_C) i posar la variable moved a 0 (moved=0).
;   Mostrar el tauler de joc (cridar la funció PrintBoard_C).
;   Actualitza el contingut del Tauler de Joc i els punts que s'han fet
;   (cridar la subrutina updateBoardP1).
; Fi mentre.
; Mostra un missatge a sota del tauler segons el valor de la variable 
; (state). (cridar la funció printMessageP1_C).
; Sortir: 
; S'acabat el joc.
;
; Variables utilitzades:
; state	: indica l'estat del joc. 0:sortir, 1:jugar.
; moved : Per a indicar si s'han fet canvis a la matriu.
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
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
