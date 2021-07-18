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
global showNumberP2, updateBoardP2, rotateMatrixRP2, copyStatusP2, 
global shiftNumbersLP2, addPairsLP2
global readKeyP2, CheckEndP2, playP2

;Variables definides en C.
extern m, mRotated, mAux, mUndo, score, scoreAux, scoreUndo, state, moved

;Funcions de C que es criden des de assemblador
extern clearScreen_C, printBoard_C, gotoxy_C, getch_C, printch_C, 
extern insertTileP2_C, printMessageP2_C,  	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Situar el cursor en una fila i una columna de la pantalla
; en funció de la fila (edi) i columna (esi) rebuts com a paràmetres
; cridant a la funció gotoxy_C.
;
; Variables utilitzades:
; Cap.
; 
; Paràmetres d'entrada : 
; edi: Fila.
; esi: Columna.
;    
; Paràmetres de sortida: 
; Cap.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP2:
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
   ; el primer paràmetre (row_num) s'ha de passar pel registre rdi(edi), i
   ; el segon  paràmetre (col_num) s'ha de passar pel registre rsi(esi)		
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
; Mostrar un caràcter en la pantalla, rebut com a paràmetre al 
; registre (dil), en la posició on està el cursor,  
; cridant a la funció printch_C.
; 
; Variables utilitzades: 
; Cap.
; 
; Paràmetres d'entrada : 
; rdi (dil): Caràcter que volem mostrar a la pantalla.
;    
; Paràmetres de sortida: 
; Cap.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP2:
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
; per pantalla cridant a la funció getch_C que el retorna sobre el
; registre (al).
; 
; Variables utilitzades: 
; Cap.
; 
; Paràmetres d'entrada : 
; Cap.
;    
; Paràmetres de sortida: 
; rax (al): Caràcter llegit de teclat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP2:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
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

   mov rax, 0
   ; Cridem la funció getch_C(char c) des d'assemblador, 
   ; retorna sobre el registre rax(al) el caràcter llegit
   call getch_C
    
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
      
   mov rsp, rbp
   pop rbp
   ret 


