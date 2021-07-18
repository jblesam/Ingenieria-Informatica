section .data               
DimMatrix    equ 9		;Constants que també estan definides en C.
SizeMatrix   equ 81
RowScreenIni equ 1
ColScreenIni equ 5	

section .text            
                         
;Subrutines que es criden des de C.
global posCurScreenP2, updateBoardP2, moveCursorP2, mineMarkerP2, searchMinesP2, playP2, 

;Variables definides en C.
extern row, col, mines, numMines, marks, state
;Funcions que es criden des de assemblador
extern clearScreen_C, printBoard_C, gotoxy_C, getch_C, printch_C, printMessageP2_C,  	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Situar el cursor en una fila i una columna de la pantalla
; en funció de la fila i columna indicats pels paràmetres esi i edi
; cridant a la funció gotoxy_C.
;
; Variables utilitzades:
; Cap
; 
; Paràmetres d'entrada : 
; edi: Fila
; esi: Columna
;    
; Paràmetres de sortida: 
; Cap
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
   ; el primer paràmetre (rowCur) s'ha de passar pel registre rdi(edi), i
   ; el segon  paràmetre (colCur) s'ha de passar pel registre rsi(esi)		
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
; Mostrar un caràcter, rebut com a paràmetre al registre dil,
; en la pantalla en la posició on està el cursor,  
; cridant a la funció printch_C.
; 
; Variables utilitzades: 
; Cap
; 
; Paràmetres d'entrada : 
; rdi (dil): Caràcter que volem mostrar a la pantalla
;    
; Paràmetres de sortida: 
; Cap
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
; Llegir un caràcter de teclat   
; cridant a la funció getch_C
; i deixar-lo al registre al
; 
; Variables utilitzades: 
; Cap
; 
; Paràmetres d'entrada : 
; Cap
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
   ; retorna sobre el registre rax(al)  el caràcter llegit
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
; Posiciona el cursor a la pantalla dins el tauler, en funció de la 
; fila i columna indicats pels registres edi i esi rebuts com a 
; paràmetre i les constants RowScreenIni i ColScreenIni.
; Per a calcular la posició del cursor a pantalla (indicada pels 
; registres edi i esi) utilitzar aquestes fórmules:
; utilitzar aquestes fórmules:
; edi = (row*2) + rowScreenIni + 3;
; esi = (col*4) + colScreenIni + 4;
; Per a posicionar el cursor cridar a la subrutina gotoxyP2 implementant 
; correctament el pas de paràmetres.
;
; Variables utilitzades:	
; Cap
;
; Paràmetres d'entrada : 
; rdi(edi): Fila per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; rsi(esi): Columna per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
;
; Paràmetres de sortida: 
; Cap
;;;;;  
posCurScreenP2:
		push rbp
		mov  rbp, rsp
		  
		push rdi           
		push rsi
		
		shl edi, 1			  ; (row*2)
		add edi, RowScreenIni ; (row*2)+rowScreenIni
		add edi, 3            ; (row*2)+rowScreenIni+3

		shl esi, 2			  ; (col*4)
		add esi, ColScreenIni ; (col*4)+colScreenIni
		add esi, 4            ; (col*4)+colScreenIni+4
		
		call gotoxyP2
		
	posCurScreenP2_End:
		pop rsi            
		pop rdi
				
		mov rsp, rbp
		pop rbp
		ret


