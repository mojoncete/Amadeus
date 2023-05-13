; 13/05/23

Indice_de_niveles

	defw Nivel_1
	defw Nivel_2
	defw Nivel_3
	defw Nivel_4
	defw Nivel_5

;	...
;	...
;	+ Niveles ...

	defw 0
	defw 0

Nivel_1 db 1,1,1,1,1 
    db 1

Nivel_2

Nivel_3

Nivel_4

Nivel_5


;---------------------------------------------------------------------------------------------------------------
;
;   13/5/23

;   Destruye HL y DE

Inicia_puntero_indice_de_niveles ld hl,Indice_de_niveles
    ld (Puntero_indice_NIVELES),hl
    call Extrae_address   
    ld (Datos_de_nivel),hl
    ret
