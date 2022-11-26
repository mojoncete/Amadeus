
; Base de datos de entidades e Índice.
;
; 05/11/22

Indice_de_entidades	defw Coracao_db
	defw Coracao2_db
	defw Amadeus_db

;	defw Coracao3_db
;	defw Coracao4_db
;	defw Amadeus_db
;	...
;	...
;	+ entidades ...

	defw 0
	defw 0

; ---------- ---------- ---------- ---------- ----------

Amadeus_db db 3,3
	defw 0
	db 0

	db %00000101
	defw Indice_Amadeus
	defw 0
	defw $50af
	db 0,0,0

	db 4,4,0,0

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

Coracao_db db 2,2
	defw 0
	db 0

	db %00000110
	defw Indice_Coracao
	defw 0
	defw $47a1	
	db 0,0,0

	db 4,4,4,6

	db 0,0
	defw 0
	db 0	
	db 0,0
	defw 0
	db 0	

	db 0,0

	defw Indice_mov_coracao,0
	db 0,0,0										  ; 50 Bytes de información por Sprite. 

	defw 0
	defw 0
	db 0
	defw 0
	db 0

	defw 0,0

; ---------- ---------- ---------- ---------- ----------	

Coracao2_db db 2,2                                    ; Filas/Columns
	defw 0                                            ; Posicion_actual
	db 0                                              ; CTRL_DESPLZ

	db %00000010
	defw Indice_Coracao                               ; Indice_Sprite
	defw 0                                            ; Puntero_DESPLZ
	defw $4761                                        ; Posicion_inicio
	db 0,0,0

	db 4,4,4,4                                        ; Vel_right, left, up, down.

	db 0,0
	defw 0
	db 0	
	db 0,0
	defw 0
	db 0	

	db 0,0

	defw Indice_mov_coracao2,0                        ; Puntero_indice_mov / Puntero_mov.
	db 0,0,0										  ; 50 Bytes de información por Sprite. 

	defw 0
	defw 0
	db 0
	defw 0
	db 0

	defw 0,0

; ---------- ---------- ---------- ---------- ----------	

Coracao3_db db 2,2                                    ; Filas/Columns
	defw 0                                            ; Posicion_actual
	db 0                                              ; CTRL_DESPLZ

	db %00000100
	defw Indice_Coracao                               ; Indice_Sprite
	defw 0                                            ; Puntero_DESPLZ
	defw $477e                                        ; Posicion_inicio
	db 0,0,0

	db 4,4,4,4                                        ; Vel_right, left, up, down.

	db 0,0
	defw 0
	db 0	
	db 0,0
	defw 0
	db 0	

	db 0,0

	defw Indice_mov_coracao3,0                        ; Puntero_indice_mov / Puntero_mov.
	db 0,0,0										  ; 50 Bytes de información por Sprite. 

	defw 0
	defw 0
	db 0
	defw 0
	db 0

	defw 0,0

; ---------- ---------- ---------- ---------- ----------

Coracao4_db db 2,2                                    ; Filas/Columns
	defw 0                                            ; Posicion_actual
	db 0                                              ; CTRL_DESPLZ

	db %00000001
	defw Indice_Coracao                               ; Indice_Sprite
	defw 0                                            ; Puntero_DESPLZ
	defw $47be                                        ; Posicion_inicio
	db 0,0,0

	db 4,4,4,4                                        ; Vel_right, left, up, down.

	db 0,0
	defw 0
	db 0	
	db 0,0
	defw 0
	db 0	

	db 0,0

	defw Indice_mov_coracao4,0                        ; Puntero_indice_mov / Puntero_mov.
	db 0,0,0										  ; 50 Bytes de información por Sprite. 

	defw 0
	defw 0
	db 0
	defw 0
	db 0

	defw 0,0