;;;;;
; Convertir el valor rebut com a paràmetre (edx) de tipus int(DWORD)
; als caràcters ASCII que representen el seu valor
; S'ha de dividir el valor entre 10, de forma iterativa, 
; fins que el quocient de la divisió sigui 0.
; A cada iteració, el residu de la divisió que és un valor entre (0-9) 
; indica el valor del dígit que s'ha de convertir a ASCII ('0' - '9') 
; sumant '0' (48 decimal) per a poder-lo mostrar.
; S'han de mostrar els dígits (caràcters ASCII) des de la posició 
; indicada per la fila (edi) i la columna (esi) rebuts com a paràmetre,
; posició de les unitats, cap a l'esquerra.
; Com el primer dígit que obtenim són les unitats, després les desenes,
; ..., per a mostrar el valor s'ha de desplaçar el cursor una posició
; a l'esquerra a cada iteració.
; Per a posicionar el cursor cridar a la subrutina gotoxyP2 i per a mostrar 
; els caràcters a la subrutina printchP2 implementant correctament el pas
; de paràmetres.
;
; Variables utilitzades:	
; Cap.
;
; Paràmetres d'entrada : 
; rdi (edi): Fila on el volem mostrar a la pantalla.
; rsi (esi): Columna on el volem mostrar a la pantalla.
; rdx (edx): Valor que volem mostrar a la pantalla.
;
; Paràmetres de sortida: 
; Cap.
;;;;;
showNumberP2:
	push rbp
	mov  rbp, rsp
	
	push rax
	push rbx
	push rdx
	push rsi
	push rdi

	mov rax, rdx ;Valor que volem mostrar

	showNumberP2_While:
		cmp eax, 0
		jle showNumberP2_End
		
		mov edx, 0
		mov ebx,10
		div ebx	    ;EAX=EDX:EAX/EBX, EDX=EDX:EAX mod EBX
     
		add dl,'0'	;convertim el valor a caràcters ASCII

		;Mostrar dígits
		call gotoxyP2
		push rdi
		mov  dil, dl
		call printchP2
		pop  rdi
		
		dec  esi     ;desplacem cursor a l'esquerra.
		jmp  showNumberP2_While
  
	showNumberP2_End:
	pop rdi
	pop rsi
	pop rdx
	pop rbx
	pop rax
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;
; Actualitzar el contingut del Tauler de Joc amb les dades de la matriu 
; (m) i els punts del marcador (score) que s'han fet.  
; S'ha de recórrer tota la matriu (m), i per a cada element de la matriu
; posicionar el cursor a la pantalla i mostrar el nombre  
; d'aquella posició de la matriu.
; Després, mostrar el marcador (score) a la part inferior del tauler.
; Finalment posicionar el cursor a la dreta de la darrera fila del tauler.
; Per a posicionar el cursor es crida a la subrutina gotoxyP2 i per a 
; mostrar els nombres de la matriu i el marcador a la subrutina showNumberP2
; implementant correctament el pas de paràmetres.
;
; Variables utilitzades:	
; m     : matriu 4x4 on hi han els nombres del tauler de joc.
; score : punts acumulats fins el moment.
;
; Paràmetres d'entrada : 
; Cap.
;
; Paràmetres de sortida: 
; Cap.
;;;;;  
updateBoardP2:
	push rbp
	mov  rbp, rsp
	
	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	
	mov edi, RowScreenIni      ;fila inicial del cursor
	mov esi, ColScreenIni      ;columna inicial del cursor
	
	mov eax, 0       ;fila (0-3)
	mov ebx, 0       ;columna (0-3)
	mov ecx, 0       ;índex per a accedir a la matriu m. (0-15)
					 ;índex=(fila*DimMatrix)+(columna)
		
	;Iniciem el bucle per a mostrar la matriu.
	updateBoardP2_bucle:
		
		movsx  edx, WORD[m+ecx] ;(int)m[i][j];
		call showNumberP2
		
		add esi, 8            ;Actualitzem la columna del cursor
		add ecx, 2			  ;incrementem l'índex per a accedir a la matriu
		inc eax               ;Actualitzem la columna.
		cmp eax, DimMatrix
		jl  updateBoardP2_bucle
		
		mov eax, 0            ;columna inicial
		mov esi, ColScreenIni ;columna inicial del cursor
		add edi, 2            ;Actualitzem la fila del cursor		
		inc ebx               ;Actualitzem la fila.
		cmp ebx, DimMatrix
		jl  updateBoardP2_bucle

		;Actualitzem el valor del marcador a pantalla
		mov esi, ColScreenIni+8
		mov edx, DWORD[score]
		call showNumberP2
		
		mov esi, ColScreenIni+24
		call gotoxyP2
		
	updateBoardP2_end:
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
; Calcular el valor de l'índex per a accedir a una matriu (4x4) 
; que guardarem al registre (eax) a partir de la fila (edi) i la columna
; (esi) rebuts com a paràmetre.
; eax=((edi*DimMatrix)+(esi))*2 
; multipliquem per 2 perquè és una matriu de tipus short (WORD) 2 bytes.
;
; Aquesta subrutina no té una funció en C equivalent.
;
; Variables utilitzades:	
; Cap.
;
; Paràmetres d'entrada : 
; rdi(edi) : fila per a accedir a la matriu (4x4). 
; rsi(esi) : columna per a accedir a la matriu (4x4). 
;
; Paràmetres de sortida: 
; rax(eax) : índex per a accedir a la matriu (4x4) de tipus WORD.
;;;;;  
calcIndexP2:
	push rbp
	mov  rbp, rsp

	push rbx
	push rdx
	push rsi
	push rdi
	  
	mov rax, 0
	mov rbx, 0
	mov rdx, 0
	mov eax, edi
	mov ebx, DimMatrix
	mul ebx		     ;multipliquem per 4 (EDX:EAX = EAX; font)
	add eax, esi     ;eax = ([edi]*DimMatrix)+([esi])
	shl eax, 1       ;eax = (([edi]*DimMatrix)+([esi]))*2
  
calcIndexP2_End:
	pop rdi
	pop rsi
	pop rdx
	pop rbx
			
	mov rsp, rbp
	pop rbp
	ret


