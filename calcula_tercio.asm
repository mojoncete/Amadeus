; ******************************************* Indica el tercio de pantalla en el que nos encontramos según el valor del registro H ********************************************************
; 
;	NOTA: Entrega "0", "1" o "2" en A en función del tercio en el que nos encontremos.
;
; *****************************************************************************************************************************************************************************************
; 010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  

calcula_tercio ld a,h 									
	and $18
	sra a
	sra a
	sra a
	ret
