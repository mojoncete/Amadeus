;---------------------------------------------------------------------------------------------------------------
;
;   8/3/24
;
;	Carga el nº de entidades del nivel en (Numero_de_entidades). 
;	Fija los perfiles de velocidad según el Nivel de dificultad.
;	Sitúa el puntero (Datos_de_nivel) en la dirección de memoria donde se encuentra el .db que define el (Tipo)_
;	_ de la 1ª entidad del Nivel.
;
;	Sitúa (Puntero_indice_mov) en la coreografía correcta.

;	MODIFICA: HL,DE y A. 
;	ACTUALIZA: (Puntero_indice_NIVELES), (Numero_de_entidades) y (Datos_de_nivel).

Inicializa_Nivel 

	ld hl,(Puntero_indice_NIVELES)
	call Extrae_address   
	ld a,(hl)
	ld (Numero_de_entidades),a					 ; Fijamos el nº de entidades que tiene el nivel.
	inc hl
	call Fija_velocidades					     ; Perfiles_de_velocidad según Nivel.
	ld (Datos_de_nivel),hl						 ; (Datos_de_nivel) ahora apunta a la dirección de mem. donde se encuentra el .db que indica el (Tipo) de la 1ª entidad del Nivel.
	call Inicializa_Puntero_indice_mov			 ; Inicializa (Puntero_indice_mov) según el (Tipo) de Entidad. Nos situamos en la coreografía correcta.
												 
	call Inicializa_Puntero_de_almacen_de_mov_masticados	; Selecciona el almacén adecuado de mov_masticados según el (Tipo) de entidad. 
	ret 										 

; ----------------------

Fija_velocidades ld de,Perfiles_de_velocidad
	ld bc,4
	ldir
	ret

Inicializa_Puntero_indice_mov ld a,(hl)     	 ; Cargamos A con el (Tipo) de la 1ª entidad del Nivel.       
    call Calcula_salto_en_BC
    ld hl,Indice_de_mov_segun_tipo_de_entidad
    and a
    adc hl,bc
    call Extrae_address
    ld (Puntero_indice_mov),hl
    ret

Inicializa_Puntero_de_almacen_de_mov_masticados ld a,(Tipo)
	call Calcula_salto_en_BC
	ld hl,Almacen_de_movimientos_masticados_Entidad_1
    and a
    adc hl,bc
    call Extrae_address
	ld (Puntero_de_almacen_de_mov_masticados),hl
	ret

;---------------------------------------------------------------------------------------------------------------
;
;   5/1/24
;
;	Destruye A,BC,HL,DE

;	Esta rutina se encarga de preparar las CAJAS DE ENTIDADES.
;	El tipo de entidad que vamos a `volcar´ en cada caja viene determinado por el valor de (Datos_de_nivel).

Inicia_Entidades

; Preparamos los punteros de las cajas de entidades:

	call Inicia_punteros_de_cajas								; Situa (Puntero_store_caja) en el 1er .db de la 1ª caja del índice de entidades.
;																; Situa (Puntero_restore_caja) en el 1er .db de la 2ª caja del índice de cajas de entidades.
	call Inicializa_Numero_parcial_de_entidades					; Actualiza (Numero_de_entidades) y (Numero_parcial_de_entidades).

	ld hl,(Datos_de_nivel)										; Tipo de la 1ª entidad del Nivel.

2 ld (Datos_de_nivel),hl 										; Actualizamos. Ahora nos encontramos en la siguiente entidad del Nivel.

	call Activa_FLAG_Tipo_de_entidad							; La rutina identifica el (Tipo) de entidad que vamos a iniciar.					

	ld hl,(Datos_de_nivel)

; En este punto:
;
; HL está situado en los .db del Nivel que indican el `tipo´ de entidad a volcar en la caja de entidades.
; B contiene (Numero_parcial_de_entidades), (nº de cajas que vamos a rellenar).

1 push bc 														; Guardo el nº de cajas a rellenar.

	ld a,(hl)
	call Definicion_segun_tipo 									; Nos situamos en el 1er .db de datos de la definición de este tipo de entidad.

	call Definicion_de_entidad_a_bandeja_DRAW					; Vuelca los datos de la definición en DRAW.

;	Este (Tipo) de entidad ya dispone de movimientos masticados ???

	call Busca_mov_masticados_segun_tipo

	and a
	jr z,3F														; A="1" Indica que los mov_masticados de este (Tipo) de entidad ya están generados.

; 	Este (Tipo) de entidad DISPONE DE MOV_MASTICADOS.