;;;;;		
; Rotar a la dreta la matriu, rebuda com a paràmetre (edi), sobre 
; la matriu (mRotated).
; La primera fila passa a ser la quarta columna, la segona fila passa 
; a ser la tercera columna, la tercera fila passa a ser la segona 
; columna i la quarta fila passa a ser la primer columna.
; A l'enunciat s'explica en més detall com fer la rotació.
; NOTA: NO és el mateix que fer la matriu transposada.
; La matriu rebuda com a paràmetre no s'ha de modificar, 
; els canvis s'han de fer a la matriu (mRotated).
; Per a accedir a les matrius des d'assemblador cal calcular l'índex 
; a partir de la fila i la columna cridant la subrutina calcIndexP2. 
; m[row][col], en C, és equivalent a WORD[m+eax], en assemblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és [m+12].
; No s'ha de mostrar la matriu.
;
; Variables utilitzades:	
; Cap.
;
; Paràmetres d'entrada : 
; rdi(edi): Adreça de la matriu que volem rotar.
;
; Paràmetres de sortida: 
; Cap.
;;;;;  
rotateMatrixRP2:
	push rbp
	mov  rbp, rsp
	
	push rax
	push rbx
	push rdx
	push rsi
	push rdi
	push r8
	push r9
	push r10
	
	mov edx, edi 				;Adreça de la matriu

	mov r8d, 0					;i = r8d
	rotateMatrixRP2_Rows:
		
		mov r9d , 0				;j = r9d
		rotateMatrixRP2_Cols:

		mov edi, r8d
		mov esi, r9d
		call calcIndexP2
		mov bx, WORD[edx+eax]	;matriu[i][j];
		
		mov r10d, DimMatrix
		dec r10d
		sub r10d, r8d			;DimMatrix-1-i = r10d
		mov edi, r9d
		mov esi, r10d
		call calcIndexP2
		mov WORD[mRotated+eax], bx	;mRotated[j][DimMatrix-1-i] = matriu[i][j]
		
		inc r9d
		cmp r9d, DimMatrix
		jl  rotateMatrixRP2_Cols

	inc r8d
	cmp r8d, DimMatrix
	jl  rotateMatrixRP2_Rows
	

	rotateMatrixRP2_End:
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rbx
	pop rax
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;  
; Copia una matriu del joc en un altre matriu i retorna els punts que 
; hi té associats. Això permetrà copiar dues matrius després d'una 
; rotació i gestionar l'opció '(u)Undo' del joc.
; Copia la matriu origen, segon paràmetre (esi), sobre la matriu 
; destinació, primer paràmetre (edi) i retorna els punts associat,
; tercer paràmetre (rdx).
;
; Variables utilitzades:	
; Cap.
;
; Paràmetres d'entrada : 
; rdi(edi): Adreça de la matriu destinació.
; rsi(esi): Adreça de la matriu origen.
; rdx(edx): Punts associats a la matriu origen. 
;
; Paràmetres de sortida: 
; rax(eax) : Punts associats a la matriu origen.
;;;;;  
copyStatusP2:
	push rbp
	mov  rbp, rsp

	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r8
	push r9
	push r10
	push r11
	
	mov r10d, edi 					;Adreça de la matriu destinació
	mov r11d, esi 					;Adreça de la matriu origen
	
	mov eax, 0
	mov r8d, 0						;i = r8d
	copyStatusP2_Rows:
	mov r9d , 0						;j = r9d
		copyStatusP2_Cols:
		
		mov bx, WORD[r11d+eax]		;mOrig[i][j]
		mov WORD[r10d+eax], bx		;mDest[i][j]=mOrig[i][j]
	
		add eax, 2                 ;incrementem l'índex
		inc r9d
		cmp r9d, DimMatrix 			;j<DimMatrix
		jl  copyStatusP2_Cols
	
	inc r8d
	cmp r8d, DimMatrix				;i<DimMatrix
	jl  copyStatusP2_Rows

	mov rax, rdx					;retorna punts origen;

	copyStatusP2_End:
	pop r11
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx         
	
	mov rsp, rbp
	pop rbp
	ret	
	

