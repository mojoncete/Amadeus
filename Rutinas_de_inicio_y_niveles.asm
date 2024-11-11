;---------------------------------------------------------------------------------------------------------------
;
;   10/11/24

;	BADSAT, (Satélite malvado). ------------------------------------------------------------------------------------------------------------------------------------	

;	Entidad_1 db 1,2,2		                     		; (Tipo) / (Filas) / (Columns).
;	db 1												; (Contador_de_vueltas).
;	defw Indice_Badsat_der								; (Indice_Sprite_der).
;	defw Indice_Badsat_izq								; (Indice_Sprite_izq).

; 	Aleatoriedad en la posición de inicio de la entidad.
; 	BadSat siempre aparecerá por la parte superior de la pantalla, $40xx. (Cuad_objeto) tendrá valor 1 o 2 dependiendo de si aparece por la mitad izquierda o derecha.

;	Pos_inicio_entidad1	defw $4000	                    ; (Posicion_inicio).
;	db 0												; (Cuad_objeto).

;	defw Almacen_de_movimientos_masticados_Entidad_1	; (Puntero_de_almacen_de_mov_masticados)


Genera_movimientos_masticados_del_nivel 

	call Inicializa_Nivel

; 	Tras ejecutar [Inicializa_Nivel] tenemos:

;	(Puntero_indice_NIVELES) apunta al nivel en el que nos encontramos, (dentro del índice).
;	(Numero_de_entidades) contiene el nº de entidades que conforman el nivel.
;	(Datos_de_nivel) apunta al .db, (tipo) de la 1ª entidad del Nivel.

1 push hl														; (Datos_de_nivel). 
	ld a,(hl)													; A contiene el (Tipo) de la entidad del Nivel.
;	push af

;	Preparamos el puntero_master para que apunte al .defw correspondiente del índice según el (Tipo) de entidad.

    call Calcula_salto_en_BC
    ld hl,Indice_de_cajas_master
    and a
    adc hl,bc
  	ld (Puntero_indice_master),hl

;	Caja Master inicializada ???

	call Extrae_address
	ld a,(hl)
	and a
;	pop af
	jr nz,Movimientos_masticados_construidos 

;	Se han construido los "Movimientos masticados" de este (Tipo) de entidad ?

	pop hl
	ld a,(hl)
	push hl

    call Calcula_salto_en_BC
    ld hl,Indice_de_almacenes_de_mov_masticados
    and a
    adc hl,bc
    call Extrae_address
	inc l
	ld a,(hl)
	and a
	jr nz,Movimientos_masticados_construidos

	pop hl														; (Datos_de_nivel). 
	ld a,(hl)
	push hl														; (Datos_de_nivel).

	call Definicion_segun_tipo
	call Definicion_de_entidad_a_bandeja_DRAW					; Vuelca los datos de la definición de entidad en DRAW.

	ld a,(Tipo)
	call Situa_Puntero_indice_mov			 	 				; Sitúa (Puntero_indice_mov) según el (Tipo) de entidad en el 1er .defw del índice de su coreogradía.

; 	Antes de empezar a generar los "movimientos masticados" de esta entidad necesitamos determinar su (Posicion_inicio).

;	ld hl,(RND_SP)												; RND_SP Puntero que se va desplazando por el SET de nº aleatorios.
;	ld a,(hl)
;	and $1f														; Define el nº de columna por el que va a aparecer la entidad.

;	ld hl,Posicion_inicio
;	ld (hl),a

;	Ya disponemos de una (Posicion_inicio) aleatoria y la definición de la entidad en la "Bandeja DRAW". 
;	Generamos "Movimientos masticados" de la entidad.

	call Construye_movimientos_masticados_entidad

; 	Tenemos todos los movimientos masticados de este tipo de entidad generados y guardados en su correspondiente almacén.
; 	(Puntero_de_almacen_de_mov_masticados) de esta entidad está situado al principio del almacen.
; 	(Contador_de_mov_masticados) de esta entidad contiene: el nº total de mov. masticados de este tipo de entidad.
; 	Contador_general_de_mov_masticados de este tipo de entidad actualizado.
; 	Lo tenemos todo preparado para cargar los registros con el mov. masticado y hacer la correspondiente foto.

	ld hl,(Puntero_indice_master)
	call Extrae_address

	ld e,l
	ld d,h

	call Parametros_de_bandeja_DRAW_a_caja	 					; Caja de entidades Master completa.

Movimientos_masticados_construidos 

	ld hl,Numero_de_entidades
	dec (hl)
	pop hl														; (Datos_de_nivel) en HL.
	ret z
	inc l
	jr 1B

