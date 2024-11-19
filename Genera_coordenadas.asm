; ------------------------------------------------------------------------
;
;	30/1/24
;
;	Proporciona las coordenadas del objeto a imprimir.
;	Fila superior "0", Columna izquierda "0".
;
;	Input: HL contendrá la (Posicion_actual) del Sprite.
;
;	Modifica: A,BC y DE.

Genera_coordenadas 

	ld a,l
	and $1f
	ld (Coordenada_X),a 								; Coordenada Y del sprite, (0-$1f). Columnas.

	ld a,h 												; (Coordenada_y) = "0" si estamos por debajo del 1er scanline de pantalla, (ROM).
	cp $40
	jr c,4F

	call calcula_tercio
	ld b,a 												; "0", "1" o "1" en función del tercio de pantalla.

	ld e,0
	ld a,l
	and $e0
	jr z,1F
	inc b

1 inc b
	dec b
	jr z,2F												; Si estamos en el 1er tercio de pantalla y en la línea "0".
;														; _ , salimos.
3 inc e
	sub 32
	jr nz,3B
	djnz 1B 

2 ld a,e
	ld (Coordenada_y),a
	ret

4 xor a
	ld (Coordenada_y),a
	ret
