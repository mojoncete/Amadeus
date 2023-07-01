
; Cajas de DRAW y disparos. Índices de disparos y cajas. 

; 13/05/23

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

Indice_de_cajas										; 64 Bytes por entidad.

	defw Caja_1
	defw Caja_2
	defw Caja_3
	defw Caja_4
	defw Caja_5
	defw Caja_6
	defw Caja_7
	defw Caja_8
	defw Caja_9
	defw Caja_10
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0											; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db $40,0										; (Ctrl_0) / (Obj_dibujado).

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------

Caja_1 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------	

Caja_2 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------	

Caja_3 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------

Caja_4 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------

Caja_5 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).
							  
	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------

Caja_6 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).
							  
	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------	

Caja_7 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------	

Caja_8 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).
						  
	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------

Caja_9 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).
						  
	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; ---------- ---------- ---------- ---------- ----------

Caja_10 db 0,0										; (Filas) / (Columns).
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

	db 0											; Impacto. "1" existe impacto en la entidad.

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado)

	db 0											; (Autoriza_movimiento).
	defw 0,0	 									; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_desplazamiento).
	db 0											; (Repetimos_desplazamiento_backup)
	db 0											; (Cola_de_desplazamiento).
							  
	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0,0,0										; (Limite_vertical), (Ctrl_2), (Frames_explosion).

; -------------------------------------------------------------------------------------
;
;	20/05/23
;
;	TIPOS de "Entidades maliciosas". Quieren conquistar la Tierra.	
;
	;	Notas de funcionamiento: (Cuad_objeto) siempre será "1" independientemente de su (Posicion_inicio).
	;		De no ser así, la rutina [Recompone_posicion_inicio] generará problemas a la hora de hacer que_
	;		_ la entidad aparezca `al píxel', por la parte derecha de la pantalla. Esto se debe a como están_
	;		_ construidas las rutinas [Mov_right] y [Mov_left].

Indice_de_entidades

	defw Entidad_1
	defw Entidad_2
	defw Entidad_3
	defw Entidad_4
	defw Entidad_5

;	BADSAT, (Satélite malvado).	

Entidad_1 db 2,2		                     		; (Filas) / (Columns).
	db %00000100									; (Attr).
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $4003	                             	    ; (Posicion_inicio).
	db 1											; (Cuad_objeto).
	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).
	defw Indice_mov_Baile_de_BadSat					; (Puntero_indice_mov) 

Entidad_2 db 2,2		                     		; (Filas) / (Columns).
	db %00000010									; (Attr).
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $5040                                      ; (Posicion_inicio).
	db 1											; (Cuad_objeto).
	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).
	defw Indice_mov_Baile_de_BadSat				    ; (Puntero_indice_mov) 

Entidad_3 db 2,2		                     		; (Filas) / (Columns).
	db %00000100									; (Attr).
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $47a0                                      ; (Posicion_inicio).
	db 1											; (Cuad_objeto).
	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).
	defw Indice_mov_Baile_de_BadSat					; (Puntero_indice_mov)

Entidad_4 db 2,2		                     		; (Filas) / (Columns).
	db %00000001									; (Attr).
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $47bf                                      ; (Posicion_inicio).
	db 1											; (Cuad_objeto).
	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).
	defw Indice_mov_Baile_de_BadSat					; (Puntero_indice_mov)

Entidad_5 db 2,2		                     		; (Filas) / (Columns).
	db %00000001									; (Attr).
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $4007                                      ; (Posicion_inicio).
	db 1											; (Cuad_objeto).
	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).
	defw Indice_mov_Baile_de_BadSat					; (Puntero_indice_mov)
