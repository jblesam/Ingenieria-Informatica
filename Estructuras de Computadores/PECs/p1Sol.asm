section .data               
DimMatrix    equ 9		;Constants que també estan definides en C.
SizeMatrix   equ 81
RowScreenIni equ 1
ColScreenIni equ 5	

section .text            
                         
;Subrutines que es criden des de C.
global posCurScreenP1, updateBoardP1, moveCursorP1, mineMarkerP1, playP1	 

;Variables definides en C.
extern rowCur, colCur, row, col, state 
extern charac, mines, numMines, marks, indexMat
;Funcions que es criden des de assemblador
extern clearScreen_C, printBoard_C, gotoxy_C, getch_C, printch_C, printMessageP1_C,  	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Situar el cursor en una fila i una columna de la pantalla
; en funció de la fila i columna indicats per les variables rowCur i 
; colCur cridant a la funció gotoxy_C.
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
   mov edi,[rowCur]
   mov esi,[colCur]
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
; Mostrar un caràcter, guardat a la variable charac,
; en la pantalla en la posició on està el cursor,  
; cridant a la funció printch_C.
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
   mov  dil, [charac]
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
; Llegir un caràcter de teclat   
; cridant a la funció getch_C
; i deixar-lo a la variable charac.
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
   mov [charac],al
 
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
; Posiciona el cursor a la pantalla dins el tauler, en funció de les 
; variables row i col i les constants RowScreenIni i ColScreenIni.
; Per a calcular la posició del cursor a pantalla (indicada per les 
; variables rowCur i colCur) utilitzar aquestes fórmules:
; rowCur = (row*2) + rowScreenIni + 3;
; colCur = (col*4) + colScreenIni + 4;
; Per a posicionar el cursor cridar a la subrutina gotoxyP1.
;
; Variables utilitzades:	
; row	 : fila per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; col	 : columna per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; rowCur : fila per a posicionar el cursor a la pantalla
; colCur : columna per a posicionar el cursor a la pantalla
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;  
posCurScreenP1:
		push rbp
		mov  rbp, rsp
		  
		push rdi           
		push rsi
		
		mov edi, [row] 
		shl edi, 1			  ; (row*2)
		add edi, RowScreenIni ; (row*2)+rowScreenIni
		add edi, 3            ; (row*2)+rowScreenIni+3

		mov esi, [col]
		shl esi, 2			  ; (col*4)
		add esi, ColScreenIni ; (col*4)+colScreenIni
		add esi, 4            ; (col*4)+colScreenIni+4
		
		mov [rowCur], edi	  ; Fila i columna on posicionem el cursor.
		mov [colCur], esi

		call gotoxyP1
	
	posCurScreenP1_End:
		pop rsi            
		pop rdi
				
		mov rsp, rbp
		pop rbp
		ret


