;	25/9/22

	
	DEVICE ZXSPECTRUM48

	org $a0ff 	
	
;	Vector de interrupciones.

 	defw $a101											 ; $9000. Rutina de interrupciones.

	org $a101		

	call Frame
	reti									 

; ----- ----- ----- ----- -----

	include "Sprites_e_indices.asm"
	include "Base_de_datos_Sprites.asm"


; ******************************************************************************************************************************************************************************************
; Constantes. 
; ****************************************************************************************************************************************************************************************** 
;
; 8/11/22
;
; Constantes generales.
;

Centro_arriba equ $0160 								; Emplearemos estas constantes en la rutina de `recolocación´ del objeto:_
Centro_abajo equ $0180 									; _[Comprueba_limite_horizontal]. El byte alto en las dos primeras constantes_
Centro_izquierda equ $0f 								; _indica el tercio de pantalla, (línea $60 y $80 del 2º tercio de pantalla).
Centro_derecha equ $10 									; Las constantes (Centro_izquierda) y (Centro_derecha) indican la columna $0f y $10 de pantalla.
Album_de_fotos equ $7000								; En (Album_de_fotos) vamos a ir almacenando los valores_
;                                   				    ; _de los registros y las llamadas a [Pintorrejeo].   
;                               				        ; De momento situamos este almacén en $7000.   


; ******************************************************************************************************************************************************************************************
; Variables. 
; ****************************************************************************************************************************************************************************************** 
;
; 10/11/22
;
; Variables de DRAW. (Motor principal).
;

Filas db 2												; Filas. [DRAW]
Columns db 2  											; Columnas. [DRAW]
Posicion_actual defw $0000								; Dirección actual del Sprite. [DRAW]
CTRL_DESPLZ db 0										; Este byte nos indica la posición que tiene el Sprite dentro del mapa de desplazamientos. Si el valor es negativo,_
; 														; _ estamos desplazados hacia la izquierda y si es positivo, hacia la derecha.
; 														; El hecho de que este byte sea distinto de "0", indica que se ha modificado el nº de columnas del objeto.
; 														; Cuando vamos a imprimir un Sprite en pantalla, la rutina de pintado consultará este byte para situar (Puntero_objeto). [Mov_left]. 
Attr db %00000110										; Atributos de la entidad:

;	El formato: FBPPPIII (Flash, Brillo, Papel, Tinta).
;
;	COLORES: 0 ..... NEGRO
;    		 1 ..... AZUL
; 			 2 ..... ROJO
;			 3 ..... MAGENTA
; 			 4 ..... VERDE
; 			 5 ..... CIAN
;			 6 ..... AMARILLO
; 			 7 ..... BLANCO

Indice_Sprite defw Indice_Coracao
Puntero_DESPLZ defw 0
Posicion_inicio defw $47a1								; Dirección de pantalla donde aparece el objeto. [DRAW]
Cuad_objeto db 0			 							; Almacena el cuadrante de pantalla donde se encuentra el objeto, (1,2,3,4). [DRAW]
Coordenada_X db 0 										; Coordenada X del objeto. (En chars.)
Coordenada_y db 0 										; Coordenada Y del objeto. (En chars.)

; Variables de objeto. (Características).

Vel_left db 1 											; Velocidad izquierda. Nº de píxeles que desplazamos el objeto a izquierda. 1, 2, 4 u 8 px.
Vel_right db 1 											; Velocidad derecha. Nº de píxeles que desplazamos el objeto a derecha. 1, 2, 4 u 8 px.
Vel_up db 1 											; Velocidad subida. Nº de píxeles que desplazamos el objeto hacia arriba. (De 1 a 7px).
Vel_down db 3 											; Velocidad bajada. Nº de píxeles que desplazamos el objeto hacia abajo. (De 1 a 7px).

Variables_de_borrado db 0,0 							; Pequeño almacén donde guardaremos, (ANTES DE DESPLAZAR), las variables requeridas por [DRAW]. Filas, Columns, Posicion_actual y CTRL_DESPLZ.
	defw 0 												; Estas variables se modifican una vez desplazado el objeto. Nuestra intención es: PINTAR1-MOVER-BORRAR1-PINTAR2...
	db 0
Variables_de_pintado db 0,0 							; Pequeño almacén donde guardaremos, (ANTES DE DESPLAZAR), las variables requeridas por [DRAW]. Filas, Columns, Posicion_actual y CTRL_DESPLZ.
	defw 0 												; Estas variables se modifican una vez desplazado el objeto. Nuestra intención es: PINTAR1-MOVER-BORRAR1-PINTAR2...
	db 0

; Variables de funcionamiento de las rutinas de movimiento. (Mov_left), (Mov_right), (Mov_up), (Mov_down).

Ctrl_0 db 0 											; Byte de control. A través de este byte de control. Las rutinas de desplazamiento: [Mov_right], [Mov_left], [Mov_up] y [Mov_down],_
;														; _indican a las subrutinas de recolocación del objeto de la rutina [DRAW]: [Comprueba_limite_horizontal] y [Comprueba_limite_vertical],_
; 														; _que desaparecemos por un extremo de la pantalla y hemos de `reaparecer´ por el contrario. 
; 														; Este dato es necesario debido a que las rutinas de recolocación, están ideadas para recolocar el puntero (Posicion_actual), cuando pasamos_
; 														; _de un cuadrante a otro de la pantalla pero no preveen la `desaparición´ por un extremo del cuadrante y la `reaparición´ por el otro.
;
; 														DESCRIPCIÖN:
;
; 														SET 0, [Reaparece_derecha]. El bit 0 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_left] detecta que el objeto ha `desaparecido´ por el_
; 																_lado izquierdo de la pantalla y ha de `reaparecer´ por el derecho. ([Comprueba_limite_vertical]).
; 														SET 1, [Reaparece_izquierda]. El bit 1 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_right] detecta que el objeto ha `desaparecido´ por el_
; 																_lado derecho de la pantalla y ha de `reaparecer´ por el izquierdo. ([Comprueba_limite_vertical]).
; 														SET 2, [Reaparece_abajo]. El bit 2 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_up] detecta que el objeto ha `desaparecido´ por la_
; 																_parte superior de la pantalla y ha de `reaparecer´ por el inferior. ([Comprueba_limite_horizontal]).
; 														SET 3, [Reaparece_arriba]. El bit 3 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_down] detecta que el objeto ha `desaparecido´ por la_
; 																_parte inferior de la pantalla y ha de `reaparecer´ por la superior. ([Comprueba_limite_horizontal]).
; 														SET 4, El Bit4 a "1", indica que hubo movimiento de la entidad. Necesitamos esta información
;												                _para "NO BORRAR/PINTAR" en objeto si NO hubo MOVIMIENTO. 
; 														SET 6, Está a "1" si el Sprite que tenemos cargado en el `Engine´ es AMADEUS.
;															   
; 														SET 7, El bit 7 se encuentra alto, ("1"), cuando el último movimiento horizontal se ha producido a la "DERECHA".
; 															   _ Utilizo la información que proporciona este BIT para modificar (CTRL_DESPLZ) si el siguiente movimiento_
; 															   _ se va a producir a la izquierda. "1" DERECHA - "0" IZQUIERDA.

Obj_dibujado db 0 										; Indica a [DRAW] si hay que PINTAR o BORRAR el objeto.	

; Movimiento.

Puntero_indice_mov defw Indice_mov_coracao
Puntero_mov defw 0
Contador_db_mov db 0
Incrementa_puntero db 0
Repetimos_db db 0


; Variables de funcionamiento. [DRAW].

Puntero_objeto defw 0									; Donde están los datos para pintar el Sprite.
Puntero_datas defw 0
Columnas db 0
Limite_horizontal defw 0 								; Dirección de pantalla, (scanline), calculado en función del tamaño del Sprite. Si el objeto llega a esta línea se modifica_    
; 														; _(Posicion_actual) para poder asignar un nuevo (Cuad_objeto).
Limite_vertical db 0 									; Nº de columna. Si el objeto llega a esta columna se modifica (Posicion_actual) para poder asignar un nuevo (Cuad_objeto).


; Cajas. Almacenes.

Caja_de_DESPLZ defw 0								   	; Caja de memoria donde almacenaremos los bytes del Sprite una vez desplazado. 3x4, (Filas/Columnas).(12*8). [DRAW]/[Mov_left]    
Caja_de_BORRADO defw 0 									; Caja de memoria donde tendremos una copia de respaldo de Caja_de_DESPLZ. Se utiliza para borrar la entidad, (función XOR). [DRAW]/[Mov_left] 

; Variables de funcionamiento, (No incluidas en base de datos de entidades), a partir de aquí!!!!!

; Gestión de ENTIDADES.

Puntero_store_entidades defw 0
Puntero_restore_entidades defw 0
Indice_restore defw 0

; ----- ----- De aquí para arriba son datos que hemos de guardar en los almacenes de entidades.

Numero_de_entidades db 4								; Nº de objetos en pantalla, (contando con Amadeus).
Numero_de_malotes db 0									; Inicialmente, (Numero_de_malotes)=(Numero_de_entidades).
;														; Esta variable es utilizada por la rutina [Guarda_foto_registros]_
;														; _ para actualizar el puntero (Stack_snapshot) o reiniciarlo cuando_
;														; _ (Numero_de_malotes)="0".
Stack defw 0 											; La rutina de pintado, [Pintorrejeo], utiliza esta_
;														; _variable para almacenar lo posición del puntero_
; 														; _de pila, SP.
Stack_2 defw 0											; 2º variable destinada a almacenar el puntero de pila, SP.
;														; La utiliza la rutina [Extrae_foto_registros].
Stack_snapshot defw Album_de_fotos						; Puntero que indica la posición de memoria donde vamos a guardar_
;														; _el snapshot de los registros de la siguiente entidad.
;														; Inicialmente está situado el la posición $7000, Album_de_fotos.

; Gestión de FRAMES.

Switch db 0

; Variables de Raster y localización en pantalla.

Temp_Raster defw $ff00


; Rutina principal *************************************************************************************************************************************************************************
;
;	14/11/22	

START ld sp,$ffff

	ld a,$a0 
	ld i,a 												 ; Byte alto de la dirección donde se encuentra nuestro vector de interrupciones en el registro I. ($90). El byte bajo será siempre $ff.
	IM 2 											     ; Habilitamos el modo 2 de INTERRUPCIONES.
	DI 												 

	xor a												 ; Borde NEGRO. PAPER CYAN, INK BLACK.
	out ($fe),a
	ld a,%00000111
	call Cls

;	call Pinta_FILAS

	call Pulsa_ENTER

;	Cada vez que iniciamos una entidad, hay que hacer una llamada a (Inicia_sprite). Sólo al iniciar!!!!!
;   Inicialmente tengo cargado a Amadeus en el engine.
;	Pintamos el resto de entidades:

	call Inicia_punteros_de_entidades
	ld hl,Numero_de_entidades
	ld b,(hl)

1 push bc  												; Guardo el contador de entidades.
 	call Inicia_sprite
	call Draw
	call Guarda_foto_registros
	call Store_Restore_entidades 				    	; Guardo los parámetros de la 1ª entidad y sitúa (Puntero_store_entidades) en la siguiente.
	pop bc
	djnz 1B  											; Decremento (CONTANDOR AMADEUS).

; Volvemos a situar los punteros STORE/RESTORE de entidades en AMADEUS y cargamos los datos de nuestra nave en el engine.

    call Inicia_punteros_de_entidades
    call Restore_Primera_entidad

4 ei
	jr 4B

; -----------------------------------------------------------------------------------

Frame 

; He de imprimir sólo el nº de fotos que he hecho. Sólo BORRAMOS/PINTAMOS los objetos que se han desplazado.
; Necesito calcular nª de malotes, para ello utilizaré (Stack_snapshot)-(Album_de_fotos).


	call Calcula_numero_de_malotes						; Nº de entidades que vamos a imprimir en pantalla.

	ld a,7                                      	     
    out ($fe),a  
	call Extrae_foto_registros 							; Pintamos el fotograma anterior.

	ld a,0                                      	     
    out ($fe),a  

; ----------------------------------------------------------------------

	ld a,1
	out ($fe),a  

	ld hl,Album_de_fotos
    ld (Stack_snapshot),hl								; Nos situamos al principio del álbum de fotos.
    ld a,(Numero_de_entidades)
    ld b,a

2 push bc

	call Mov_obj										; MOVEMOS y decrementamos (Numero_de_malotes)

 	ld a,(Ctrl_0)
	bit 4,a
	jr z,1F                                             ; Omitimos BORRAR/PINTAR si no hay movimiento.
; ---------

    call Borra_Pinta_obj								; BORRAMOS/PINTAMOS !!!!!!!!!!!!!!!!!!!!
	
	ld hl,Ctrl_0
    res 4,(hl)

1 call Store_Restore_entidades

	pop bc
	djnz 2B

	call Inicia_punteros_de_entidades
	call Restore_Primera_entidad

	ld a,0
	out ($fe),a  

;	jr $

	ret

; --------------------------------------------------------------------------------------------------------------
;
Mov_obj 

 	call Prepara_caja_de_borrado  						; LDIR (Caja_de_DESPLZ) a (Caja_de_BORRADO).
    call Prepara_var_pintado_borrado                    ; Almaceno las `VARIABLES DE BORRADO´.    

	ld a,1 				 								; (Obj_dibujado)="1". El objeto está impreso en pantalla. En este caso, (Mod_puntero_datas) sitúa_
	ld (Obj_dibujado),a 								; (Puntero_datas) en la Caja_de_BORRADO.