;	Actualizamos el (Contador_de_mov_masticados) de esta entidad con el (Contador_general_de_mov_masticados)_
;	_ de este tipo de entidad.

	call Situa_en_contador_general_de_mov_masticados 									
	call Transfiere_datos_de_contadores

	jr 4F

3 call Construye_movimientos_masticados_entidad

; Tenemos todos los movimientos masticados de este tipo de entidad generados y guardados en su correspondiente almacén.
; (Puntero_de_almacen_de_mov_masticados) de esta entidad está situado al principio del almacen.
; (Contador_de_mov_masticados) de esta entidad contiene: el nº total de mov. masticados de este tipo de entidad.
; Contador_general_de_mov_masticados de este tipo de entidad actualizado.
; Lo tenemos todo preparado para cargar los registros con el mov. masticado y hacer la correspondiente foto.

	call Activa_FLAG_mov_masticados_completos					; Activa el FLAG que indica que este (Tipo) de entidad tiene todos sus_
;																; _ Mov_masticados ya generados.
4 call Guarda_foto_de_mov_masticado

; Antes de guardar los parámetros de esta entidad en su correspondiente caja hay que actualizar coordenadas.

	ld hl,(Puntero_de_impresion)
	call Genera_coordenadas
	call Parametros_de_bandeja_DRAW_a_caja	 					; Caja de entidades completa.
	call Limpiamos_bandeja_DRAW
	call Incrementa_punteros_de_cajas

; Inicializa los FLAGS que indican el (Tipo) de entidad que vamos a iniciar, pues pasamos a iniciar la siguiente_
; _ entidad del Nivel.

	ld a,(Ctrl_4)
	and $f0
	ld (Ctrl_4),a 												; Mantenemos FLAGS que indican MOV_MASTICADOS.

; Siguiente entidad del Nivel.

	ld hl,(Datos_de_nivel)										; Nos situamos en el .db que define el (Tipo) de la siguiente_
	inc hl 														; _ entidad del Nivel.

	pop bc 														; Recuperamos (Numero_parcial_de_entidades), (nº de cajas que vamos a rellenar)

	djnz 2B

	ret

; ---------------------------------------------------------------------
;
;	10/02/24
;
;	Nos situamos en el 1er .db de datos de la definición de este tipo de entidad.
;
;	INPUT: A contiene el TIPO de ENTIDAD que almacenaremos en la caja. 

Definicion_segun_tipo 											

	call Calcula_salto_en_BC									; Calcula el salto para situarnos en la definición de entidad correcta de indice de [Indice_de_definiciones_de_entidades].
	ld hl,Indice_de_definiciones_de_entidades
	call Situa_en_datos_de_definicion							; Sitúa HL en el 1er .db de la definición de entidad tipo que tenemos que volcar en DRAW.
	ret

; ---------------------------------------------------------------------
;
;	30/01/24


Store_Restore_cajas	

;	Generamos las coordenadas de la entidad que hemos iniciado o desplazado.

	ld hl,(Puntero_de_impresion)
	call Genera_coordenadas

	call Parametros_de_bandeja_DRAW_a_caja	 					; Caja de entidades completa.
	call Limpiamos_bandeja_DRAW

; 	Entidad_sospechosa. 20/4/23

;	ld a,(Impacto)
;	and a
;	jr z,1F

;	ld hl,(Puntero_store_caja) 							; Si la rutina [Compara_coordenadas_X] detecta que hay_
;	ld bc,25                          					; _ una entidad en zona de Amadeus, guardaremos la direccíon_
;	and a 												; _ donde se encuentra su .db (Impacto) para poder ponerlo a_
;	adc hl,bc 											; _ "0" más adelante.
;	ld (Entidad_sospechosa_de_colision),hl


;1 ld hl,(Puntero_restore_caja)
;	ld a,(hl)
;	and a
;	push af
;	jr z,2F

;	di
;	ld de,Bandeja_DRAW
;	ld bc,42
;	ldir
;	ei

2 call Incrementa_punteros_de_cajas
	ret


; ---------------------------------------------------------------------
;
;	29/01/24

Guarda_foto_de_mov_masticado 

	call Cargamos_registros_con_mov_masticado
	call Genera_datos_de_impresion
;																; La rutina [Genera_datos_de_impresion] habilita las interrupciones antes del RET. 
;																; DI nos asegura que no vamos a ejecutar FRAME hasta que no tengamos todas las entidades iniciadas.
;																; La rutina [Genera_datos_de_impresion] activa las interrupciones antes del RET.
; Actualizamos (Contador_de_mov_masticados) tras la foto.	

	call Decrementa_Contador_de_mov_masticados
	ret

