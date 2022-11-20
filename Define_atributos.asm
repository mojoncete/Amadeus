; ********** **********
; 
;   5/11/22
;
;   Define los atributos de un area de pantalla de X(Filas) por Y(Columnas).
;   
;   INPUTS: HL contendrá la dirección de mem. de pantalla del 1er byte del objeto, (arriba-izquierda).
;           C contendrá el nº de (Columnas) que vamos a imprimir del objeto.
;           HL´ contendrán: Nº de (Filas) del objeto. / (attr) del objeto.
;           
;   NO DESTROYERSSSS !!!!!

Define_atributos push hl
	push bc
	push de

	call Calcula_direccion_atributos

    exx
    push hl
    exx
    pop de

    ld b,d
    ld a,e 									; (Attr) en A.

4 push bc 									; FBPPPIII (Flash, Brillo, Papel, Tinta).

 	push hl 								; Guardo dirección de attr.

2 ld (hl),a
	dec c 									; Decremento (Columnas).
	jr z,1F
	inc hl
	jr 2B

1 pop hl 									; Recuperamos la dirección de attr. inicial, (arriba-izq).	
	pop bc									; Recuperamos (Filas)/(Columnas) en BC.

	dec b									; Decremento (Filas).
	jr z,3F                                 ; Si no quedan más (Filas), salimos. (JR 16F).

	ld de,32
	and a
	adc hl,de
	jr 4B									; HL situado en la siguiente (Fila) de mem. de attr.
	
3 pop de									; No quedan más Filas, Restauramos registros y RET!!!	
	pop bc
	pop hl

	ret