; Movemos Amadeus o enemigos...

	ld a,(Ctrl_0) 										; Detectamos si el Sprite que vamos a desplazar es AMADEUS,_
	bit 6,a 											; _si es así, leeremos el teclado para detectar la dirección.
	call nz,Movimiento_Amadeus 							; (Mov_right), (Mov_left).

	ld a,(Ctrl_0)
	bit 6,a	
	call z,Movimiento									; Desplazamos el objeto. MOVEMOS !!!!!

	ld a,(Ctrl_0) 										; Salimos de la rutina si no ha habido movimiento.
	bit 4,a
	ret z
; ---------

    call Prepara_var_pintado_borrado	                ; Almaceno las `VARIABLES DE PINTADO´.         
    call Repone_borrar                                  
	call Mod_puntero_datas 								; Al jugar con 2 estados, PINTADO/BORRADO, e ir alternando ambos, llamaremos a [Mod_puntero_datas] antes de PINTAR/BORRAR el objeto.
	call Draw											; Preparamos las variables para borrar.
	call Guarda_foto_registros

	ret

; --------------------------------------------------------------------------------------------------------------
;
Borra_Pinta_obj xor a
	ld (Obj_dibujado),a 								; (Obj_dibujado)="0". El objeto está borrado. En este caso, (Mod_puntero_datas) sitúa (Puntero_datas) en_
	call Repone_pintar
	call Mod_puntero_datas 								; Al jugar con 2 estados, PINTADO/BORRADO, e ir alternando ambos, llamaremos a [Mod_puntero_datas] antes de PINTAR/BORRAR el objeto.	
	call Draw 											
	call Guarda_foto_registros
	ret

; --------------------------------------------------------------------------------------------------------------

Prepara_var_pintado_borrado	ld hl,Filas
	ld a,(Obj_dibujado)
	and a
	jr z,1F
	ld de,Variables_de_pintado
	jr 2F
1 ld de,Variables_de_borrado
2 ld bc,5
	ldir
	ret

Repone_borrar ld hl,Variables_de_borrado
	ld de,Filas
	ld bc,5
	ldir
	ret

Repone_pintar ld hl,Variables_de_pintado
	ld de,Filas
	ld bc,5
	ldir
	ret	

Prepara_caja_de_borrado ld hl,(Caja_de_DESPLZ)
	ld (Caja_de_BORRADO),hl
	ret	

; *************************************************************************************************************************************************************
;
; 21/10/22
;
; Sitúa el puntero (Puntero_store_entidades) en la 1ª entidad del índice.
; Sitúa el puntero (Puntero_restore_entidades) en el 1er `enemigo', (2º entidad del índice).
; Destruye HL y DE !!!!!
 