; ---------------------------------------------------------------------
;
;	25/01/24

Limpiamos_bandeja_DRAW ld hl,Bandeja_DRAW
	ld b,42
	xor a

1 ld (hl),a
	inc hl 
	djnz 1B

	ret

; ---------------------------------------------------------------------
;
;	22/01/24

Decrementa_Contador_de_mov_masticados ld hl,(Contador_de_mov_masticados)
	dec hl

	inc h
	dec h

	call m,Reinicia_entidad_maliciosa

;	jr nz,1F

;	inc l
;	dec l

;	di
;	jr z,$
;	ei

1 ld (Contador_de_mov_masticados),hl
	ret

; ---------------------------------------------------------------------
;
;	10/2/24

Reinicia_entidad_maliciosa 

;	En 1er lugar actualizamos el (Contador_de_mov_masticados).

	call Situa_en_contador_general_de_mov_masticados 									
	call Transfiere_datos_de_contadores

; 	En 2º lugar hay que inicializar el (Puntero_de_almacen_de_mov_masticados).

	ld a,(Tipo)
	call Definicion_segun_tipo

	push hl
	pop ix

	ld l,(ix+11)
	ld h,(ix+12)

	ld (Puntero_de_almacen_de_mov_masticados),hl

;	Recolocamos el puntero (Scanlines_album_SP) del álbum de fotos para colocamos justo después del borrado.
;	Queremos pintar la entidad en su posición de inicio.

	ld hl,(Scanlines_album_SP)
	ld bc,6
	and a
	sbc hl,bc
	ld (Scanlines_album_SP),hl

	call Cargamos_registros_con_mov_masticado
	call Genera_datos_de_impresion

	ld hl,(Contador_de_mov_masticados)
	dec hl

	ret




; ---------------------------------------------------------------------
;
;	22/01/24

Activa_FLAG_mov_masticados_completos ld hl,Ctrl_4
	bit 0,(hl)
	jr nz,1F
	bit 1,(hl)
	jr nz,2F
	bit 2,(hl)
	jr nz,3F
	bit 3,(hl)
	jr nz,4F
	ret

1 set 4,(hl)
	ret
2 set 5,(hl)
	ret
3 set 6,(hl)
	ret
4 set 7,(hl)
	ret

; ---------------------------------------------------------------------
;
;	23/01/24
;
;	Activamos el FLAG correspondiente a cada tipo de entidad.
;
;	bit_0 (Ctrl_4) ..... Entidad de (Tipo)_1.
;	bit_1 (Ctrl_4) ..... Entidad de (Tipo)_2.
;	bit_2 (Ctrl_4) ..... Entidad de (Tipo)_3.
;	bit_3 (Ctrl_4) ..... Entidad de (Tipo)_4.

;	INPUTS: HL contiene (Datos_de_nivel), (tipo de entidad que estamos iniciando).

Activa_FLAG_Tipo_de_entidad ld a,(hl)
	dec a
	jr nz,1F

; --- Tipo_1

	ld hl,Ctrl_4
	set 0,(hl)
	ret

1 dec a
	jr nz,2F

; --- Tipo_2

	ld hl,Ctrl_4
	set 1,(hl)
	ret

2 dec a
	jr nz,3F

; --- Tipo_3

	ld hl,Ctrl_4
	set 2,(hl)
	ret

; --- Tipo_3

3 ld hl,Ctrl_4
	set 2,(hl)
	ret

; ---------------------------------------------------------------------
;
;	22/01/24

Busca_mov_masticados_segun_tipo ld hl,Ctrl_4
	bit 0,(hl)
	jr nz,1F

	bit 1,(hl)
	jr nz,2F

	bit 2,(hl)
	jr nz,3F

	bit 3,(hl)
	jr nz,4F
	jr 6F

; Entidad_de_Tipo_1.

1 bit 4,(hl)	
	jr z,6F
	jr 5F

; Entidad_de_Tipo_2.

2 bit 5,(hl)	
	jr z,6F
	jr 5F

; Entidad_de_Tipo_3.

3 bit 6,(hl)	
	jr z,6F
	jr 5F

; Entidad_de_Tipo_4.

4 bit 7,(hl)	
	jr z,6F

; Esta entidad TIENE MOV_MASTICADOS.

5 xor a
	inc a
	ret

; Esta entidad NO TIENE MOV_MASTICADOS.

6 xor a
	ret	

