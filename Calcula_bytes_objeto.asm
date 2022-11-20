; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; 
;	Calcula_bytes_objeto .......... (Subrutina de [Inicializacion]).
;
;	En función del valor de BC, (Filas/Columns) de una entidad, la rutina entrga dos cantidades:
;
;	[(Filas)*(Columns)]*8 en BC´.
;	[(Filas)*(Columns)] en DE´.
;
;   INPUT: FILAS x COLUMNAS en BC, Ejemp.: 2x2, 2x3, 3x3, etc.
;
;   DESTRUYE !!!!! AF, BC´y DE´.

Calcula_bytes_objeto push bc   								        ; Guardo Filas/Columnas en la pila.
	dec c 															; Filas-1 en C.
	ld a,b
1 add b 															; El loop dl, multiplica Filas*Columnas.
	dec c
	jr nz,1B 
	push af 														; Guardo Filas * Columnas en la pila.
	sla a
	sla a
	sla a 															; Ahora tengo en A: (Filas*Columnas)*8
	exx 
	ld c,a 															; Finalmente: 
	pop af
	ld e,a 															; (Filas*Columnas)*8 en BC.
	xor a
	ld b,a 															; Filas*Columnas en DE.
	ld d,b
	exx
	pop bc
	ret