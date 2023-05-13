; 13/05/23

Indice_de_niveles

	defw Nivel_1
	defw Nivel_2
	defw Nivel_3
	defw Nivel_4
	defw Nivel_5

;	...
;	...
;	+ Niveles ...

	defw 0
	defw 0

Nivel_1 db 1,1,1,1,1 							; Tipo de entidad que vamos a introducir en las 5 cajas de DRAW.			

Nivel_2 db 2,1,1,1,1

Nivel_3 db 3,1,1,1,1

Nivel_4 db 4,1,1,1,1

Nivel_5 db 5,1,1,1,1


;---------------------------------------------------------------------------------------------------------------
;
;   13/5/23

;   Destruye HL y DE

Inicia_punteros_de_nivel_y_entidades ld hl,Indice_de_niveles
    ld (Puntero_indice_NIVELES),hl
    call Extrae_address   
    ld (Datos_de_nivel),hl
	ld hl,Indice_de_entidades
	ld (Puntero_indice_ENTIDADES),hl
    call Extrae_address   
    ld (Datos_de_entidad),hl	
	ret

;---------------------------------------------------------------------------------------------------------------
;
;   13/5/23
;
;	Destruye A,BC,HL,DE

Prepara_cajas

	ld a,(Nivel)
	call PreparaBC

	ld hl,Indice_de_niveles
	call SBC_HL_con_BC_y_Extrae
	ld (Datos_de_nivel),hl						; HL está en los datos del nivel correspondiente.

	ld b,5										; B actuará como contador de cajas.

	ld a,(hl)									; A contiene el TIPO de ENTIDAD que almacenaremos en la 1ª caja.
	call PreparaBC								

	ld hl,Indice_de_entidades
	call SBC_HL_con_BC_y_Extrae
    ld (Datos_de_entidad),hl	

	call Datos_de_entidad_a_caja

	ret

PreparaBC sla a										
	sub 2										; [(Nivel)*2]-2.
	ld c,a
	ld b,0 										; [(Nivel)*2]-2 en BC.
	ret

SBC_HL_con_BC_y_Extrae and a
	adc hl,bc
	call Extrae_address   
	ret

Datos_de_entidad_a_caja 	

;		; En este punto, HL apunta a los DATOS de la entidad que tenemos que volcar Entidad_
;		; _ la 1ª caja.

	push bc										; Preservo B como contador de cajas.
	push hl										; Preservo HL como (Datos_de_entidad).

	ld hl,Indice_de_cajas
	call Extrae_address   
	ld (Puntero_store_caja),hl
	inc de
	inc de	
	ex de,hl
	ld (Indice_restore_caja),hl 				; Indice_de_cajas +2.
	
	pop hl

	ld de,(Puntero_store_caja) 					; Datos de la entidad en HL, 1er byte de la caja en DE.

	ld b,2
1 ld a,(hl)
	inc hl
	ld (de),a
	inc de
	djnz 1B										; Hemos trasbasado:  (Filas) / (Columns).

	ex de,hl
	ld bc,7
	and a
	adc hl,bc
	ex de,hl									; HL apunta al dato (Attr) de la entidad y DE apunta al mismo_
; 												; _ dato en la caja.
;	jr $

	pop bc
	ret