;;;;;
; Converteix el valor de NumMines (entre 0 i 99) en dos caràcters ASCII. 
; S'ha de dividir el valor entre 10, el quocient representarà les 
; desenes i el residu les unitats, i després s'han de convertir 
; a ASCII sumant 48.
; Mostra els dígits (caràcter ASCII) de les desenes a la fila 22, 
; columna 10 de la pantalla i les unitats a la fila 22, columna 12, 
; (la posició s'indica a través de les variables rowCur i colCur).
; Per a posicionar el cursor cridar a la subrutina gotoxyP1 i per a mostrar 
; els caràcters a la subrutina printchP1.
;
; Variables utilitzades:	
; numMines: nombre de mines que queden per posar
; charac  : caràcter que volem mostrat
; rowCur  : fila per a posicionar el cursor a la pantalla
; colCur  : columna per a posicionar el cursor a la pantalla
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;
showMinesP1:
		push rbp
		mov  rbp, rsp
		
		push rax
		push rbx
		push rdx

		mov rax, 0
		mov eax, [numMines]
		mov edx, 0

		;calcular unitats i desenes 
		mov ebx,10
		div ebx	    ;EAX=EDX:EAX/EBX EDX=EDX:EAX mod EBX

		add al,'0'  ;convertim els valors a caràcters ASCII
		add dl,'0'

		;Posicionar el cursor i mostrar dígits
		mov DWORD[rowCur], 22 ;RowScreenIni+DimMatrix+DimMatrix+3 = 22
		mov DWORD[colCur], 10 ;ColScreenIni+5 = 10
		call gotoxyP1
 
		mov [charac], al
		call printchP1
		
		add DWORD[colCur], 2
		call gotoxyP1   

		mov [charac], dl
		call printchP1
   
	showMinesP1_End:
  		pop rdx
		pop rbx
		pop rax
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;
; Actualitzar el contingut del Tauler de Joc amb les dades de la matriu 
; marks i el nombre de mines que queden per marcar. 
; S'ha de recórrer tot la matriu marks, i per a cada element de la matriu
; posicionar el cursor a la pantalla i mostrar els caràcters de la matriu,
; després mostra el valor de numMines a la part inferior del tauler.
; Per a posicionar el cursor cridar a la subrutina gotoxyP1, per a mostrar 
; els caràcters a la subrutina printchP1 i per a mostrar numMines 
; a la subrutina ShowMinesP1.
;
; Variables utilitzades:	
; marks : matriu 9x9 on s'indiquen les mines marcades 
;         i el nombre de mines de les caselles obertes.
; charac: caràcter que volem mostrar
; rowCur: fila per a posicionar el cursor a la pantalla
; colCur: columna per a posicionar el cursor a la pantalla
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
		
		mov DWORD[rowCur], RowScreenIni+3    ;fila inicial del cursor
		mov DWORD[colCur], ColScreenIni+4    ;columna inicial del cursor

	    mov ebx, 0       ;fila (0-8)
	    mov ecx, 0       ;columna (0-8)
		mov edx, 0       ;índex per a accedir a la matriu marks. (0-80)
		                 ;índex=(fila*DimMatrix)+(columna)
			
		;Iniciem el bucle per a mostrar la matriu.
	updateBoardP1_bucle:
		
		call gotoxyP1          ;posiciona el cursor en base a rowCur i colCur.
		
		mov al, [marks+edx]    ;caràcter de la matriu que volem mostrar
		mov [charac], al
		
		call printchP1
		
		inc edx               ;incrementem l'índex per a accedir a la matriu
		add DWORD[colCur], 4  ;Actualitzem la columna del cursor
		inc ecx               ;Actualitzem la columna.
		cmp ecx, DimMatrix
		jl  updateBoardP1_bucle
		
		mov ecx, 0            				 ;columna inicial
		mov DWORD[colCur], ColScreenIni+4    ;columna inicial del cursor
		add DWORD[rowCur], 2  ;Actualitzem la fila del cursor		
		inc ebx               ;Actualitzem la fila.
		cmp ebx, DimMatrix
		jl  updateBoardP1_bucle

		;Actualitzem el valor de numMines a pantalla
		call showMinesP1
		
	updateBoardP1_end:
		pop rdx
		pop rcx	
		pop rbx
		pop rax
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;		
; Actualitzar les variables row o col en funció de la tecla premuda.
; que tenim a la variable charac.
; (i:amunt, j:esquerra k:avall i l:dreta). 
; ( row = row +/- 1 ) ( col = col +/- 1 ) 
; No s'ha de posicionar el cursor a pantalla. 
;
; Variables utilitzades:	
; charac : caràcter que llegim de teclat
; row	 : fila per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; col	 : columna per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;  
moveCursorP1:
		push rbp
		mov  rbp, rsp

		cmp BYTE[charac], 'i'
		je moveCursorP1_Up
		cmp BYTE[charac], 'j'
		je moveCursorP1_Left
		cmp BYTE[charac], 'k'
		je moveCursorP1_Down
		cmp BYTE[charac], 'l'
		je moveCursorP1_Right

	moveCursorP1_Up:
		cmp DWORD[row], 0
		jle moveCursorP1_End
		dec DWORD[row]
		jmp moveCursorP1_End
  
	moveCursorP1_Left:
		cmp DWORD[col], 0
		jle  moveCursorP1_End
		dec DWORD[col]
		jmp moveCursorP1_End

	moveCursorP1_Down:
		cmp DWORD[row], DimMatrix-1
		jge moveCursorP1_End
		inc DWORD[row]
		jmp moveCursorP1_End

	moveCursorP1_Right:
		cmp DWORD[col], DimMatrix-1
		jge moveCursorP1_End
		inc DWORD[col]
		jmp moveCursorP1_End

	moveCursorP1_End:
		mov rsp, rbp
		pop rbp
		ret


;;;;;  
; Calcular el valor de l'índex per a accedir a la matriu marks i mines  
; (9x9) que guardarem a la variable indexMat a partir dels valors de les 
; variables row i col (la posició actual del cursor). 
; indexMat=([row]*DimMatrix)+([col]).
;
; Aquesta subrutina no té una funció en C equivalent.
;
; Variables utilitzades:	
; row	  : fila per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; col	  : columna per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; indexMat: índex per a accedir a les matrius mines i marks.
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
		mov eax, [row]
		mov ebx, DimMatrix
		mul ebx		     ;multipliquem per 9 (EDX:EAX = EAX * font)
		add eax, [col]
		mov [indexMat], eax   ;indexMat=([row]*DimMatrix)+([col])
  
calcIndexP1_End:  
		pop rdx
		pop rbx
		pop rax
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;  
; Marcar/desmarcar una mina a la posició actual del cursor, indicada 
; per les variables row i col, a la matriu marks.
; Si en aquella posició hi ha un espai en blanc i no s'han marcat totes 
; les mines, posem una X i actualitzem numMines, si hi ha una 'X'
; posem un espai i actualitzem numMines, si hi ha un altre valor no 
; canviem res.
; Calcular el valor de l'índex, que es guarda a la varaible indexMat, 
; per a accedir  a la matriu marks a partir dels valors de row i col 
; (la posició actual del cursor) cridant a la subrutina calcIndexP1. 
; (indexMat=([row]*DimMatrix)+([col]))
; No s'ha de mostrar la matriu.
;
; Variables utilitzades:	
; indexMat : índex per a accedir a la matriu marks.
; marks    : matriu 9x9 on s'indiquen les mines marcades 
;            i el nombre de mines de les caselles obertes.
; numMines : nombre de mines que queden per posar.
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;  
mineMarkerP1:
		push rbp
		mov  rbp, rsp

		push rsi
  
		;calculem posició dins la matriu marks a partir de row i col.
		call calcIndexP1  ;indexMat=([row]*DimMatrix)+([col])
		mov esi,[indexMat]
      
		cmp BYTE[marks+esi], 'X'    ;mirem si la mina ja està marcada.
		je  mineMarkerP1_Unmark
		cmp BYTE[marks+esi], ' '    ;mirem si la mina no està marcada.
		jne mineMarkerP1_End

	mineMarkerP1_Mark:          ;marcar
		cmp DWORD[numMines], 0
		je  mineMarkerP1_End 
		mov BYTE[marks+esi], 'X'
		dec DWORD[numMines]
		jmp mineMarkerP1_End

	mineMarkerP1_Unmark:        ;desmarcar
		mov BYTE[marks+esi], ' '
		inc DWORD[numMines]  

mineMarkerP1_End:  
		pop rsi            
		
		mov rsp, rbp
		pop rbp
		ret
		

;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla. Guardar la tecla llegida a la variable charac.
; Segons la tecla llegida cridarem a la subrutina corresponent.
;    ['i','j','k' o 'l']      cridar a la subrutina MoveCursorP1
;    'x'                      cridar a la subrutina MineMarkerP1
;    '<ESC>'  (codi ASCII 27) posar state = 0 per a sortir.
; Si no és cap d'aquestes tecles no fer res.
; Els canvis produïts per aquestes subrutines no s'han de mostrar a la 
; pantalla, per tant, caldrà actualitzar després el tauler cridant la 
; subrutina UpdateBoardP1 i tornar a posicionar el cursor a la pantalla 
; cridant la subrutina PosCurScreenP1.
;
; Variables utilitzades:	
; charac  : caràcter que llegim
; state   : Indica l'estat del joc. 0:sortir, 1:jugar, 2:guanya, 3:explosió
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
		    
		call getchP1   ; Llegir una tecla i guardar-la a la variable charac.
		mov  al, [charac]
		
		cmp al, 'i'		; moure cursor amunt
		je  readKeyP1_MoveCursor
		cmp al, 'j'		; moure cursor esquerra
		je  readKeyP1_MoveCursor
		cmp al, 'k'		; moure cursor dreta
		je  readKeyP1_MoveCursor
		cmp al, 'l'		; moure cursor avall
		je  readKeyP1_MoveCursor
		cmp al, 'x'		; Marcar una mina
		je  readKeyP1_MineMarker
		cmp al, 27		; Sortir del programa
		je  readKeyP1_Exit
  		jmp readKeyP1_End  
    
	readKeyP1_MoveCursor:
		call moveCursorP1
		jmp  readKeyP1_End

	readKeyP1_MineMarker:
		call mineMarkerP1
		jmp  readKeyP1_End

	readKeyP1_Exit:
		mov DWORD[state], 0

	readKeyP1_End:
		pop rax
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;  
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Verificar si hem marcat totes les mines (numMines=0),
; si és així, canviar l'estat a 2 (Guanya).
;
; Variables utilitzades:	
; numMines: nombre de mines que queden per posar. 
; state   : Indica l'estat del joc. 0:sortir, 1:jugar, 2:guanya, 3:explosió
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;  
checkEndP1:
		push rbp
		mov  rbp, rsp

		cmp DWORD[numMines], 0  ;Mirem si hem marcat totes les mines.
		jg checkEndP1_End


		mov DWORD[state], 2   
	
	checkEndP1_End:
		pop rsi
  
		mov rsp, rbp
		pop rbp
		ret


;;;;;
; Joc del Buscamines
; Subrutina principal del joc
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Permet jugar al joc del buscamines cridant totes les funcionalitats.
;
; Pseudo codi:
; Inicialitzar estat del joc, state=1
; Inicialitzar fila i columna, posició inicial, row=4 i col=4
; Esborrar pantalla (cridar la funció clearScreen_C).
; Mostrar el tauler de joc (cridar la funció PrintBoard_C).
; Mentre (state=1) fer
;   Actualitzar el contingut del Tauler de Joc i el nombre de mines que 
;     queden per marcar (cridar la subrutina updateBoardP1).
;   Posicionar el cursor dins el tauler (cridar la subrutina posCurScreenP1).
;   Llegir una tecla (cridar la subrutina readKeyP1). Segons la tecla 
;     llegida cridarem a la subrutina corresponent.
;     - ['i','j','k' o 'l']      (cridar a la subrutina MoveCursorP1).
;     - 'x'                      (cridar a la subrutina MineMarkerP1).
;     - '<ESC>'  (codi ASCII 27) posar state = 0 per a sortir.   
;   Verificar si hem marcat totes les mines (crida a la subrutina CheckEndP1).
; Fi mentre.
; Sortir: mostrar missatge de sortida que correspongui (cridar a la funció
;   printMessageP1_C)
; S'acabat el joc.
;
; Variables utilitzades:
; state	: indica l'estat del joc. 0:sortir, 1:jugar, 2:guanya, 3:explosió
; row   : fila de pantalla on es llegeix la jugada i es mostren els encerts
; col   : columna inicial de les jugades
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
		
		mov DWORD[state], 1   ;estat per a començar a jugar
							  		
		mov DWORD[row], 4	  ;Posició inicial del cursor.
		mov DWORD[col], 4     
		
		call clearScreen_C

		call printBoard_C

	playP1_Loop:              ;bucle principal del joc
		cmp  DWORD[state], 1
		jne  playP1_PrintMessage
		
		call updateBoardP1

		call posCurScreenP1
		
		call readKeyP1
  
		call checkEndP1  
	
		jmp  playP1_Loop

	playP1_PrintMessage:
		call printMessageP1_C
    
	playP1_End:
				
		mov rsp, rbp
		pop rbp
		ret
