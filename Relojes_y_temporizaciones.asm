; Relojes y temporizaciones.

; ------------------------------------------------------
;
;	16/7/23
;
;	Cuando se produce un disparo de Amadeus, la variable: (Disparo_Amadeus) se_
;	_ fija a "0". Con esto, desactivamos la posibilidad de disparo de nuestra nave hasta_
;	_ que dicha variable vualva a fijarse en "1". Para que esto suceda, el contador: _
;	_ (Temporiza_disparo_Amadeus) ha de llegar a "0". 
;
;	INPUTS:			HL ..... Habilita_disparo_(Amadeus/entidad).
;					DE ..... Temporiza_disparo_(Amadeus/entidad).

; Disparo_entidad db 1
; Tiempo_disparo_entidad db 15							; Restaura (Temporiza_disparo_entidad). 
; Temporiza_disparo_entidad db 127						; Reloj, decreciente.

Habilita_disparos 

	ld a,(hl)
	and a
	ret nz							; Salimos de la rutina pues el disparo de entidad ya está habilitado.

	ex de,hl

	dec (hl)						; Decrementamos el contador del CLOCK que habilita el siguiente disparo_
	ret nz							; _ y salimos de la rutina si éste no ha llegado a "0".

; El CLOCK que habilita el siguiente disparo a llegado a "0". Reponemos su valor con el respaldo (CLOCK_repone_disparo_entidad_BACKUP).

	dec hl							; CLOCK_repone_disparo_entidad/Amadeus recupera su valor inicial.
	ld a,(hl)
	inc hl
	ld (hl),a

	ex de,hl						; Habilitamos disparo.
	ld a,1
	ld (hl),a
	ret