;---------------------------------------------------------------------------------------------------------------
;
;   9/11/24
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

;	Inicializa 1er Nivel y sitúa (Puntero_indice_NIVELES) en el 2º Nivel.

	ld hl,Indice_de_niveles
	call Extrae_address   
	ld (Puntero_indice_NIVELES),de				 ; Situamos (Puntero_indice_NIVELES) en el 2º Nivel del índice.

	ld a,(hl)
	ld (Numero_de_entidades),a					 ; Fijamos el nº de entidades que tiene el nivel.

	inc l
	ld (Datos_de_nivel),hl						 ; (Datos_de_nivel) ahora apunta a la dirección de mem. donde se encuentra el .db que indica el (Tipo) de la 1ª entidad del Nivel.

	ret 										 

; ----------------------

; Fija_velocidades ld de,Perfiles_de_velocidad
; 	ld bc,4
; 	ldir
; 	ret

Situa_Puntero_indice_mov ld a,(hl)     	 							; Cargamos A con el (Tipo) de la 1ª entidad del Nivel.       
    call Calcula_salto_en_BC
    ld hl,Indice_de_mov_segun_tipo_de_entidad
    and a
    adc hl,bc
    call Extrae_address
    ld (Puntero_indice_mov),hl
    ret

;Situa_Puntero_de_almacen_de_mov_masticados ld a,(Tipo)
;	call Calcula_salto_en_BC
;	ld hl,Indice_de_almacenes_de_mov_masticados
;    and a
;    adc hl,bc
;    call Extrae_address
;	ld (Puntero_de_almacen_de_mov_masticados),hl
;	ret

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

;	call Activa_FLAG_Tipo_de_entidad							; La rutina identifica el (Tipo) de entidad que vamos a iniciar.					

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

;	call Busca_mov_masticados_segun_tipo

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

;	call Activa_FLAG_mov_masticados_completos					; Activa el FLAG que indica que este (Tipo) de entidad tiene todos sus_
;																; _ Mov_masticados ya generados.

