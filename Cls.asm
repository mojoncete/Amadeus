; *********************************** Limpia la pantalla, CLEAR SCREEN ****************************************************************
;
; 
;	CLS.
;
;	Limpia la pantalla y define sus atributos. 
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
;
;	INPUT: A contiene los atributos de pantalla.
;
;	DESTRUIDOS: F,BC,DE,HL !!!!!


Cls LD HL,$4000											; HL => Comienzo de pantalla.
	LD DE,$4001
	LD BC,6144											; Tamaño de la pantalla, $17ff
	LD (HL),0 											; Ponemos a "0" todos los pixels de la pantalla.
	LDIR
	LD BC,767
	LD (HL),a						 					; Atributos de pantalla, % 00 xxx xxx en [A].
	LDIR
	ret