;	------------------------------------------------------------------------------------
;
;	12/01/24
;
;	INPUTS:	A contiene el (Tipo) de entidad. 
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
;	19/1/24
;
;	Sitúa HL en el 1er .db de la definición de la entidad que tenemos que volcar en la bandeja DRAW.
;	Actualiza (Datos_de_entidad) con esa dirección.

Situa_en_datos_de_definicion and a
	adc hl,bc
	call Extrae_address   
    ld (Datos_de_entidad),hl					
	ret

; ------------------------------------------------------------------

; Avanza_caja_de_entidades ld (Puntero_store_caja),hl
; 	inc de
; 	inc de	
; 	ex de,hl
; 	ld (Indice_restore_caja),hl 				; Indice_de_cajas_de_entidades +2.
; 	ret

; ----------------------------------------------------------------------------------------------------------
;
;	31/1/24
;
;	Introduce una definición de entidad en la bandeja DRAW para generar los "movimientos masticados" de este tipo_
;	_ de entidad.
;
;	INPUTS: HL apunta al 1er .db de datos de la definición de la entidad.
;			
; 
;	MODIFICA: HL,DE y BC


Definicion_de_entidad_a_bandeja_DRAW 	

	ld de,Bandeja_DRAW	 						; DE apunta al 1er .db de la bandeja_DRAW, (Tipo).
	ld bc,3
	ldir 										; Hemos volcado (Tipo), (Filas) y (Columns).
;												; HL, (origen), apunta ahora al .db (attr.), hay que situar DE.
	ld de,Attr									; DE en (Attr).
	ld bc,5
	ldir										; Hemos volcado (Attr), (Indice_Sprite_der) y (Indice_Sprite_izq).
;												; HL, (origen), apunta ahora al .db (Posicion_inicio), hay que situar DE.
	ld de,Posicion_inicio 
	ld bc,3
	ldir										; Hemos volcado (Posicion_inicio) y (Cuad_objeto).
;												; HL, (origen), apunta ahora al .db (Puntero_de_almacen_de_mov_masticados), hay que situar DE.
	ld de,Puntero_de_almacen_de_mov_masticados
	ld bc,2
	ldir 										; Hemos volcado (Puntero_de_almacen_de_mov_masticados).

	ld de,Frames_explosion
	ld a,3 										; 3 FRAMES de explosión.!!!!!!!!!!!!!!
	ld (de),a 									; Vuelco (Frames_explosion).

	ret

; ----------------------------------------------------------------------------------------------------------
;
;	22/01/24
;
;	Guarda la definición que ha generado los movimientos masticados de este tipo de entidad en su correspondiente caja.
;	
;	Las cajas contienen entidades iniciadas:
;
;	Disponen de un (Puntero_de_impresión), (Coordenadas X e Y), ...
;
;	OUTPUT: HL apunta al .db (Ctrl_2) de la bandeja DRAW.
;			DE apunta al 1er .db de la siguiente caja de entidades.
; 
;	MODIFICA: HL,DE y BC

Parametros_de_bandeja_DRAW_a_caja ld hl,Bandeja_DRAW
	ld de,(Puntero_store_caja) 								
	ld a,(hl)
	ld (de),a
	inc de 													; (Tipo).

	ld hl,Coordenada_X										; HL situado en (Coordenada_X) de la bandeja DRAW.
	ld bc,2
	ldir 													; Hemos volcado (Coordenada_X) y (Coordenada_y).
;															; DE apunta ahora a (Attr) de la caja de entidades. Hemos de recolocar HL.
	inc hl
	ld a,(hl)			 									; HL, situado ahora correctamente: (attr).
	ld (de),a
	inc de 													; DE apunta a (Impacto), situamos HL.

	ld hl,Impacto
	ld a,(hl)			 									; HL, situado ahora correctamente: (Impacto).
	ld (de),a
	inc de 													; (Impacto), volcado a la caja.
;															; DE situado ahora en (Variables_de_borrado).
	inc hl
	ld bc,6
	ldir 													; Hemos volcado las (Variables_de_borrado).
; 															; DE situado ahora en (Puntero_de_impresión).
	ld bc,7
	ldir													; Hemos volcado (Puntero_de_impresion), (Puntero_de_almacen_de_mov_masticados), _
; 															; _ (Contador_de_mov_masticados) y (Ctrl_0).	
;															; HL apunta ahora a (Columnas).
	ld hl,Ctrl_2
	ld a,(hl)
	ld (de),a 												; Volcamos (Ctrl_2).
	inc de 										

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

	call Inicializa_Nivel							 	 ; Inicializa el 1er NIVEL. 

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