Inicia_punteros_de_entidades ld hl,Indice_de_entidades
    call Extrae_address
    ld (Puntero_store_entidades),hl

	ld hl,Indice_de_entidades+2
	ld (Indice_restore),hl
	call Extrae_address
	ld (Puntero_restore_entidades),hl

    ret

; -------------------------------------------------------------------------------------------------------------
;
; 16/11/22 

Calcula_numero_de_malotes ld hl,(Stack_snapshot)
	xor a
	ld h,a
	ld a,l
1 sub 14
	jr z,2F
	inc h
	jr 1B
2 inc h
	ld a,h
	ld (Numero_de_malotes),a
	ret

; *************************************************************************************************************************************************************
;
; 20/10/22
;
; Extrae la direccioń que contiene un puntero, (HL), también en HL.
;
; Destruye el puntero y DE !!!!!

Extrae_address ld e,(hl)
	inc hl
	ld d,(hl)
	dec hl
	ex de,hl
	ret

; *************************************************************************************************************************************************************
;
;	21/9/22
;
;   Destruye HL !!!!!, 

Inicia_sprite ld hl,(Indice_Sprite)
	ld (Puntero_DESPLZ),hl
	call Extrae_address
	ld (Puntero_objeto),hl 								

; Tenemos que activar el bit6 de (Ctrl_0) si el Sprite que hemos cargado es AMADEUS.

	ld hl,Amadeus
	ld bc,(Puntero_objeto)
	sub hl,bc
	ret nz

	ld hl,Ctrl_0
	set 6,(hl) 											; Cuando activamos Amadeus lo indicamos alzando el bit6 de (Ctrl_0). Esta información la utilizaremos para limitar los movimientos_

 	ret 												; _de nuestra nave en los extremos.

