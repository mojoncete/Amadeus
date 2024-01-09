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

Nivel_1 db 2	                                ; Nº de entidades.
	db 1,1										; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.		
Nivel_2 db 12									; Nº de entidades.
	db 2,1,1,1,1,2								; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.			
	db 2,1,1,1,1,2
Nivel_3 db 15									; Nº de entidades.	 
	db 3,1,1,1,1 								; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.			
	db 3,1,1,1,1 
	db 3,1,1,1,1 	
Nivel_4 db 17									; Nº de entidades.
	db 4,1,1,1,1 								; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.			
	db 4,1,1,1,1
	db 4,1,1,1,1
	db 2,3
Nivel_5 db 20									; Nº de entidades. 
	db 5,1,1,1,1 								; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.			
	db 5,1,1,1,1 
	db 5,1,1,1,1 								; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.			
	db 5,1,1,1,1

;---------------------------------------------------------------------------------------------------------------
;
;   5/1/24
;
;	Sitúa (Puntero_indice_NIVELES) en el 1er Nivel del índice de niveles.
;	Carga el nº de entidades del 1er nivel en (Numero_de_entidades). 
;	Sitúa el puntero (Datos_de_nivel) en el 1er byte que indica el tipo de entidad que se va a cargar_
;	_en la caja DRAW correspondiente.
;	
;	MODIFICA: HL,DE y A. 
;	ACTUALIZA: (Puntero_indice_NIVELES), (Numero_de_entidades) y (Datos_de_nivel).

Inicializa_Punteros_de_nivel 

	ld hl,Indice_de_niveles
	ld (Puntero_indice_NIVELES),hl				 ; Situamos (Puntero_indice_NIVELES) en el 1er Nivel del índice.
	call Extrae_address   
	ld a,(hl)
	ld (Numero_de_entidades),a					 ; Fijamos el nº de entidades que tiene el nivel.
	inc hl
	ld (Datos_de_nivel),hl						 ; (Datos_de_nivel) ahora apunta a la dirección de mem. donde se encuentra el 1er dato que_ 
	ret 										 ; _ construye el nivel, (tipo de la 1ª entidad).

;---------------------------------------------------------------------------------------------------------------
;
;   5/1/24
;
;	Destruye A,BC,HL,DE

;	Esta rutina se encarga de preparar las CAJAS DE ENTIDADES con un tipo de entidad.
;	El tipo de entidad que vamos a `volcar´ en cada caja viene determinado por el valor de (Datos_de_nivel).

Prepara_cajas_de_entidades

; Preparamos los punteros de las cajas de entidades:

	ld hl,Indice_de_cajas_de_entidades
	call Extrae_address   
	call Avanza_caja_de_entidades								; Situa (Puntero_store_caja) en el 1er .db de la caja que vamos a preparar.
;																; Situa (Indice_restore_caja) en el siguiente .defw del índice de cajas de entidades.

	call Inicializa_Numero_parcial_de_entidades					; Actualiza (Numero_de_entidades) y (Numero_parcial_de_entidades).

	ld hl,(Datos_de_nivel)

; En este punto:
;
; HL está situado en los .db del Nivel que indican el `tipo´ de entidad a volcar en la caja de entidades.
; B contiene (Numero_parcial_de_entidades), (nº de cajas que vamos a rellenar).

1 push bc 										; Guardo el nº de cajas a rellenar.

	ld a,(hl)									; A contiene el TIPO de ENTIDAD que almacenaremos en la caja.
	call Calcula_salto_en_BC					; Calcula salto para situarnos en los "datos" de la entidad correcta del indice de entidades.

	ld hl,Indice_de_entidades
	call Situa_en_datos_de_entidad				; Sitúa HL en el 1er .db de la entidad que tenemos que volcar en la caja.
;												; Actualiza (Datos_de_entidad) con esa dirección.

	call Datos_de_entidad_a_caja				; Vuelca los datos de la entidad en la caja.

	ld hl,(Indice_restore_caja)					; AVANZA CAJA.
	call Extrae_address   
	call Avanza_caja_de_entidades

	ld hl,(Datos_de_nivel)
	inc hl
	ld (Datos_de_nivel),hl						; SIGUIENTE TIPO DE ENTIDAD.

	pop bc
	djnz 1B

	ret

;	------------------------------------------------------------------------------------
;
;	5/1/24
;
;	Esta pequeña sub-rutina carga BC con 0,2,4,6,8 ... en función del tipo de entidad: (1,2,3,4,...). 
;	Calcula "el salto" para situarnos en los DATOS de la ENTIDAD correcta del índice de entidades según el tipo de entidad.

Calcula_salto_en_BC sla a										
	sub 2										; ("Tipo_de_entidad")*2-2.
	ld c,a
	ld b,0 										
	ret

