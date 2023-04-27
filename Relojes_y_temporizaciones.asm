; Relojes y temporizaciones.

; ------------------------------------------------------
;
;	27/04/23
;
;	Cuando se produce un disparo de Amadeus, la variable: (Habilita_disparo_Amadeus) se_
;	_ fija a "0". Con esto, desactivamos la posibilidad de disparo de nuestra nave hasta_
;	_ que dicha variable vualva a fijarse en "1". Para que esto suceda, el contador: _
;	_ (Temporiza_disparo_Amadeus) ha de llegar a "0". 
;
;	INPUTS:			HL ..... Habilita_disparo_(Amadeus/entidad).
;					DE ..... Temporiza_disparo_(Amadeus/entidad).

Habilita_disparos 

	ld a,(hl)
	and a
	ret nz

	ex de,hl

	dec (hl)
	inc (hl)
	dec (hl)
	ret nz

	dec hl
	ld a,(hl)
	inc hl
	ld (hl),a

	ex de,hl
	ld a,1
	ld (hl),a
	ret