; *************************************************************************************************************************************************************
;
;	22/10/22
;
;	Almacena los datos del Sprite que tenemos cargado en DRAW, en su respectiva BASE DE DATOS.

Store_Restore_entidades  

	push hl 
	push de
 	push bc

;	STORE !!!!!

	ld hl,Filas
	ld de,(Puntero_store_entidades) 					; Puntero que se desplaza por las distintas entidades.
	ld bc,50
	ldir												; Hemos GUARDADO los parámetros de la 1ª entidad en su base de datos.

;	Incrementa STORE y ejecuta RESTORE !!!!! 

	ld hl,(Puntero_restore_entidades)
	ld (Puntero_store_entidades),hl 					; Situamos (Puntero_store_entidades) en la 2ª entidad.
	ld de,Filas 										; Hemos RECUPERADO los parámetros de la 2ª entidad de su base de datos.
	ld bc,50
	ldir

;	Incrementa RESTORE !!!!! 

    ld hl,(Indice_restore)
	inc hl
	inc hl
	ld (Indice_restore),hl
    call Extrae_address
    ld (Puntero_restore_entidades),hl

	pop bc
	pop de
	pop hl

	ret

; **************************************************************************************************
;
;	29/10/22
;
;	Cargamos los datos de la 1º entidad en el `engine'.

Restore_Primera_entidad push hl 
	push de
 	push bc

	ld hl,(Puntero_store_entidades)						; (Puntero_store_entidades) apunta a la dbase de Amadeus. 
	ld de,Filas 										
	ld bc,50
	ldir

	pop bc
	pop de
	pop hl

	ret

; *************************************************************************************************************************************************************
;
; Teclado.

Pulsa_ENTER ld a,$bf 									; Esperamos la pulsación de la tecla "ENTER".
	in a,($fe)
	and $01
	jr z,1f
	jr Pulsa_ENTER
1 ret

; **************************************************************************************************
;
; Temporización.

; $0320 ..... El RASTER va a empezar a pintar el 1er scanline de la primera FILA de la pantalla.
;       ..... (14175 T/States) + 71 es lo que tarda el RASTER en llegar al 1er SCANLINE de la 1ª FILA.
; $00ff ..... Es lo que tarda el RASTER en pintar 1 SCANLINE. (31 T/States) + 71. ..... 102 T/States aprox. 
;		..... 224 T/States es lo que tarda el raster en pintar 1 scanline.

; $0045 ..... Es lo que tardamos en pintar 1 FILA completa, (8 Scanlines). (1794 T/States) + 71 ..... 1 FILA.
;       ..... (14920 T/States) + 71  ..... Es lo que tarda el RASTER en pintar 1 TERCIO.
; $0365 ..... Llegamos al final de la 1ª FILA, (8 Scanlines).

; A partir de $4f61 no hace falta DELAY.

;	!!!!!!!! DESTRUYE BC !!!!!!!!!!!

DELAY LD BC,$03ef							;$0320 ..... Delay mínimo
wait DEC BC  								;Sumaremos $0045 por FILA a esta cantidad inicial. Ejempl: si el Sprite ocupa la 1ª y 2ª_				
	LD A,B 										
	AND A
	JR NZ,wait
	RET

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	21/4/22	

Movimiento_Amadeus 

	ld a,$f7		  										; Rutina de TECLADO. Detecta cuando se pulsan las teclas "1" y "2"  y llama a las rutinas de "Mov_izq" y "Mov_der". $f7  detecta fila de teclas: (5,4,3,2,1).
	in a,($fe)												; Carga en A la información proveniente del puerto $FE, teclado.
	and $01													; Detecta cuando la tecla (1) está actuada. "1" no pulsada "0" pulsada. Cuando la operación AND $01 resulta "0"  llama a la rutina "Mov_izq".
    call z,Mov_left											;			"			"			"			"			"			"			"			"
	ld a,$f7
	in a,($fe)
	and $01
	ret z
	ld a,$f7
	in a,($fe)												; Carga en A la información proveniente del puerto $FE, teclado.
	and $02													; Detecta cuando la tecla (1) está actuada. "1" no pulsada "0" pulsada. Cuando la operación AND $02 resulta "0"  llama a la rutina "Mov_der".
	call z,Mov_right										;			"			"			"			"			"			"			"			"
    ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	include "Draw_XOR.asm"
	include "calcula_tercio.asm"
	include "Calcula_direccion_atributos.asm"
	include "Define_atributos.asm"
	include "Cls.asm"
	include "Direcciones.asm"
	include "Genera_coordenadas.asm"
	include "Patrones_de_mov.asm"
	include "Guarda_foto_registros.asm"


	SAVESNA "Amadeus_1.xx.sna", START



