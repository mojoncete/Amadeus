;
;	14/06/23
;

Autorizacion

;	jr $

;	Salimos de la rutina si hemos excedido el límite de entidades x frame.

	ld a,(Limitador_de_entidades_x_frame)
	and a
	ret z

	ld a,(Autoriza_movimiento)
	and a
	jr nz,1F

; La entidad no ha estado autorizada en el FRAME anterior, damos autorización y decrementamos el limitador

5 ld hl,Autoriza_movimiento
	ld (hl),1
	ld hl,Limitador_de_entidades_x_frame
	dec (hl)

2 ret

; La entidad ha estado autorizada en el frame anterior.
; Se trata de la primera entidad ???

1 ex af,af 
	ld d,a 									; (Entidades_en_curso) totales a gestionar en este FRAME.
	ex af,af
	ld a,(Entidades_en_curso)				; Entidad que estamos gestionando en este momento.
	cp d									; Si el resultado de la comparativa es "0", estamos gestionando_
	jr nz,3F 								; _ la 1ª entidad.

; Se trata de la 1ª entidad. Decrementamos el limitador. (Queremos que la 1ª entidad se mueva a 50FPS).

4 ld hl,Limitador_de_entidades_x_frame
	dec (hl)
	jr 2B

; Esta entidad ha estado autorizada en el frame anterior y no es la 1ª.
; Salimos si hay 2 (Entidades_en_curso) o menos. 

3 ld a,(Entidades_en_curso)
	cp 2
	jr z,4B
	jr c,4B

; Esta entidad ha estado autorizada en el frame anterior y no es la 1ª. 
; Hay más de 2 (Entidades_en_curso). 

	ld a,(Autoriza_movimiento)
	and a
	jr z,5B

	jr 2B