;;;;;  
; Desplaça a l'esquerra els nombres de cada fila de la matriu rebuda com
; a paràmetre (edi), mantenint l'ordre dels nombres i posant 
; els zeros a la dreta.
; Recórrer la matriu per files d'esquerra a dreta i de dalt a baix.  
; Si es desplaça un nombre (NO ELS ZEROS), s'han de comptar els 
; desplaçaments.
; Si s'ha mogut algun nombre (nombre de desplaçaments>0), posarem la 
; variable (moved) a 1.
; Retornarem el número de desplaçaments fets.
; Si una fila de la matriu és: [0,2,0,4] i el número de desplaçaments 
; es 0, quedarà [2,4,0,0] i el número de desplaçaments serà 2.
; Per a accedir a les matrius des d'assemblador cal calcular l'índex 
; a partir de la fila i la columna cridant la subrutina calcIndexP1. 
; m[row][col], en C, és equivalent a WORD[m+eax], en assemblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és [m+12].
; Els canvis s'han de fer sobre la mateixa matriu.
; No s'ha de mostrar la matriu.
;
; Variables utilitzades:	
; moved : Per indicar si s'han fet canvis a la matriu.
;
; Paràmetres d'entrada : 
; rdi(edi): Adreça de la matriu que volem desplaçar els nombres.
;
; Paràmetres de sortida: 
; rax(eax) : Número de desplaçaments fets.
;;;;;  
shiftNumbersLP2:
	push rbp
	mov  rbp, rsp

	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r8
	push r9
	push r10
	
	mov edx, edi 						;Adreça de la matriu
	mov ecx, 0 							;shifts=0;
	
	mov r8d, 0							;i = r8d
	shiftNumbersLP2_Rows:
	mov r9d , 0							;j = r9d

		shiftNumbersLP2_Cols:
		mov edi, r8d
		mov esi, r9d
		call calcIndexP2
		cmp WORD[edx+eax], 0  			;if (mShift[i][j] == 0)
		jne shiftNumbersLP2_IsZero
			mov r10d, r9d
			inc r10d	;k = j+1;Busquem un nombre diferent de zero.
			shiftNumbersLP2_While:
			cmp r10d, DimMatrix	    	;k<DimMatrix
			jge shiftNumbersLP2_EndWhile
				mov edi, r8d
				mov esi, r10d
				call calcIndexP2
				cmp WORD[edx+eax], 0 	;mShift[i][k]==0
				jne shiftNumbersLP2_EndWhile
					inc r10d			;k++;
				jmp shiftNumbersLP2_While
			shiftNumbersLP2_EndWhile:
			cmp r10d, DimMatrix			;k==DimMatrix
			je shiftNumbersLP2_Next
				mov bx, WORD[edx+eax]
				mov WORD[edx+eax], 0	;mShift[i][k]= 0
				mov edi, r8d
				mov esi, r9d
				call calcIndexP2
				mov[edx+eax], bx		;mShift[i][j]=mShift[i][k]
				inc ecx					;shifts++
		shiftNumbersLP2_IsZero:
		inc r9d
		cmp r9d, DimMatrix-1 			;j<DimMatrix-1
		jl  shiftNumbersLP2_Cols
	shiftNumbersLP2_Next:
	inc r8d
	cmp r8d, DimMatrix					;i<DimMatrix
	jl  shiftNumbersLP2_Rows

	cmp ecx, 0							;shifts>0
	je  shiftNumbersLP2_End
	mov DWORD[moved], 1					;moved=1;
	mov rax, rcx						;retornem shifts;

