; ------------------------------------------------------------------------
;
;	02/04/23
;
;	Proporciona las coordenadas del objeto a imprimir.
;	Fila superior "0", Columna izquierda "0".
;
;	Input: HL contendrá la (Posicion_actual) del Sprite.
;
;	Modifica: A,BC y DE.

Genera_coordenadas push bc
	push hl

	ld hl,(Posicion_actual)
	ld a,l
	and $1f
	ld (Coordenada_X),a 								; Coordenada Y del sprite, (0-$1f). Columnas.

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

	pop hl
	pop bc

	ret

; ------------------------------------------------------------------------
;	28/03/23
;
;	Proporciona las coordenadas del disparo a imprimir.
;	Fila superior "0", Columna izquierda "0".
;
;	Input: HL contendrá la posición del proyectil en pantalla.
;	Output: DE contendrá las coordenadas del disparo:
;
;		DE="$120d"
;
;		D, (Coordenada_X), Columnas, $12
;		E, (Coordenada_y), Filas, $0d
;
;	Nota: El char. de la esquina superior izquierda de pantalla sería: $0000, Columna "0", Fila "0".

;	Modifica: A,BC y DE.


Genera_coordenadas_disparo 

; HL contendrá la dirección de pantalla del disparo. (Puntero de impresión).

	ld a,l
	and $1f
	ld d,a 												; Columnas en D. Coordenada_X.
	call calcula_tercio
	ld b,a 												; "1", "2" o "3" en función del tercio de pantalla.
	ld e,0
	ld a,l
	and $e0
	jr z,1F
	inc b
1 inc e
	sub 32
	jr nz,1B
	djnz 1B 											; Filas en E. Coordenada_y.
	ret

