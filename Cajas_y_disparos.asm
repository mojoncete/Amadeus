; ---------------------------------------------------------------------
; Cajas de entidades, Amadeus y disparos. Índices de disparos y cajas. 
; Índice de Patrón de movimiento para tipo de entidad.
; ---------------------------------------------------------------------

; 30/05/24
;
;	En esta tabla iremos almacenando:
;
;	(Columna_Y),(Dirección de memoria donde se encuentran almacenados los scanlines masticados de cada entidad, (Scanlines_album)).
;	
;	Los 6 últimos bytes contienen el borrado/pintado de Amadeus, (Amadeus_scanlines_album).

Numeros_aleatorios ds 7

	org $8900	

Tabla_de_pintado ds 27								 ; No puede haber cambio de byte alto en la Tabla_de_pintado, ese es el motivo del "org".

;	db 0, defw 0
;	db 0, defw 0
;	db 0, defw 0
;	db 0, defw 0
;	db 0, defw 0
;	db 0, defw 0
;	db 0, defw 0

Indice_de_almacenes_de_mov_masticados defw Almacen_de_movimientos_masticados_Entidad_1 
	defw Almacen_de_movimientos_masticados_Entidad_2 
;	defw ...
; 	defw ...
	defw 0

Indice_de_mov_segun_tipo_de_entidad defw Indice_mov_Baile_de_BadSat
;	defw ...
; 	defw ...
	defw 0

;* Caja del disparo de Amadeus y cajas de disparos de entidades.

Disparo_Amad defw 0									; Puntero objeto.
	defw 0											; Puntero de impresión.

Indice_de_disparos_entidades defw Disparo_1
	defw Disparo_2
	defw Disparo_3
	defw Disparo_4
	defw Disparo_5
	defw Disparo_6
	defw Disparo_7

	db 0,0,0								; Puntero objeto.
	defw 0									; Puntero de impresión.
Disparo_7 db 0	     						; Control.
						
	db 0,0,0								; Puntero objeto.
	defw 0									; Puntero de impresión.
Disparo_6 db 0		    					; Control.

	db 0,0,0								; Puntero objeto.
	defw 0									; Puntero de impresión.
Disparo_5 db 0			    				; Control.
						
	db 0,0,0								; Puntero objeto.
	defw 0									; Puntero de impresión.
Disparo_4 db 0				     			; Control.

	db 0,0,0								; Puntero objeto.
	defw 0									; Puntero de impresión.
Disparo_3 db 0					    		; Control.
						
	db 0,0,0								; Puntero objeto.
	defw 0									; Puntero de impresión.
Disparo_2 db 0						    	; Control.

	db 0,0,0								; Puntero objeto.
	defw 0									; Puntero de impresión.
Disparo_1 db 0							    ; Control.
						
; -------------------------------------------------------------------------------------
;
;	Índice de cajas de entidades.
;
;	18/1/24
;

Indice_de_cajas_de_entidades						

	defw Caja_1
	defw Caja_2
	defw Caja_3
	defw Caja_4
	defw Caja_5
	defw Caja_6
	defw Caja_7

	defw 0
	defw 0

; -------------------------

; Relleno para que no se corrompa el movimiento. ?????

;	db 0

; ---------- ---------- ---------- ---------- ----------
;
;	28/05/24
;
; 	Cada caja tiene 14 bytes !!!
;
;	En principio Amadeus mo utiliza los parámetros: (Contador_de_vueltas) y (Velocidad). Estarán a "0" aunque no descarto utilizarlos más adelante para otra función.

Amadeus_BOX db 0										; (Tipo).
CX_Amadeus db 0,$15                                     ; (Coordenada_X), (Coordenada_Y).
	db 0												; (Contador_de_vueltas).
Impacto_Amadeus	db 0									; (Impacto).
p.imp.amadeus defw 0									; (Puntero_de_impresion).
Pamm_Amadeus defw 0										; (Puntero_de_almacen_de_mov_masticados).
Comm_Amadeus defw 0 									; (Contador_de_mov_masticados).
	db 0												; (Velocidad). 					

; ---------- ---------- ---------- ---------- ----------
;
;	22/01/24
;
; 	Cada caja tiene 12 bytes !!!

