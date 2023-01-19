
; Base de datos de entidades e Índice.
;
; 05/11/22

Indice_de_entidades									 ; 58 Bytes por entidad.

	defw Badsat
	defw Badsat2
	defw Badsat3
	defw Badsat4
	defw Amadeus_db
;	...
;	...
;	+ entidades ...

	defw 0
	defw 0

; ---------- ---------- ---------- ---------- ----------

Amadeus_db db 2,2									; (Filas) / (Columns).
	defw 0 											; (Posicion_actual).
	defw 0 											; (Puntero_objeto).
	db 0,0,0										; (CTRL_DESPLZ) / (Coordenada_X) / (Coordenada_Y).

	db %00000101									; (Attr).
	defw Indice_Amadeus								; (Indice_Sprite).		
	defw 0	 										; (Puntero_DESPLZ).
	defw $50cf										; (Posicion_inicio).
	db 0 											; (Cuad_objeto).

	db 2,2,0,0										; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0											; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw 0,0 										; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).
	defw 0,0,0										; (Puntero_store_entidades) / (Puntero_restore_entidades) / (Indice_restore).
	
; ---------- ---------- ---------- ---------- ----------

Badsat db 2,2										; (Filas) / (Columns).
	defw 0											; (Posicion_actual).
	defw 0 											; (Puntero_objeto).
	db 0,0,0 									    ; (CTRL_DESPLZ) / (Coordenada_X) / (Coordenada_Y).

	db %00000110 									; (Attr).
	defw Indice_Badsat_der							; (Indice_Sprite).
	defw 0											; (Puntero_DESPLZ).
	defw $47a1										; (Posicion_inicio).
	db 0											; (Cuad_objeto).

	db 1,1,1,2										; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0										    ; Variables_de_borrado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw Indice_mov_Badsat,0 						; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).									  

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).
	defw 0,0,0										; (Puntero_store_entidades) / (Puntero_restore_entidades) / (Indice_restore).

; ---------- ---------- ---------- ---------- ----------	

Badsat2 db 2,2		                                ; (Filas) / (Columns).
	defw 0                                          ; (Posicion_actual).
	defw 0											; (Puntero_objeto).
	db 0,0,0                                        ; (CTRL_DESPLZ) / (Coordenada_X) / (Coordenada_Y).

	db %00000010									; (Attr).
	defw Indice_Badsat_der	                        ; (Indice_Sprite).
	defw 0                                          ; (Puntero_DESPLZ).
	defw $4761                                      ; (Posicion_inicio).
	db 0											; (Cuad_objeto).

	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0											; Variables_de_borrado 
	defw 0										 	;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw Indice_mov_Badsat2,0                       ; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).									  

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).
	defw 0,0,0										; (Puntero_store_entidades) / (Puntero_restore_entidades) / (Indice_restore).

; ---------- ---------- ---------- ---------- ----------	

Badsat3 db 2,2                                 		; (Filas) / (Columns).
	defw 0                                          ; (Posicion_actual).
	defw 0											; (Puntero_objeto).
	db 0,0,0                                        ; (CTRL_DESPLZ) / (Coordenada_X) / (Coordenada_Y).

	db %00000100									; (Attr).
	defw Indice_Badsat_izq                          ; (Indice_Sprite).
	defw 0                                          ; (Puntero_DESPLZ).
	defw $477e                                      ; (Posicion_inicio).
	db 0											; (Cuad_objeto).

	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0											; Variables_de_borrado 
	defw 0										 	;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw Indice_mov_Badsat3,0                       ; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).								  

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).
	defw 0,0,0										; (Puntero_store_entidades) / (Puntero_restore_entidades) / (Indice_restore).

; ---------- ---------- ---------- ---------- ----------

Badsat4 db 2,2                                  	; (Filas) / (Columns).
	defw 0                                          ; (Posicion_actual).
	defw 0 											; (Puntero_objeto).
	db 0,0,0                                        ; (CTRL_DESPLZ) / (Coordenada_X) / (Coordenada_Y).

	db %00000001									; (Attr).
	defw Indice_Badsat_izq                          ; (Indice_Sprite).
	defw 0                                          ; (Puntero_DESPLZ).
	defw $47be                                      ; (Posicion_inicio).
	db 0											; (Cuad_objeto).

	db 1,1,1,1                                      ; (Vel_left) / (Vel_right) / (Vel_up) / (Vel_down).

	db 0,0											; Variables_de_borrado 
	defw 0										 	;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; Variables_de_pintado 
	defw 0											;	" " " " " " "
	defw 0											;	" " " " " " "
	db 0,0,0										;	" " " " " " "

	db 0,0											; (Ctrl_0) / (Obj_dibujado).

	defw Indice_mov_Badsat4,0                       ; (Puntero_indice_mov) / (Puntero_mov).
	db 0,0,0										; (Contador_db_mov) / (Incrementa_puntero) / (Repetimos_db).							  

	db 0 											; (Columnas).									
	defw 0											; (Limite_horizontal).
	db 0											; (Limite_vertical).
	defw 0,0,0										; (Puntero_store_entidades) / (Puntero_restore_entidades) / (Indice_restore).