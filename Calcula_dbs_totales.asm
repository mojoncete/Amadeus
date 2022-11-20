;	16/7/22
;
;	Calcula_dbs_totales .......... (Subrutina de [Inicializacion]).
;
;	En función del valor de BC, (Filas/Columns) de un objeto, la rutina entrga dos cantidades:
;
;	INPUTS:
;
;	(Filas)/(Columns) de una entidad en BC.
;
;
;	OUTPUTS:
;
;	[(Filas)*(Columns)]*8 en BC´.
;	[(Filas)*(Columns)] en DE´.
;
;	DESTRUYE:
;
;	AF,BC´ y DE´ 	


Calcula_dbs_totales push bc		   									; Guardo Filas/Columnas en la pila.
	ld a,c															; Compruebo si (Columns) es "1", en ese caso,_
	dec a 															; _cargo el nº de filas en A y multiplico *8. (JR 3F).
	jr nz,2F
	ld a,b
	jr 3F
2 dec c 															; (Columns-1) en C.
	ld a,b
1 add b 															; El loop dl, multiplica Filas*Columnas.
	dec c
	jr nz,1B 
3 push af 															; Guardo Filas * Columnas en la pila.
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
