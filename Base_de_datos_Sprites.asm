
; Base de datos de entidades e Índice.
;
; 05/11/22

Indice_de_entidades	

	defw Badsat
;	defw Badsat2
;	defw Badsat3
;	defw Badsat4
	defw Amadeus_db
;	...
;	...
;	+ entidades ...

	defw 0
	defw 0

; ---------- ---------- ---------- ---------- ----------

Amadeus_db db 2,2
	defw 0
	db 0

	db %00000101
	defw Indice_Amadeus
	defw 0
	defw $50cf
	db 0,0,0

	db 2,2,0,0

	db 0,0
	defw 0
	db 0	
	db 0,0
	defw 0
	db 0	

	db 0,0

	defw 0,0
	db 0,0,0

	defw 0
	defw 0
	db 0
	defw 0
	db 0

	defw 0,0

; ---------- ---------- ---------- ---------- ----------

Badsat db 2,2
	defw 0
	db 0

	db %00000110
	defw Indice_Badsat_der
	defw 0
	defw $47a1	
	db 0,0,0

	db 1,1,1,2

	db 0,0
	defw 0
	db 0	
	db 0,0
	defw 0
	db 0	

	db 0,0

	defw Indice_mov_Badsat,0
	db 0,0,0										  ; 50 Bytes de información por Sprite. 

	defw 0
	defw 0
	db 0
	defw 0
	db 0

	defw 0,0

; ---------- ---------- ---------- ---------- ----------	

Badsat2 db 2,2		                                  ; Filas/Columns
	defw 0                                            ; Posicion_actual
	db 0                                              ; CTRL_DESPLZ

	db %00000010
	defw Indice_Badsat_izq	                          ; Indice_Sprite
	defw 0                                            ; Puntero_DESPLZ
	defw $4761                                        ; Posicion_inicio
	db 0,0,0

	db 1,1,1,1                                        ; Vel_right, left, up, down.

	db 0,0
	defw 0
	db 0	
	db 0,0
	defw 0
	db 0	

	db 0,0

	defw Indice_mov_Badsat2,0                         ; Puntero_indice_mov / Puntero_mov.
	db 0,0,0										  ; 50 Bytes de información por Sprite. 

	defw 0
	defw 0
	db 0
	defw 0
	db 0

	defw 0,0

; ---------- ---------- ---------- ---------- ----------	

Badsat3 db 2,2                                 		  ; Filas/Columns
	defw 0                                            ; Posicion_actual
	db 0                                              ; CTRL_DESPLZ

	db %00000100
	defw Indice_Badsat_izq                            ; Indice_Sprite
	defw 0                                            ; Puntero_DESPLZ
	defw $477e                                        ; Posicion_inicio
	db 0,0,0

	db 1,1,1,1                                        ; Vel_right, left, up, down.

	db 0,0
	defw 0
	db 0	
	db 0,0
	defw 0
	db 0	

	db 0,0

	defw Indice_mov_Badsat3,0                        ; Puntero_indice_mov / Puntero_mov.
	db 0,0,0										  ; 50 Bytes de información por Sprite. 

	defw 0
	defw 0
	db 0
	defw 0
	db 0

	defw 0,0

; ---------- ---------- ---------- ---------- ----------

Badsat4 db 2,2                                  	  ; Filas/Columns
	defw 0                                            ; Posicion_actual
	db 0                                              ; CTRL_DESPLZ

	db %00000001
	defw Indice_Badsat_izq                            ; Indice_Sprite
	defw 0                                            ; Puntero_DESPLZ
	defw $47be                                        ; Posicion_inicio
	db 0,0,0

	db 1,1,1,1                                        ; Vel_right, left, up, down.

	db 0,0
	defw 0
	db 0	
	db 0,0
	defw 0
	db 0	

	db 0,0

	defw Indice_mov_Badsat4,0                        ; Puntero_indice_mov / Puntero_mov.
	db 0,0,0										  ; 50 Bytes de información por Sprite. 

	defw 0
	defw 0
	db 0
	defw 0
	db 0

	defw 0,0