Caja_1 db 0,0,0											; (Tipo) / (Coordenada_X) / (Coordenada_Y).
	db 0												; (Contador_de_vueltas).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Velocidad). 					

; ---------- ---------- ---------- ---------- ----------	

Caja_2 db 0,0,0											; (Tipo) / (Coordenada_X) / (Coordenada_Y).
	db 0 												; (Contador_de_vueltas).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Velocidad). 					

; ---------- ---------- ---------- ---------- ----------	

Caja_3 db 0,0,0											; (Tipo) / (Coordenada_X) / (Coordenada_Y).
	db 0 												; (Contador_de_vueltas).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Velocidad). 					

; ---------- ---------- ---------- ---------- ----------

Caja_4 db 0,0,0											; (Tipo) / (Coordenada_X) / (Coordenada_Y).
	db 0 												; (Contador_de_vueltas).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Velocidad). 					

; ---------- ---------- ---------- ---------- ----------

Caja_5 db 0,0,0											; (Tipo) / (Coordenada_X) / (Coordenada_Y).
	db 0 												; (Contador_de_vueltas).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Velocidad). 					

; ---------- ---------- ---------- ---------- ----------

Caja_6 db 0,0,0											; (Tipo) / (Coordenada_X) / (Coordenada_Y)..
	db 0 												; (Contador_de_vueltas).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Velocidad). 					

; ---------- ---------- ---------- ---------- ----------	

Caja_7 db 0,0,0											; (Tipo) / (Coordenada_X) / (Coordenada_Y)..
	db 0 												; (Contador_de_vueltas).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Velocidad). 					

; -------------------------------------------------------------------------------------
;
;	11/1/24
;
;	TIPOS de "Entidades maliciosas" que quieren conquistar la Tierra.	
;
;	Notas de funcionamiento: (Cuad_objeto) siempre será "1" independientemente de su (Posicion_inicio).
;		De no ser así, la rutina [Recompone_posicion_inicio] generará problemas a la hora de hacer que_
;		_ la entidad aparezca `al píxel', por la parte derecha de la pantalla. Esto se debe a como están_
;		_ construidas las rutinas [Mov_right] y [Mov_left].

Indice_de_definiciones_de_entidades

	defw Entidad_1
	defw Entidad_2

;	DEFINICIONES DE ENTIDADES. (20 Bytes).

;	BADSAT, (Satélite malvado).	

Entidad_1 db 1,2,2		                     			; (Tipo) / (Filas) / (Columns).
	db 2												; (Contador_de_vueltas).
	defw Indice_Badsat_der								; (Indice_Sprite_der).
	defw Indice_Badsat_izq								; (Indice_Sprite_izq).
	defw $4003	                                     	; (Posicion_inicio).
	db 1												; (Cuad_objeto).
	defw Almacen_de_movimientos_masticados_Entidad_1	; (Puntero_de_almacen_de_mov_masticados)

Entidad_2 db 1,2,2		                     			; (Tipo) / (Filas) / (Columns).
	db 1												; (Contador_de_vueltas).
	defw Indice_Badsat_der								; (Indice_Sprite_der).
	defw Indice_Badsat_izq								; (Indice_Sprite_izq).
	defw $5040                                      	; (Posicion_inicio).
	db 1												; (Cuad_objeto).
	defw Almacen_de_movimientos_masticados_Entidad_1	; (Puntero_de_almacen_de_mov_masticados)

; -------------------------------------------------------------------------------------
;
;	28/05/24
;
;	Definición de Amadeus.
;
;	Amadeus no utiliza el parámetro: (Contador_de_vueltas). Lo colocamos a "0".
;	Inicialmente situamos a Amadeus en el centro de la pantalla.

Definicion_Amadeus db 0,2,2		                     	; (Tipo) / (Filas) / (Columns).
	db 0												; (Contador_de_vueltas).
	defw Indice_Amadeus_der								; (Indice_Sprite_der).
	defw Indice_Amadeus_izq								; (Indice_Sprite_izq).
	defw $50c1	                                     	; (Posicion_inicio).
	db 3												; (Cuad_objeto).
	defw Almacen_de_movimientos_masticados_Amadeus		; (Puntero_de_almacen_de_mov_masticados).