shiftNumbersLP2_End:  
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx         
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;  
; Aparellar nombres iguals des l'esquerra de la matriu rebuda com a
; paràmetre (edi) i acumular els punts sumant el punts de les parelles 
; que s'hagin fet.
; Recórrer la matriu per files d'esquerra a dreta i de dalt a baix. 
; Quan es trobi una parella, dos caselles consecutives amb el mateix 
; nombre, ajuntem la parella posant la suma dels nombres de la 
; parella a la casella de l'esquerra i un 0 a la casella de la dreta i 
; acumularem aquesta suma (punts que es guanyen).
; Si una fila de la matriu és: [8,4,4,2] i moved = 0, quedarà [8,8,0,2], 
; punts = (4+4)= 8 i moved = 1.
; Si al final s'ha ajuntat alguna parella (punts>0), posarem la variable 
; (moved) a 1 per indicar que s'ha mogut algun nombre 
; Retornarem els punts obtinguts de fer les parelles (no sumar-los a la 
; variable (score).
; Per a accedir a les matrius des d'assemblador cal calcular l'índex 
; a partir de la fila i la columna cridant la subrutina calcIndexP1. 
; m[row][col], en C, és equivalent a WORD[m+eax], en assemblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és [m+12].
; No s'ha de mostrar la matriu.
;
; Variables utilitzades:	
; moved : Per a indicar si s'han fet canvis a la matriu.
;
; Paràmetres d'entrada : 
; rdi(edi): Adreça de la matriu que volem fer les parelles.
;
; Paràmetres de sortida: 
; rax(eax) : Punts obtinguts de fer les parelles.
;;;;;  
addPairsLP2:
	push rbp
	mov  rbp, rsp

	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r8
	push r9
	push r10
	
	mov edx , edi 					;Adreça de la matriu
	mov r10d, 0 					;p = 0
	
	mov r8d, 0						;i = r8d
	addPairsLP2_Rows:
	mov r9d , 0						;j = r9d
		addPairsLP2_Cols:
		mov edi, r8d
		mov esi, r9d
		call calcIndexP2
		mov ecx, eax				;índex de [i][j]
		mov bx, WORD[edx+ecx]			
		cmp bx, 0					;mPairs[i][j]!=0
		je  addPairsLP2_EndIf
			inc esi
			call calcIndexP2
			cmp bx, WORD[edx+eax]		;mPairs[i][j]==mPairs[i][j+1]
			jne addPairsLP2_EndIf
				shl bx,1			;mPairs[i][j]*2
				mov WORD[edx+ecx], bx	;mPairs[i][j]  = mPairs[i][j]*2
				mov WORD[edx+eax], 0;mPairs[i][j+1]= 0
				add r10w, bx		;p = p + mPairs[i][j]
				inc r9d				;j++
		addPairsLP2_EndIf:
		inc r9d
		cmp r9d, DimMatrix-1 		;j<DimMatrix-1
		jl  addPairsLP2_Cols
	addPairsLP2_Next:
	inc r8d
	cmp r8d, DimMatrix				;i<DimMatrix
	jl  addPairsLP2_Rows

	cmp r10d, 0						;p > 0
	je  addPairsLP2_End	
	mov dword[moved], 1				;moved=1;

	addPairsLP2_End:
	mov eax, r10d					;return p;
	
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx         
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla. Guardar la tecla llegida en el registre al.
; Segons la tecla llegida cridarem a les funcions corresponents.
;    ['i' (amunt),'j'(esquerra),'k' (avall) o 'l'(dreta)] 
; Desplaçar els números i fer les parelles segons la direcció triada.
; Segons la tecla premuda, rotar la matriu cridant (rotateMatrixRP2) i 
; (copyMatrixP2) per copiar la matriu rotada (mRotated) sobre la matriu 
; (m) per a poder fer els desplaçaments dels nombres cap a l'esquerra 
; (shiftNumbersLP2),  fer les parelles cap a l'esquerra (addPairsLP2) i 
; actualitzar el marcador del punts (score) amb el valor retornat, 
; tornar a desplaçar els nombres cap a l'esquerra (shiftNumbersLP2) 
; amb les parelles fetes, després seguir rotant cridant (rotateMatrixRP2) 
; i (copyMatrixP2) fins deixar la matriu en la posició inicial. 
; Per a la tecla 'j' (esquerra) no cal fer rotacions, per a la resta 
; s'han de fer 4 rotacions.
;    'u'                 Recupera la jugada anterior (mUndu, scoreUndu)
;                        cridant a la subrutina (copyStatusP2)
;    '<ESC>' (ASCII 27)  posar (state = 0) per a sortir del joc.
; Si no és cap d'aquestes tecles no fer res.
; Els canvis produïts per aquestes subrutines no s'han de mostrar a la 
; pantalla, per tant, caldrà actualitzar després el tauler cridant la 
; subrutina UpdateBoardP2.
;
; Variables utilitzades:
; m		     : Adreça de la matriu m
; mRotated   : Dirección de la matriz mRotated
; score      : Indica els punts que tenim associats a la matriu m.
; mUndo   	 : Adreça de la matriu mUndo
; scoreUndo  : Indica els punts associats a la matriu mUndo.
; state   	 : Indica l'estat del joc. 0:sortir, 1:jugar, 3:guanya, 4:perd
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;  
readKeyP2:
		push rbp
		mov  rbp, rsp

		push rax 
		push rdx
		push rsi
		push rdi
		
		mov  edi, m		; Adreça de la matriu m al registre edi
		mov  esi, mRotated
		mov  edx, DWORD[score]
		
		call getchP2    ; Llegir una tecla i deixar-la al registre al.
		
	readKeyP2_i:
		cmp al, 'i'		; amunt
		jne  readKeyP2_j
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			call shiftNumbersLP2
			call addPairsLP2
			add  DWORD[score], eax
			call shiftNumbersLP2  
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			jmp  readKeyP2_End
		
	readKeyP2_j:
		cmp al, 'j'		; esquerra
		jne  readKeyP2_k
			call shiftNumbersLP2
			call addPairsLP2
			add  DWORD[score], eax
			call shiftNumbersLP2  
			jmp  readKeyP2_End
		
	readKeyP2_k:
		cmp al, 'k'		; dreta
		jne  readKeyP2_l
			
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			call shiftNumbersLP2
			call addPairsLP2
			add  DWORD[score], eax
			call shiftNumbersLP2  
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			jmp  readKeyP2_End
		
	readKeyP2_l:
		cmp al, 'l'		; avall
		jne  readKeyP2_u
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			call shiftNumbersLP2
			call addPairsLP2
			add  DWORD[score], eax
			call shiftNumbersLP2  
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);
			call rotateMatrixRP2 ;rotateMatrixRP2_C(m);
			call copyStatusP2    ;copyStatusP2_C(m,mRotated,score);		
			jmp readKeyP2_End
		
	readKeyP2_u:
		cmp al, 'u'		; Undo
		jne  readKeyP2_ESC
			mov  esi, mUndo
			mov  edx, DWORD[scoreUndo]
			call copyStatusP2
			mov  DWORD[score], eax
			jmp  readKeyP2_End
		
	readKeyP2_ESC:
		cmp al, 27		; Sortir del programa
		jne  readKeyP2_End
			mov DWORD[state], 0

	readKeyP2_End:
		pop rdi
		pop rsi
		pop rdx
		pop rax
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;  
; Verificar si s'ha arribat a 2048 o si no es pot fer algun moviment.
; Si hi ha el nombre 2048 a la matriu (m), canviar a 
; l'estat a 3 (state=3) per indicar que s'ha guanyat (WIN!).
; Si no hem guanyat, mirar si es pot fer algun moviment, 
; Si no es pot fer cap moviment canviar  l'estat a 4 (state=4) per a
; indicar que s'ha perdut (GAME OVER!!!).
; Recórrer la matriu (m) per files de dreta a esquerra i de baix a dalt
; comptant les caselles buides i mirant si hi ha el nombre 2048. 
; Si hi ha el nombre 2048 posar (state=3) i acabar.
; Si no ni ha el nombre 2048 i no hi ha caselles buides mirar si es pot
; algun aparellament en horitzontal o en vertical. Per fer-ho cal 
; copiar la matriu (m) sobre la matriu (mAux) cridant (copyStatusP2),
; fer parelles a la matriu (mAux) per mirar si es poden fer parelles 
; en horitzontal cridant (addPairsLP2) i guardar els punts obtinguts,
; rotar la matriu (mAux) cridant (rotateMatrixRP2) i a copiar la
; matriu rotada (mRotated) a la matriu (mAux) cridant (copyStatusP2),
; tornar a fer parelles a la matriu (mAux) per mirar si es poden fer 
; parelles en vertical cridant (addPairsLP2) i acumular els punts 
; obtinguts amb els punt obtinguts abans, si el punts acumulats són zero,
; vol dir que no es poden fer parelles i s'ha de posar (state=4).
; Finalment posar (moved=0), les operacions que s'hagin fet no són 
; canvis o moviments fets a la matriu (m) i no s'han de considerar.
; Per a accedir a les matrius des d'assemblador cal calcular l'índex 
; a partir de la fila i la columna cridant la subrutina calcIndexP1. 
; m[row][col], en C, és equivalent a WORD[m+eax], en assemblador, si 
; eax = ((row*DimMatrix)+(col))*2. m[1][2] és [m+12].
; No es pot modificar ni la matriu (m), ni la matriu (mUndo).
;
; Variables utilitzades:	
; m        : Adreça de la matriu que volem verificar.
; mAux     : Adreça de la matriu on copiarem les dades per fer verificacions.
; mRotated : Adreça de la matriu on es fa la rotació.
; state    : Indica l'estat del joc. 0:sortir, 1:jugar, 2:guanya, 3:explosió.
; moved    : Per a indicar si s'han fet canvis a la matriu.
;
; Paràmetres d'entrada : 
; Cap.
;
; Paràmetres de sortida: 
; Cap.
;;;;;  
checkEndP2:
	push rbp
	mov  rbp, rsp

	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r8
	push r9
 
	mov ebx, 0						    ;zeros=0;
	mov ecx, 0						    ;pairs=0;

	mov r8d, DimMatrix					;i = r8d
	checkEndP2_Rows:
		dec r8d
		mov r9d , DimMatrix				;j = r9d
		checkEndP2_Cols:
			dec r9d 
			mov edi, r8d
			mov esi, r9d
			call calcIndexP2
			cmp WORD[m+eax], 0		    ;m[i][j] == 0
			jne checkEndP2_Win
				inc ebx					;zeros++;			
				checkEndP2_Win:
				cmp WORD[m+eax], 2048   ;m[i][j] == 2048
				jne checkEndP2_Next
					mov DWORD[state], 3	;state = 3
					jmp checkEndP2_End
				
		checkEndP2_Next:	
		cmp r9d, 0			 		 ;j>=0
		jg   checkEndP2_Cols
	cmp r8d, 0				 		 ;i>=0
	jg   checkEndP2_Rows

	cmp ebx, 0						 ;zeros == 0
	jne checkEndP2_End
		mov  edi, mAux
		mov  esi, m
		mov  edx, 0
		call copyStatusP2			 ;copyStatusP2_C(mAux,m,0);
		call addPairsLP2			 ;addPairsLP2_C(mAux);
		mov  ecx, eax				 ;pairs = addPairsLP2_C(mAux)
		call rotateMatrixRP2		 ;rotateMatrixRP2_C(mAux)
		mov  edi, mAux
		mov  esi, mRotated
		mov  edx, 0
		call copyStatusP2			 ;copyStatusP2_C(mAux,mRotated,0);
		call addPairsLP2			 ;addPairsLP2_C(mAux)
		add  ecx, eax				 ;pairs = pairs + addPairsLP2_C(mAux)
		cmp  ecx, 0					 ;pairs==0
		jne  checkEndP2_End		
			mov DWORD[state], 4		 ;state = 4
		
	checkEndP2_End:
	mov DWORD[moved], 0 ;moved=0; 	 ;Perquè els canvis que es fan a mAux 
									 ;no s'ha de considerar al joc.
	
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
; Joc del 2048
; Funció principal del joc
; Permet jugar al joc del 2048 cridant totes les funcionalitats.
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
;
; Pseudo codi:
; Inicialitzar estat del joc, (state=1).
; Indicar que no s'ha fet cap moviment, (moved=0).
; Esborrar pantalla (cridar la funció clearScreen_C).
; Mostrar el tauler de joc (cridar la funció PrintBoard_C).
; Actualitza el contingut del Tauler de Joc i els punts que s'han fet
; (cridar la subrutina updateBoardP2).
; Mentre (state=1) fer
;   Copiar l'estat del joc (m i score) a (mAux  i scoreAux) (cridant la 
;   subrutina copyStatusP2).
;   Llegir una tecla (cridar la subrutina readKeyP2). Segons la tecla 
;     llegida cridarem a les funcions corresponents.
;     - ['i','j','k' o 'l'] desplaçar els números i fer les parelles 
;                           segons la direcció triada.
;     - 'u'                 Recupera la jugada anterior (mUndo i 
;                           scoreUndo) sobre (m i score) (cridant a la 
;                           subrutina copyStatusP2).
;     - '<ESC>'  (codi ASCII 27) posar (state = 0) per a sortir.   
;   Si hem mogut algun número al fer els desplaçaments o al fer les 
;   parelles (moved==1), copiar l'estat del joc que hem guardar abans
;   (mAux i scoreAux) sobre (mUndo i scoreUndo) per a poder fer l'Undo 
;   (recuperar estat anterior) (cridant la subrutina copyStatusP2), 
;   generar una nova fitxa (cridant la funció insertTileP2_C) i posar 
;   la variable moved a 0 (moved=0).
;   Mostrar el tauler de joc (cridar la funció PrintBoard_C).
;   Actualitza el contingut del Tauler de Joc i els punts que s'han fet
;   (cridar la subrutina updateBoardP2).
;   Verificar si s'ha arribat a 2048 o si no es pot fer cap moviment
;   (cridar la subrutina CheckEndP2).
; Fi mentre.
; Mostra un missatge a sota del tauler segons el valor de la variable 
; (state). (cridar la funció printMessageP2_C).
; Sortir: 
; S'acabat el joc.
;
; Variables utilitzades:
; state	   : indica l'estat del joc. 0:sortir, 1:jugar, 2:guanya, 3:perd.
; moved    : Per a indicar si s'ha fet algun canvi en alguna casella.
; m        : Adreça de la matriu que volem verificar
; mAux     : Adreça de la matriu on copiarem les dades per fer verificacions.
; mUndo    : Adreça de la matriu on copiarem la jugada anterior del joc.
; score    : marcador de punts.
; scoreAux : marcador de punts auxiliar.
; scoreUndo: marcador de punts anterior.
; 
;
; Paràmetres d'entrada : 
; Cap.
;
; Paràmetres de sortida: 
; Cap.
;;;;;  
playP2:
	push rbp
	mov  rbp, rsp
	
    push rax
	push rdx
	push rsi
	push rdi
	
	mov DWORD[state], 1   ;state = 1;  //estat per a començar a jugar	
	mov DWORD[moved], 0	  ;moved = 0;  //No s'han fet moviments
	
	call clearScreen_C
	call printBoard_C
	call updateBoardP2

	playP2_Loop:              ;while  {  //Bucle principal.
	cmp  DWORD[state], 1	  ;(state == 1)
	jne  playP2_End
		
		mov edi, mAux
		mov esi, m
		mov edx, DWORD[score]
		call copyStatusP2	  ;copyStatusP2_C(mAux,m,score);
		mov DWORD[scoreAux], eax  ;scoreAux = copyStatusP2_C(mAux,m,score)
							  ;//Per fer l'Undo si es fan moviments
		call readKeyP2		  ;readKeyP2_C();
		cmp DWORD[moved], 1   ;moved == 1 //Si s'ha fet algun moviment,
		jne playP2_Next 
			mov edi, mUndo
			mov esi, mAux
			mov edx, DWORD[scoreAux]
			call copyStatusP2 ;copyStatusP2_C(mUndo,mAux,scoreAux);guardem estat.
			mov DWORD[scoreUndo], eax ;scoreUndo = scoreAux
			call insertTileP2_C   ;insertTileP2_C(); //Afegir fitxa (2 o 4)
			mov DWORD[moved],0;moved = 0;
		playP2_Next:
		call printBoard_C	  ;printBoard_C();
		call updateBoardP2	  ;updateBoardP2_C();
		call checkEndP2		  ;checkEndP2_C();  
		call printMessageP2_C ;printMessageP2_C();//Mostra el missatge per a indicar com acaba.
		
	jmp playP2_Loop

	playP2_End:
	pop rdi
	pop rsi
	pop rdx
	pop rax  
	
	mov rsp, rbp
	pop rbp
	ret
