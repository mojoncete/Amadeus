
Genera_coordenadas push af
	push bc
	push de
	push hl

	ld hl,(Posicion_actual)
	call calcula_tercio
	ld b,a 												; Tercio de pantalla en B, (0,1 o 2).
	ld c,0 												; Contador de líneas a "0".
	ld a,l
	and $1f
	ld (Coordenada_X),a 								; Coordenada X del sprite, (0-$1f).
	ld a,l
	and $e0 											; Ahora (A) apunta al 1er char. de la fila en la que se encuentra el objeto.
	ld d,a
	ld a,c 												; Inicializo (A). Va a actuar como comparador, se inicia en "0" y se incrementa en $20 unidades hasta coincidir_
1 cp d 													; Comparación. 
	jr z,2F
	add 32
	inc c
	jr 1B
2 ld a,b 												; Tercio de pantalla en el que nos encontramos en (B).
	and a
	jr z,4F
	cp 2
	jr nz,3F
	ld b,16
	jr 4F
3 ld b,8
4 ld a,b
	inc a
	add c
	dec a
	ld (Coordenada_y),a 								; Coordenada Y del sprite, (0-$17).

	pop hl
	pop de
	pop bc
	pop af

	ret