;;;;;
; Converteix el valor de NumMines (entre 0 i 99) en dos caràcters ASCII. 
; S'ha de dividir el valor entre 10, el quocient representarà les desenes 
; i el residu les unitats, i després s'han de convertir a ASCII sumant 48.
; Mostra els dígits (caràcter ASCII) de les desenes a la fila 22, 
; columna 10 de la pantalla i les unitats a la fila 22, columna 12, 
; (la posició s'indica a través dels registres edi i esi).
; Per a posicionar el cursor cridar a la subrutina gotoxyP2 i per a mostrar 
; els caràcters a la subrutina printchP2 implementant correctament el pas
; de paràmetres
;
; Variables utilitzades:	
; numMines: nombre de mines que queden per posar.
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;
showMinesP2:
		push rbp
		mov  rbp, rsp
		
		push rax
		push rbx
		push rdx
		push rsi
		push rdi

		mov rax, 0
		mov eax, [numMines]
		mov edx, 0

		;calcular unitats i desenes 
		mov ebx,10
		div ebx	    ;EAX=EDX:EAX/EBX EDX=EDX:EAX mod EBX

		add al,'0'       ;convertim els valors a caràcters ASCII
		add dl,'0'

		;Posicionar el cursor i mostrar dígits
		mov edi, 22      ;RowScreenIni+DimMatrix+DimMatrix+3 = 22
		mov esi, 10      ;ColScreenIni+5 = 10
		call gotoxyP2
 
		push rdi
		mov dil, al
		call printchP2
		pop rdi
		
		add esi, 2
		call gotoxyP2   

		mov dil, dl
		call printchP2
  
	showMinesP2_End:
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
; marks i el nombre de mines que queden per marcar. 
; S'ha de recórrer tot la matriu marks, i per a cada element de la matriu
; posicionar el cursor a la pantalla i mostrar els caràcters de la matriu,
; després mostra el valor de numMines a la part inferior del tauler 
; Per a posicionar el cursor cridar a la subrutina gotoxyP2, per a mostrar 
; els caràcters a la subrutina printchP2 i per a mostrar numMines a la
; subrutina ShowMinesP2 implementant correctament el pas de paràmetres.
;
; Variables utilitzades:	
; marks : matriu 9x9 on s'indiquen les mines marcades 
;         i el nombre de mines de les caselles obertes.
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;  
updateBoardP2:
		push rbp
		mov  rbp, rsp
		
		push rbx
		push rcx
		push rdx
		push rsi
		push rdi
		
		mov edi, RowScreenIni+3    ;fila inicial del cursor
		mov esi, ColScreenIni+4    ;columna inicial del cursor

	    mov ebx, 0       ;fila (0-8)
	    mov ecx, 0       ;columna (0-8)
		mov edx, 0       ;índex per a accedir a la matriu marks. (0-80)
		                 ;índex=(fila*DimMatrix)+(columna)
			
		;Iniciem el bucle per a mostrar la matriu.
	updateBoardP2_bucle:
		
		call gotoxyP2         ;posiciona el cursor en base a edi i esi.
		
		push rdi
		mov dil, [marks+edx]  ;caràcter de la matriu que volem mostrar
		call printchP2
		pop rdi
		
		inc edx               ;incrementem l'índex per a accedir a la matriu
		add esi, 4            ;Actualitzem la columna del cursor
		inc ecx               ;Actualitzem la columna.
		cmp ecx, DimMatrix
		jl  updateBoardP2_bucle
		
		mov ecx, 0            				 ;columna inicial
		mov esi, ColScreenIni+4;columna inicial del cursor
		add edi, 2            ;Actualitzem la fila del cursor		
		inc ebx               ;Actualitzem la fila.
		cmp ebx, DimMatrix
		jl  updateBoardP2_bucle

		;Actualitzem el valor de numMines a pantalla
		call showMinesP2
		
	updateBoardP2_end:
		pop rdi
		pop rsi
		pop rdx
		pop rcx	
		pop rbx
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;		
; Actualitzar les variables row o col en funció a la tecla premuda,
; rebuda com a paràmetre al registre dil.
; (i:amunt, j:esquerra k:avall i l:dreta). 
; ( row = row +/- 1 ) ( col = col +/- 1 ) 
; No s'ha de posicionar el cursor a pantalla. 
;
; Variables utilitzades:	
; row	 : fila per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; col	 : columna per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
;
; Paràmetres d'entrada : 
; rdi(dil): Caràcter llegit de teclat
;
; Paràmetres de sortida: 
; Cap
;;;;;  
moveCursorP2:
		push rbp
		mov  rbp, rsp
		
		push rdi

		cmp dil, 'i'
		je moveCursorP2_Up
		cmp dil, 'j'
		je moveCursorP2_Left
		cmp dil, 'k'
		je moveCursorP2_Down
		cmp dil, 'l'
		je moveCursorP2_Right

	moveCursorP2_Up:
		cmp DWORD[row], 0
		jle moveCursorP2_End
		dec DWORD[row]
		jmp moveCursorP2_End
  
	moveCursorP2_Left:
		cmp DWORD[col], 0
		jle  moveCursorP2_End
		dec DWORD[col]
		jmp moveCursorP2_End

	moveCursorP2_Down:
		cmp DWORD[row], DimMatrix-1
		jge moveCursorP2_End
		inc DWORD[row]
		jmp moveCursorP2_End

	moveCursorP2_Right:
		cmp DWORD[col], DimMatrix-1
		jge moveCursorP2_End
		inc DWORD[col]
		jmp moveCursorP2_End

	moveCursorP2_End:
		pop rdi
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;  
; Calcular el valor de l'índex per a accedir a la matriu marks i mines  
; (9x9) que guardarem al registre eax a partir dels valors de les 
; variables row i col (la posició actual del cursor). 
; eax=([row]*DimMatrix)+([col]).
; L'índex es retornar sobre el registre eax.
;
; Aquesta subrutina no té una funció en C equivalent.
;
; Variables utilitzades:	
; row	  : fila per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; col	  : columna per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; rax(eax) : índex per a accedir a les matrius mines i marks.
;;;;;  
calcIndexP2:
		push rbp
		mov  rbp, rsp

		push rbx
		push rdx
    
		mov rax, 0
		mov rbx, 0
		mov rdx, 0
		mov eax, [row]
		mov ebx, DimMatrix
		mul ebx		     ;multipliquem per 9 (EDX:EAX = EAX * font)
		add eax, [col]   ;eax = ([row]*DimMatrix)+([col])
  
calcIndexP2_End:  
		pop rdx
		pop rbx
				
		mov rsp, rbp
		pop rbp
		ret


;;;;;  
; Marcar/desmarcar una mina a la posició actual del cursor, indicada 
; per les varaibles row i col, a la matriu marks.
; Si en aquella posició hi ha un espai en blanc i no s'han marcat totes 
; les mines, posarem una X i actualitzem numMines, si hi ha una 'X'
; posem un espai i actualitzem numMines, si hi ha un altre valor no 
; canviem res.
; Calcular el valor de l'índex, que es deixa al registre eax, per a 
; accedir a la matriu marks a partir dels valors de row i col 
; (la posició actual del cursor) cridant a la subrutina calcIndexP2. 
; (eax=([row]*DimMatrix)+([col]))
; No s'ha de mostrar la matriu.
;
; Variables utilitzades:	
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
mineMarkerP2:
		push rbp
		mov  rbp, rsp

		push rax
		push rsi
  
		mov rax, 0
		;calculem posició dins la matriu marks a partir de row i col.
		call calcIndexP2  ;eax=([row]*DimMatrix)+([col])
		mov esi,eax
      
		cmp BYTE[marks+esi], 'X'    ;mirem si la mina ja està marcada.
		je  mineMarkerP2_Unmark
		cmp BYTE[marks+esi], ' '    ;mirem si la mina no està marcada.
		jne mineMarkerP2_End

	mineMarkerP2_Mark:          ;marcar
		cmp DWORD[numMines], 0
		je  mineMarkerP2_End 
		mov BYTE[marks+esi], 'X'
		dec DWORD[numMines]
		jmp mineMarkerP2_End

	mineMarkerP2_Unmark:        ;desmarcar
		mov BYTE[marks+esi], ' '
		inc DWORD[numMines]  

mineMarkerP2_End:  
		pop rsi
		pop rax           
		
		mov rsp, rbp
		pop rbp
		ret
		

;;;;;  
; Obrir casella. Mirar quantes mines hi ha al voltant de la posició 
; actual del cursor a la matriu mines.
; Si a la posició actual de la matriu marks hi ha una mina marcada o 
;    la casella ja s'ha obert, no fer res,
; sinó,  Si hi ha una mina canvia l'estat a 3 (Explosió), per a sortir.
;	     sinó, comptar quantes mines hi ha al voltant de la posició 
;              actual i actualitzar la posició de la matriu marks amb 
;              el nombre de mines (guardar caràcter ASCII del valor).
; Calcular el valor de l'índex, que es deixa al registre eax, per a 
; accedir a la matriu marks a partir dels valors de row i col 
; (la posició actual del cursor) cridant a la subrutina calcIndexP2. 
; (eax=([row]*DimMatrix)+([col]))
; No s'ha de mostrar la matriu.
;
; Variables utilitzades:	
; marks   : matriu 9x9 on s'indiquen les mines marcades 
;           i el nombre de mines de les caselles obertes.
; mines   : matriu 9x9 on s'indiquen les mines que s'han de trobar.
; row	  : fila per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; col	  : columna per a accedir a les matrius mines i marks [0..(dimMatrix-1)]
; state   : Indica l'estat del joc. 0:sortir, 1:jugar, 2:guanya, 3:explosió
;
; Paràmetres d'entrada : 
; Cap
;
; Paràmetres de sortida: 
; Cap
;;;;;  
searchMinesP2:
		push rbp
		mov  rbp, rsp

		push rax
		push rsi
		push rdi
  
		mov rax, 0
		;calculem la posició dins la matriu marks a partir de row i col.
		call calcIndexP2  ;eax=([row]*DimMatrix)+([col])
		mov esi, eax
   
		mov al, '0'      ;inicialitzem a caràcter zero, per a poder-ho 
						 ;guardar com a caràcter a la matriu marks.

	searchMinesP2_Marks:
		cmp BYTE[marks+esi], ' ';Mirem si en aquella posició hi ha una mina marcada o ja s'ha obert. 
		je  searchMinesP2_Mines
		jmp searchMinesP2_End     ;Si ja l'hem marcat o s'ha obert no fem res.

	searchMinesP2_Mines:
		cmp BYTE[mines+esi], ' ';Mirem si en aquella posició hi ha una mina. 
		je searchMinesP2_UpLeft
  
		mov DWORD[state],3      ;Hem obert una mina i hem d'acabar.
		jmp searchMinesP2_End

	;mirem les 8 posicions veïnes
	searchMinesP2_UpLeft:
		cmp DWORD[row], 0
		je  searchMinesP2_LeftCenter
		cmp DWORD[col], 0
		je  searchMinesP2_UpCenter
		mov edi, esi
		sub edi, 10
		cmp BYTE[mines+edi], ' '
		je  searchMinesP2_UpCenter
		inc al

	searchMinesP2_UpCenter:
		mov edi, esi
		sub edi, 9
		cmp BYTE[mines+edi], ' '
		je  searchMinesP2_UpRight
		inc al

	searchMinesP2_UpRight:
		cmp DWORD[col], DimMatrix-1
		je  searchMinesP2_LeftCenter
		mov edi,esi
		sub edi,8
		cmp BYTE[mines+edi], ' '
		je  searchMinesP2_LeftCenter
		inc al

	searchMinesP2_LeftCenter:
		cmp DWORD[col], 0
		je  searchMinesP2_RightCenter
		mov edi, esi
		sub edi, 1
		cmp BYTE[mines+edi], ' '
		je  searchMinesP2_RightCenter
		inc al

	searchMinesP2_RightCenter:
		cmp DWORD[col], DimMatrix-1
		je  searchMinesP2_DownLeft  
		mov edi, esi
		add edi,1 
		cmp BYTE[mines+edi], ' '
		je  searchMinesP2_DownLeft
		inc al

	searchMinesP2_DownLeft:
		cmp DWORD[row], DimMatrix-1
		je  searchMinesP2_NumMines
		cmp DWORD[col], 0
		je  searchMinesP2_DownCenter  
		mov edi, esi
		add edi, 8
		cmp BYTE[mines+edi], ' '
		je  searchMinesP2_DownCenter
		inc al

	searchMinesP2_DownCenter:
		mov edi, esi
		add edi, 9
		cmp BYTE[mines+edi], ' '
		je  searchMinesP2_DownRight
		inc al

	searchMinesP2_DownRight:
		cmp DWORD[col], DimMatrix-1
		je  searchMinesP2_NumMines  
		mov edi, esi
		add edi, 10 
		cmp BYTE[mines+edi], ' '
		je  searchMinesP2_NumMines
		inc al

	searchMinesP2_NumMines:
		mov BYTE[marks+esi],al  

	searchMinesP2_End:
		pop rdi            
		pop rsi
		pop rax
  
		mov rsp, rbp
		pop rbp
		ret


;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla. Guardar la tecla llegida en el registro al.
; Segons la tecla llegida cridarem a la subrutina corresponent.
;    ['i','j','k' o 'l']      cridar a la subrutina MoveCursorP2
;    'x'                      cridar a la subrutina MineMarkerP2
;    '<espai>'(codi ASCII 32) cridar a la subrutina SearchMinesP2
;    '<ESC>'  (codi ASCII 27) posar state = 0 per a sortir.
; Si no és cap d'aquestes tecles no fer res.
; Els canvis produïts per aquestes subrutines no s'han de mostrar a la 
; pantalla, per tant, caldrà actualitzar després el tauler cridant a la 
; subrutina UpdateBoard"p i tornar a posicionar el cursor a pantalla 
; cridant a la subrutina PosCurScreenP2.
;
; Variables utilitzades:	
; state   : Indica l'estat del joc. 0:sortir, 1:jugar, 2:guanya, 3:explosió
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
		
		call getchP2   ; Llegir una tecla i deixar-la al regsitre al.
				
		cmp al, 'i'		; moure cursor amunt
		je  readKeyP2_MoveCursor
		cmp al, 'j'		; moure cursor esquerra
		je  readKeyP2_MoveCursor
		cmp al, 'k'		; moure cursor dreta
		je  readKeyP2_MoveCursor
		cmp al, 'l'		; moure cursor avall
		je  readKeyP2_MoveCursor
		cmp al, 'x'		; Marca una mina
		je  readKeyP2_MineMarker
		cmp al, ' '		; Mira mines
		je  readKeyP2_SearchMines
		cmp al, 27		; Sortir del programa
		je  readKeyP2_Exit
  		jmp readKeyP2_End  
    
	readKeyP2_MoveCursor:
	    mov  dil, al 
		call moveCursorP2
		jmp  readKeyP2_End

	readKeyP2_MineMarker:
		call mineMarkerP2
		jmp  readKeyP2_End

	readKeyP2_SearchMines:
		call searchMinesP2
		jmp  readKeyP2_End

	readKeyP2_Exit:
		mov DWORD[state], 0

	readKeyP2_End:
		pop rax
		
		mov rsp, rbp
		pop rbp
		ret


;;;;;  
; Verificar si hem marcat totes les mines (numMines=0) i hem obert 
; totes  les altres caselles (no hi ha cap posició de la matriu marks 
; que tingui un espai en blanc), si és així, canviar l'estat a 2 (Guanya).
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
checkEndP2:
		push rbp
		mov  rbp, rsp

		push rsi
		
		mov rsi, 0          ;índex per a accedir a la matriu marks
  
		cmp DWORD[numMines], 0  ;Mirem si hem marcat totes les mines.
		jg checkEndP2_End

		;Iniciem el bucle pera mirar si hi ha espais en blanc
	checkEndP2_Loop:
  
		cmp BYTE[marks+esi], ' '
		je checkEndP2_End     ;Si és un espai en blanc no hem acabat.
          
		inc esi               ;incrementem l'índex per a accedir a la matriu
		cmp esi, SizeMatrix   ;DimMatrix*DimMatrix
		jl checkEndP2_Loop

		mov DWORD[state], 2   ;si hem mirat totes les posicions i no hi ha
							  ;cap espai, vol dir que hem marcat totes
							  ;les mines i obert tota la resta de posicions.
	
	checkEndP2_End:
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
;     queden per marcar (cridar la subrutina updateBoardP2).
;   Posicionar el cursor dins el tauler (cridar la subrutina posCurScreenP2).
;   Llegir una tecla (cridar la subrutina readKeyP2). Segons la tecla 
;     llegida cridarem a la subrutina corresponent.
;     - ['i','j','k' o 'l']      (cridar a la subrutina MoveCursorP2).
;     - 'x'                      (cridar a la subrutina MineMarkerP2).
;     - '<espai>'(codi ASCII 32) (cridar a la subrutina SearchMinesP2).
;     - '<ESC>'  (codi ASCII 27) posar state = 0 per a sortir.   
;   Verificar si hem marcat totes les mines i si hem obert totes  
;     les altres caselles (crida la subrutina CheckEndP2).
; Fi mentre.
; Sortir: mostrar missatge de sortida que correspongui (cridar a la funció
;   printMessageP2_C)
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
playP2:
		push rbp
		mov  rbp, rsp
		
		mov DWORD[state], 1   ;estat per a començar a jugar
							  		
		mov DWORD[row], 4	  ;Posició inicial del cursor.
		mov DWORD[col], 4     
		
		call clearScreen_C

		call printBoard_C

	playP2_Loop:              ;bucle principal del joc
		cmp  DWORD[state], 1
		jne  playP2_PrintMessage
		
		call updateBoardP2
		
		mov  edi, [row]
		mov  esi, [col]
		call posCurScreenP2
		
		call readKeyP2
  
		call checkEndP2  
	
		jmp  playP2_Loop

	playP2_PrintMessage:
		call printMessageP2_C
    
	playP2_End:
				
		mov rsp, rbp
		pop rbp
		ret
