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

Nivel_1 db 1,2,3,4,5 							; Tipo de entidad que vamos a introducir en las 5 cajas de DRAW.			

Nivel_2 db 2,1,1,1,1

Nivel_3 db 3,1,1,1,1

Nivel_4 db 4,1,1,1,1

Nivel_5 db 5,1,1,1,1

;---------------------------------------------------------------------------------------------------------------
;
;   13/5/23
;
;	Destruye A,BC,HL,DE

;	Esta rutina se encarga de llenar las cajas de DRAW con el tipo de entidad que corresponde según el Nivel_1
;	_del juego.

Prepara_cajas

; Preparamos los punteros de las cajas.

	ld hl,Indice_de_cajas
	call Extrae_address   
	call Avanza_caja

	ld a,(Nivel)
	call PreparaBC

	ld hl,Indice_de_niveles
	call SBC_HL_con_BC_y_Extrae
	ld (Datos_de_nivel),hl						; HL está en los datos del nivel correspondiente.

	ld b,5										; B actuará como contador de cajas.
1	push bc

	ld a,(hl)										; A contiene el TIPO de ENTIDAD que almacenaremos en la 1ª caja.
	call PreparaBC								

	ld hl,Indice_de_entidades
	call SBC_HL_con_BC_y_Extrae
    ld (Datos_de_entidad),hl					; Nos hemos situado en el tipo de entidad adecuado.

	call Datos_de_entidad_a_caja

	ld hl,(Indice_restore_caja)
	call Extrae_address   
	call Avanza_caja

	ld hl,(Datos_de_nivel)
	inc hl
	ld (Datos_de_nivel),hl						; Pasamos al dato que nos dice que tipo de entidad va en la siguiente caja.

	pop bc
	djnz 1B
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

Avanza_caja	ld (Puntero_store_caja),hl
	inc de
	inc de	
	ex de,hl
	ld (Indice_restore_caja),hl 				; Indice_de_cajas +2.
	ret

Datos_de_entidad_a_caja 	

;		; En este punto, HL apunta a los DATOS de la entidad que tenemos que volcar Entidad_
;		; _ la 1ª caja.

	ld de,(Puntero_store_caja) 					; Datos de la entidad en HL, 1er byte de la caja en DE.

	ld bc,2
	ldir 										; Hemos volcado (Filas) y (Columns).

	ld bc,7
	call Situa_DE

	ld bc,5
	ldir										; Hemos volcado (Attr), (Indice_Sprite_der) y (Indice_Sprite_izq).

	ld bc,4
	call Situa_DE

	ld bc,7
	ldir										; Hemos volcado (Posicion_inicio), (Cuad_objeto) y [(Vel_left) / (Vel_right) / (Vel_up) / (Vel_down)].

	ld bc,24
	call Situa_DE

	ld bc,2
	ldir 										; Hemos volcado (Puntero_indice_mov).

	ret

Situa_DE ex de,hl
	and a
	adc hl,bc
	ex de,hl								
	ret

;---------------------------------------------------------------------------------------------------------------