; ******************************************************************************************************************************************************************************************
;
;   16/02/23
;
;	
;
; 	Calcula la dirección de memoria de pantalla donde se va a iniciar el disparo, (se aplica a_)
;   _entidades y Amadeus).

Calcula_punto_de_disparo_inicial

    ld a,(Cuad_objeto)
    cp 2
    jr c,1F
    jr z,1F

; Estamos en mitad inferior de pantalla, (cuadrantes 3 y 4).

    and 1
    jr z,2F

; Estamos en el 3er cuadrante de pantalla.

    jr $

; Estamos en el 4º cuadrante de pantalla.

2 jr $

; Estamos en la mitad superior de pantalla, (cuadrantes 1 y 2).

1 jr z,3F

; Estamos en el 1er cuadrante de pantalla.

    jr $

; Estamos en el 2º cuadrante de pantalla.

3 jr $ 

10 ret
