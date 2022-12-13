;	12/12/22
;
;	Proporciona las coordenadas del objeto a imprimir.
;	Fila superior "0", Columna izquierda "0".
;
;	Input: HL contendrá la (Posicion_actual) del Sprite.
;
;	Modifica: A

Genera_coordenadas push bc
	push hl
	ld hl,(Posicion_actual)
	ld a,l
	and $1f
	ld (Coordenada_X),a 								; Coordenada X del sprite, (0-$1f).
	call calcula_tercio
	ld b,a	
	inc b												; Tercio de pantalla+1 en B, (1,2 o 3).
	ld c,0 												; Contador de filas a "0".
	ld a,l
	and $e0 											; Ahora (A) apunta al 1er char. de la fila en la que se encuentra el objeto.
	jr z,2F
1 inc c
	sub 32
	jr nz,1B
2 inc c
	inc b
	dec b
	jr z,3F
	ld a,$e0
	djnz 1B
3 ld a,c
	dec a
	ld (Coordenada_y),a
	pop hl
	pop bc
	ret