; ------------------------------------------------------------------
;
;	5/1/24
;
;	Sitúa HL en el 1er .db de la entidad que tenemos que volcar en la caja.
;	Actualiza (Datos_de_entidad) con esa dirección.

Situa_en_datos_de_entidad and a
	adc hl,bc
	call Extrae_address   
    ld (Datos_de_entidad),hl					
	ret

; ------------------------------------------------------------------

Avanza_caja_de_entidades ld (Puntero_store_caja),hl
	inc de
	inc de	
	ex de,hl
	ld (Indice_restore_caja),hl 				; Indice_de_cajas_de_entidades +2.
	ret

; ----------------------------------------------------------------------------------------------------------
;
;	5/1/24
;
;	Vuelca los .db significativos del tipo de entidad a la caja de entidades.

Datos_de_entidad_a_caja 	

; En este punto:
; HL apunta al 1er .db de DATOS de la entidad que tenemos que volcar en la caja DRAW.

	ld de,(Puntero_store_caja) 					; DE apunta al 1er .db de la caja de entidades vacía.

	ld bc,2
	ldir 										; Hemos volcado (Filas) y (Columns).
;												; HL, (origen), apunta ahora al .db (attr.), hay que situar DE.
	ld bc,7
	call Situa_DE 								; DE, (destino), situado ahora correctamente: (attr).

	ld bc,5
	ldir										; Hemos volcado (Attr), (Indice_Sprite_der) y (Indice_Sprite_izq).
;												; HL, (origen), apunta ahora al .db (Posicion_inicio), hay que situar DE.
	ld bc,4
	call Situa_DE 								; DE, (destino), situado ahora correctamente: (Posicion_inicio).

	ld bc,7
	ldir										; Hemos volcado (Posicion_inicio), (Cuad_objeto) y [(Vel_left) / (Vel_right) / (Vel_up) / (Vel_down)].
;												; HL, (origen), apunta ahora al .db (Puntero_indice_mov), hay que situar DE.

	ld bc,24
	call Situa_DE 								; DE, (destino), situado ahora correctamente: (Puntero_indice_mov).

	ld bc,2
	ldir 										; Hemos volcado (Puntero_indice_mov).
;												; HL, (origen), apunta ahora al .db (Frames_explosion), hay que situar DE.

	ld bc,15															
	call Situa_DE 								; DE, (destino), situado ahora correctamente: (Frames_explosion).

	ld a,(hl)
	ld (de),a 									; Vuelco (Frames_explosion).

	ret

; ---------- -------------- ----------------

Situa_DE ex de,hl
	and a
	adc hl,bc
	ex de,hl								
	ret

;---------------------------------------------------------------------------------------------------------------
;
;	5/1/24
;
;	INICIALIZA (Numero_parcial_de_entidades).
;	DETECTA cuando hemos completado el nivel, (Numero_de_entidades)="0".
;
;	Si el nº total de entidades del nivel, (Numero_de_entidades) > 7, (nº de cajas de entidades):
;
;	(Numero_parcial_de_entidades)="7".
;
;	Si el nº total de entidades del nivel, (Numero_de_entidades) < 7, (nº de cajas de entidades):
;
;	(Numero_parcial_de_entidades)=(Numero_de_entidades).
;
;	OUTPUT: B contiene (Numero_parcial_de_entidades). Nº de cajas que vamos a preparar o rellenar.
;	MODIFICA: A y B. 
;	ACTUALIZA: (Numero_parcial_de_entidades).

Inicializa_Numero_parcial_de_entidades 

;	Si (Numero_de_entidades)="0", hemos superado el nivel actual.

	ld a,(Numero_de_entidades)
	and a

; !!!!!!!!!!! NIVEL SUPERADOOOOOOOOOOOOOO !!!!!!!!!!!!!
;	jr z,$
; !!!!!!!!!!! NIVEL SUPERADOOOOOOOOOOOOOO !!!!!!!!!!!!!

	jr nz,3F

; ---------- ---------- ----------

;! RESET para pruebas. Omitir esta línea en modo normal.
;! REINICIA EL NIVEL !!!!!!!!!!!!!!!!!!!!!!!!!!

	call Inicializa_Punteros_de_nivel					 ; Inicializa. 1er NIVEL. 

; ---------- ---------- ----------

3 ld a,(Numero_de_entidades)							 ; Nº TOTAL de las entidades del NIVEL.
	cp 7												 ; "7" es el nº total de cajas de entidades de las que disponemos.
	jr c,1F

; El nº de entidades es superior al que cabe en las cajas DRAW.
; Actualizamos variables.

	ld a,7
	ld (Numero_parcial_de_entidades),a
	ld b,a
	jr 2F

; El nº total de entidades no llena las 7 cajas de entidades. (Numero_parcial_de_entidades)=(Numero_de_entidades)
; (Numero_de_entidades)="0".

1 ld (Numero_parcial_de_entidades),a
	ld b,a
2 ret