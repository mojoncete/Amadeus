
; Cajas de entidades, Amadeus y disparos. Índices de disparos y cajas. 
; Índice de Patrón de movimiento para tipo de entidad.

; 19/01/24

Indice_de_mov_segun_tipo_de_entidad defw Indice_mov_Baile_de_BadSat
;	defw ...
; 	defw ...
	defw 0

; Control. %00000001 00000001 
;
;     [Byte 0] ..... Impacto. "$81" Cuando dispara Amadeus, (hacia arriba), "$80" cuando lo_
;                    _ hacen las entidades hacia abajo.
;
;     [Byte 1] ..... Dirección. "$81" Cuando se produce colisión al generar un disparo."$80" si no la hay.

Indice_de_disparos_Amadeus defw Disparo_1A
	defw Disparo_2A
	defw Disparo_3A

Disparo_1A defw 0									; Control.
	defw 0											; Puntero objeto.
ON_Disparo_2A defw 0								; Puntero de impresión.
	defw 0											; Rutina de impresión.										

Disparo_2A defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.			

Disparo_3A defw 0	

Indice_de_disparos_entidades defw Disparo_1
	defw Disparo_2
	defw Disparo_3
	defw Disparo_4
	defw Disparo_5
	defw Disparo_6
	defw Disparo_7
	defw Disparo_8
	defw Disparo_9
	defw Disparo_10
	defw Disparo_11

Disparo_1 defw 0									; Control. 
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.										

Disparo_2 defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.				

Disparo_3 defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.								

Disparo_4 defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.		

Disparo_5 defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.		

Disparo_6 defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.		

Disparo_7 defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.									

Disparo_8 defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.		

Disparo_9 defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.									

Disparo_10 defw 0									; Control.
	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.
	defw 0											; Rutina de impresión.		

Disparo_11 defw 0

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

; ---------- ---------- ---------- ---------- ----------

Amadeus_db db 0,2,2										; (Tipo) / (Filas) / (Columns).
	defw 0		 										; (Posicion_actual).
	defw 0	 											; (Puntero_objeto).
	db 0,0												; (Coordenada_X) / (Coordenada_Y).

ctrl_desplz_amadeus	db 0								; (CTRL_DESPLZ).
	db %00000101										; (Attr).
	defw Indice_Amadeus_der								; (Indice_Sprite_der).		
	defw Indice_Amadeus_izq								; (Indice_Sprite_izq).
	defw 0		 										; (Puntero_DESPLZ_der).
	defw 0												; (Puntero_DESPLZ_izq).
	defw $50c1											; (Posicion_inicio).		$50c1 - $50de
	db 4 												; (Cuad_objeto).
	db 0												; Impacto. "1" existe impacto en la entidad.
	ds 6												; Variables_de_borrado 

p.imp.amadeus defw 0 									; Puntero_de_impresion.

	defw Almacen_de_movimientos_masticados_Amadeus+6  	; Puntero_de_almacen_de_mov_masticados
	defw 0 												; Contador_de_mov_masticados
	db $40												; (Ctrl_0).
	defw 0,0,0	 										; (Puntero_indice_mov) / (Puntero_mov) / (Puntero_bucle).
	db 0,0,0											; (Incrementa_puntero) / (Incrementa_puntero_backup) / (Repetimos_desplazamiento).
	db 0,0												; (Repetimos_desplazamiento_backup) / (Repetimos_movimiento).
	db 0												; (Cola_de_desplazamiento).
	db 0 												; (Columnas).									
	defw 0												; (Limite_horizontal).
	db 0,0,0											; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------
;
;	22/01/24
;
; 	Cada caja tiene 12 bytes !!!

Caja_1 db 0,0											; (Coordenada_X) / (Coordenada_Y).
	db %00000000										; (Attr).
;	db 0												; (Cuad_objeto).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Ctrl_0).
	db 0												; (Ctrl_2). 

; ---------- ---------- ---------- ---------- ----------	

Caja_2 db 0,0											; (Coordenada_X) / (Coordenada_Y).
	db %00000000										; (Attr).
;	db 0												; (Cuad_objeto).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Ctrl_0).
	db 0												; (Ctrl_2). 

; ---------- ---------- ---------- ---------- ----------	

Caja_3 db 0,0											; (Coordenada_X) / (Coordenada_Y).
	db %00000000										; (Attr).
;	db 0												; (Cuad_objeto).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Ctrl_0).
	db 0												; (Ctrl_2). 

; ---------- ---------- ---------- ---------- ----------

Caja_4 db 0,0											; (Coordenada_X) / (Coordenada_Y).
	db %00000000										; (Attr).
;	db 0												; (Cuad_objeto).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Ctrl_0).
	db 0												; (Ctrl_2). 

; ---------- ---------- ---------- ---------- ----------

Caja_5 db 0,0											; (Coordenada_X) / (Coordenada_Y).
	db %00000000										; (Attr).
;	db 0												; (Cuad_objeto).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Ctrl_0).
	db 0												; (Ctrl_2). 

; ---------- ---------- ---------- ---------- ----------

Caja_6 db 0,0											; (Coordenada_X) / (Coordenada_Y).
	db %00000000										; (Attr).
;	db 0												; (Cuad_objeto).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Ctrl_0).
	db 0												; (Ctrl_2). 

; ---------- ---------- ---------- ---------- ----------	

Caja_7 db 0,0											; (Coordenada_X) / (Coordenada_Y).
	db %00000000										; (Attr).
;	db 0												; (Cuad_objeto).
	db 0												; (Impacto).
	defw 0												; (Puntero_de_impresion).
	defw 0												; (Puntero_de_almacen_de_mov_masticados).
	defw 0 												; (Contador_de_mov_masticados).
	db 0												; (Ctrl_0).
	db 0												; (Ctrl_2). 

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
	db %00000100										; (Attr).
	defw Indice_Badsat_der								; (Indice_Sprite_der).
	defw Indice_Badsat_izq								; (Indice_Sprite_izq).
	defw $4003                                      	; (Posicion_inicio).
	db 1												; (Cuad_objeto).
	defw Almacen_de_movimientos_masticados_Entidad_1	; (Puntero_de_almacen_de_mov_masticados)

Entidad_2 db 1,2,2		                     			; (Tipo) / (Filas) / (Columns).
	db %00000010										; (Attr).
	defw Indice_Badsat_der								; (Indice_Sprite_der).
	defw Indice_Badsat_izq								; (Indice_Sprite_izq).
	defw $5040                                      	; (Posicion_inicio).
	db 1												; (Cuad_objeto).
	defw Almacen_de_movimientos_masticados_Entidad_1	; (Puntero_de_almacen_de_mov_masticados)
