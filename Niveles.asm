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

Nivel_1 db 6	                                ; Nº de entidades.
	db 1,1,1,1,1,1								; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.			
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
;   3/9/23
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
;   13/5/23
;
;	Destruye A,BC,HL,DE

;	Esta rutina se encarga de llenar las cajas de DRAW con el tipo de entidad que corresponde según el Nivel_
;	_del juego.

Prepara_cajas

; Preparamos los punteros de las cajas.

	ld hl,Indice_de_cajas
	call Extrae_address   
	call Avanza_caja

	call Admin_num_entidades					; Actualiza (Numero_de_entidades) y (Numero_parcial_de_entidades).

	ld hl,(Datos_de_nivel)

; HL está en los datos del nivel correspondiente.
; B actuará como contador de cajas.

1 push bc

	ld a,(hl)									; A contiene el TIPO de ENTIDAD que almacenaremos en la 1ª caja.
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

; En este punto, HL apunta a los DATOS de la entidad que tenemos que volcar en la caja DRAW.


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

	ld bc,18
	call Situa_DE

	ld bc,2
	ldir 										; Hemos volcado (Puntero_indice_mov).

; Nota importante: Si vamos a añadir nuevas variables a `cada entidad',(después de (Puntero_indice_mov)), hay que aumentar el valor de BC_
; _con el nº de bytes que ocupe dicha variable/s. (Frames_explosion) es la última variable general de cada entidad.

	ld bc,15									; *****							
	call Situa_DE

	ld a,3
	ld (de),a 									; Vuelco (Frames_explosion).

	ret

Situa_DE ex de,hl
	and a
	adc hl,bc
	ex de,hl								
	ret

;---------------------------------------------------------------------------------------------------------------
;
;	21/5/23
;
;	Las entidades cargadas en las cajas DRAW, se descuentan del total de (Numero_de_entidades).
;	El contador (Numero_parcial_de_entidades) indica las entidades que hay en las cajas.
;
;	Así, un nivel se completa cuando (Numero_de_entidades)="0".
;	Cuando (Numero_parcial_de_entidades)="0" hay que cargar de nuevo las cajas y restar esta cantidad al_
;	_ total de entidades que contiene (Numero_de_entidades).
;
;	OUTPUT: B contiene la cantidad de entidades que van a ser cargadas en las cajas DRAW.
;	MODIFICA: A y B. 
;	ACTUALIZA: (Numero_de_entidades) y (Numero_parcial_de_entidades).

Admin_num_entidades 

;	Si (Numero_de_entidades)="0", hemos superado el nivel actual.

	ld a,(Numero_de_entidades)
	and a
; !!!!!!!!!!! NIVEL SUPERADOOOOOOOOOOOOOO !!!!!!!!!!!!!
;	jr z,$
; !!!!!!!!!!! NIVEL SUPERADOOOOOOOOOOOOOO !!!!!!!!!!!!!

	jr nz,3F

;! RESET para pruebas. Omitir esta línea en modo normal.

	call Inicializa_Punteros_de_nivel					 ; Inicializa. 1er NIVEL. 

3 ld a,(Numero_de_entidades)
	cp 10
	jr c,1F

; El nº de entidades es superior al que cabe en las cajas DRAW.
; Actualizamos variables.

	ld a,10
	ld (Numero_parcial_de_entidades),a
	ld b,a
	jr 2F

; El nº total de entidades no llena las 10 cajas DRAW. (Numero_parcial_de_entidades)=(Numero_de_entidades)
; (Numero_de_entidades)="0".

1 ld (Numero_parcial_de_entidades),a
	ld b,a
2 ret