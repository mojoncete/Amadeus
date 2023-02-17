
; Base de datos de entidades e Índice.
;
; 17/02/23

Indice_de_disparos defw Disparo_1
	defw Disparo_2
	defw Disparo_3
	defw Disparo_4
	defw Disparo_5
	defw Disparo_6
	defw Disparo_7
	defw Disparo_8
	defw Disparo_9
	defw Disparo_10

Disparo_1 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.										

Disparo_2 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.			

Disparo_3 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.										

Disparo_4 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.	

Disparo_5 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.										

Disparo_6 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.			

Disparo_7 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.										

Disparo_8 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.	

Disparo_9 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.										

Disparo_10 db 0,0									; Impacto / Dirección.
	defw 0											; Puntero de_impresión.
	defw 0											; Puntero objeto.
	defw 0											; Rutina de impresión.	

; -------------------------------------------------------------------------------------

Indice_de_entidades									; 58 Bytes por entidad.

	defw Entidad_1
	defw Entidad_2
	defw Entidad_3
	defw Entidad_4
;	...
;	...
;	+ entidades ...

	defw 0
	defw 0

; ---------- ---------- ---------- ---------- ----------

Amadeus_db db 2,2									; (Filas) / (Columns).
	defw 0		 									; (Posicion_actual).
	defw 0	 										; (Puntero_objeto).
	db 0,0,0										; (Coordenada_X) / (Coordenada_Y) / (CTRL_DESPLZ).

	db %00000101									; (Attr).

	defw Indice_Amadeus_der							; (Indice_Sprite_der).		
	defw Indice_Amadeus_izq							; (Indice_Sprite_izq).
	defw 0		 									; (Puntero_DESPLZ_der).
	defw 0											; (Puntero_DESPLZ_izq).

	defw $50d0										; (Posicion_inicio).
	db 4 											; (Cuad_objeto).

	db 2,2,0,0										; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0											; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).

; ---------- ---------- ---------- ---------- ----------

Entidad_1 db 0,0									; (Filas) / (Columns).
	defw 0											; (Posicion_actual).
	defw 0 											; (Puntero_objeto).
	db 0,0,0										; (Coordenada_X) / (Coordenada_Y) / (CTRL_DESPLZ).

	db %00000000 									; (Attr).

	defw 0											; (Indice_Sprite_der).
	defw 0											; (Indice_Sprite_izq).
	defw 0											; (Puntero_DESPLZ_der).
	defw 0											; (Puntero_DESPLZ_izq).

	defw 0											; (Posicion_inicio).
	db 0											; (Cuad_objeto).

	db 0,0,0,0										; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw 0,0					 					; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).									  

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).

; ---------- ---------- ---------- ---------- ----------	

Entidad_2 db 2,2		                            ; (Filas) / (Columns).
	defw 0                                          ; (Posicion_actual).
	defw 0											; (Puntero_objeto).
	db 0,0,0										; (Coordenada_X) / (Coordenada_Y) / (CTRL_DESPLZ).

	db %00000010									; (Attr).

	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw 0											; (Puntero_DESPLZ_der).
	defw 0											; (Puntero_DESPLZ_izq).

	defw $477e                                      ; (Posicion_inicio).
	db 2											; (Cuad_objeto).

	db 2,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0											; Variables_de_borrado 
	defw 0										 	;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw Indice_mov_Escaloncitos_izquierda_abajo,0  ; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).									  

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).

; ---------- ---------- ---------- ---------- ----------	

Entidad_3 db 2,2                                 	; (Filas) / (Columns).
	defw 0                                          ; (Posicion_actual).
	defw 0											; (Puntero_objeto).
	db 0,0,0										; (Coordenada_X) / (Coordenada_Y) / (CTRL_DESPLZ).

	db %00000100									; (Attr).

	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).

	defw 0											; (Puntero_DESPLZ_der).
	defw 0											; (Puntero_DESPLZ_izq).

	defw $47a1                                      ; (Posicion_inicio).
	db 1											; (Cuad_objeto).

	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0											; Variables_de_borrado 
	defw 0										 	;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw Indice_mov_Onda_senoidal,0					; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).								  

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).

; ---------- ---------- ---------- ---------- ----------

Entidad_4 db 2,2                                  	; (Filas) / (Columns).
	defw 0                                          ; (Posicion_actual).
	defw 0 											; (Puntero_objeto).
	db 0,0,0										; (Coordenada_X) / (Coordenada_Y) / (CTRL_DESPLZ).

	db %00000001									; (Attr).

	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	
	defw 0											; (Puntero_DESPLZ_der).
	defw 0											; (Puntero_DESPLZ_izq).

	defw $47be                                      ; (Posicion_inicio).
	db 0											; (Cuad_objeto).

	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0											; Variables_de_borrado 
	defw 0										 	;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw Indice_mov_Izquierda,0                     ; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).							  

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).