4 call Cargamos_registros_con_mov_masticado						; Cargamos los registros con el movimiento actual y `saltamos' al movimiento siguiente.

	push ix
	pop hl 														; (Puntero_de_impresion) en HL.

	push de
	call Genera_coordenadas

	ld de,(Scanlines_album_SP)
	call Recauda_informacion_de_entidad_en_curso				; Almacena la Coordenada_Y y (Scanlines_album_SP) de la entidad en curso.
	pop de

	call Genera_datos_de_impresion
;																; La rutina [Genera_datos_de_impresion] habilita las interrupciones antes del RET. 
;																; DI nos asegura que no vamos a ejecutar FRAME hasta que no tengamos todas las entidades iniciadas.
;																; La rutina [Genera_datos_de_impresion] activa las interrupciones antes del RET.
; Actualizamos (Contador_de_mov_masticados) tras la foto.	

	call Decrementa_Contador_de_mov_masticados

; Antes de guardar los parámetros de esta entidad en su correspondiente caja hay que actualizar coordenadas.

	ld de,(Puntero_store_caja) 								
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

; -------------------------------------------------------------------------------------------------------------------
;
;	27/5/24
;
;	Inicia,genera mov. masticados y sitúa en el centro de la pantalla a Amadeus.
;

; 	Cargamos la definición de Amadeus en DRAW.
;	Nos situamos en el 1er .db, (Tipo), de la definición de Amadeus.

Inicia_Amadeus ld hl,Definicion_Amadeus
	call Definicion_de_entidad_a_bandeja_DRAW				; Vuelca los datos de la definición de Amadeus en DRAW.

	
Construye_movimientos_masticados_Amadeus

	ld hl,(Puntero_de_almacen_de_mov_masticados)			; Guardamos en la pila la dirección inicial del puntero, (para reiniciarlo más tarde).
	call Actualiza_Puntero_de_almacen_de_mov_masticados 	; Actualizamos (Puntero_de_almacen_de_mov_masticados) e incrementa_
;															; _ el (Contador_de_mov_masticados).    
	call Inicia_Puntero_objeto								; Inicializa (Puntero_DESPLZ_der) y (Puntero_DESPLZ_izq).
;															; Inicializa (Puntero_objeto) en función de la (Posicion_inicio) de la entidad.	

; Generamos movimientos masticados de Amadeus.

	ld b,121												; $0079, 121d.

1 push bc
	call Draw
	call Guarda_movimiento_masticado

	call Mov_right
	call Mov_right											; Amadeus se mueve x2 pixel.

	pop bc
	djnz 1B

; Todos los movimientos masticados de Amadeus se han creado. 

;	(Contador_de_mov_masticados) de Amadeus ="$0079", 121d movimientos en total. Amadeus se encuentra ahora en el extremo derecho de la pantalla.
;	Ahora hay que modificar la posición del (Puntero_de_almacen_de_mov_masticados), (está 4 posiciones de memoria adelantado para seguir creando desplazamientos).

	ld hl,(Puntero_de_almacen_de_mov_masticados)
	ld bc,8
	and a
	sbc hl,bc
	ld (Puntero_de_almacen_de_mov_masticados),hl

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
;	6/7/24


Store_Restore_cajas	

	ld de,(Puntero_store_caja) 								
	call Parametros_de_bandeja_DRAW_a_caja	 					; Caja de entidades completa.
	call Incrementa_punteros_de_cajas
	ret

; ---------------------------------------------------------------------
;
;	23/6/24
;
;	Limpiamos lo más rápido posible la Bandeja DRAW.
;
;	MODIFY: HL

Limpiamos_bandeja_DRAW 

	ld (Stack),sp
	ld sp,Vel_left 
	
	xor a
	ld h,a
	ld l,a

	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl

	inc sp

	push hl
	ld sp,(Stack)

	ret

; ---------------------------------------------------------------------
;
;	24/03/24

Decrementa_Contador_de_mov_masticados ld hl,(Contador_de_mov_masticados)
	dec hl
	ld (Contador_de_mov_masticados),hl
	ret

; ---------------------------------------------------------------------
;
;	7/11/24

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

	call Cargamos_registros_con_mov_masticado

; Incrementa (Contador_de_vueltas)x2. 
; (Velocidad) de la entidad será: (Contador_de_vueltas)/4.

;	1ª vuelta: (Contador_de_vueltas)="$02" --- (Velocidad)="0".
;	2ª vuelta: 	""	""	""	""	""  ="$04" ---   ""	 ""	  ="1".
;	3ª vuelta: 	""	""	""	""	""  ="$08" ---   ""	 ""	  ="2".
;	4ª vuelta: 	""	""	""	""	""  ="$10" ---   ""	 ""	  ="4".
;	5ª vuelta: 	""	""	""	""	""  ="$20" ---   ""	 ""	  ="8".   

	ld hl,Contador_de_vueltas
	sla (hl)									; Incrementa el contador, (desplaza el bit a izquierda).

	ld a,(hl)	
	sra a
	sra a

	ld (Velocidad),a

	ld a,$40
	cp (hl)
	ret nz

; Límitador. 

;	Limita el valor de (Contador_de_vueltas) a "$20" y de (Velocidad) a "$04". 

	sra (hl)
	ld hl,Velocidad
	sra (hl)

	ret

;	------------------------------------------------------------------------------------
;
;	09/11/24
;
;	INPUTS:	A contiene el (Tipo) de entidad. 
;
;	Esta pequeña sub-rutina carga BC con 0,2,4,6,8 ... en función del tipo de entidad: (1,2,3,4,...). 
;	Calcula "el salto" para situarnos en los DATOS de la ENTIDAD correcta del índice de entidades según el tipo de entidad.

Calcula_salto_en_BC and a
	jr z,1F
	sla a										
	sub 2										; ("Tipo_de_entidad")*2-2.
1 ld c,a
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
;	24/6/24
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
	ld a,(hl) 									; Volcamos Tipo.
	ld (de),a
	inc hl
;												
	ld de,Filas									; Volcamos (Filas) y (Columns).
	ld bc,2
	ldir										; Hemos volcado (Contador_de_vueltas), (Indice_Sprite_der) y (Indice_Sprite_izq).
;												; HL, (origen), apunta ahora al .db (Posicion_inicio), hay que situar DE.
	ld de,Contador_de_vueltas 
	ld a,(hl)
	ld (de),a
	inc hl										; Hemos volcado (Posicion_inicio) y (Cuad_objeto).

	ld de,Indice_Sprite_der
	ld bc,4
	ldir 										; Hemos volcado (Puntero_de_almacen_de_mov_masticados).

	ld de,Posicion_inicio
	ld bc,3									; 3 FRAMES de explosión.!!!!!!!!!!!!!!
	ldir 									; Vuelco (Frames_explosion).

	ld de,Puntero_de_almacen_de_mov_masticados
	ld bc,2
	ldir

	ret

; ----------------------------------------------------------------------------------------------------------
;
;	1/8/24
;

Parametros_de_bandeja_DRAW_a_caja 

	ld hl,Bandeja_DRAW
	ld bc,12
	ldir													 
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

