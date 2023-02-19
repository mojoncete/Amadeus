; ******************************************************************************************************************************************************************************************
;
;   19/02/23
;
; 	Calcula la dirección de memoria de pantalla donde se va a iniciar el disparo, (se aplica a_)
;   _entidades y Amadeus).

Genera_disparo 

;   Esta parte de la rutina se encarga de `RETORNAR' sin generar disparo cuando (CTRL_DESPLZ)_
;   _ tenga valores distintos de $00, $f9, $fb y $fd.
;   Amadeus al desplazarse a 2 pixels, podrá generar disparo en cualquier situación.
;   IY contendrá la dirección de Puntero_objeto_disparo. 

    ld hl,Indice_disparo
    ld a,(CTRL_DESPLZ)
    ld c,a
    and a
    jr z,1F
    and 1        
    ret z
    ld b,$f9
    ld a,c

2 inc hl
    inc hl
    cp b
    jr z,1F
    inc b
    inc b
    jr 2B

1 call Extrae_address
    push hl
    pop iy

; -----------------------------------------------------------------
 
    ld a,(Cuad_objeto)
    cp 2
    jr c,3F
    jr z,3F

; Estamos en mitad inferior de pantalla, (cuadrantes 3 y 4).

    and 1
    jr z,4F

; Estamos en el 3er cuadrante de pantalla.

    jr $

; Estamos en el 4º cuadrante de pantalla.

4 jr $

; Estamos en la mitad superior de pantalla, (cuadrantes 1 y 2).

3 jr z,5F

; 1er CUAD. ----- ----- ----- ----- -----
;
;	En el 1er y 2º cuadrante de pantalla, sólo cabe la posibilidad de que sea una entidad la que dispare,_
;	_ por lo tanto siempre se iniciara el disparo en la parte `baja´ del sprite.
;   La dirección del proyectil siempre será hacia abajo. En los cuadrante 1º y 2º no se comprueba colision_
;   _ pues sabemos que Amadeus sólo puede estar situado en los cuadrantes 3º y 4º.

	ld hl,(Posicion_actual)
	call NextScan

; Ahora HL apunta una FILA por debajo de (Posicion_actual).

    ld a,(Columnas)
    ld b,a
    cp 1
    jr z,7F
    dec hl
7 push hl
    pop ix                                          ; IX contiene el puntero de impresión.

; ----- ----- ----- ----- 

    dec b
    jr z,8F
    ld hl,Pinta_Amadeus_2x2
    jr 9F

8 ld hl,Pinta_enemigo_2x2_izquierda
9 push hl
    pop de                                          ; DE contiene la dirección de la rutina de impresión.
    ld hl,0                                         ; Impacto,(H)="0". Dirección,(L)="0".
    call Guarda_disparo_en_archivo
    jr 6F                                           ; RET.


; Estamos en el 2º cuadrante de pantalla.

5 jr $ 

6 ret

; -------------------------------------------------------------------------------------------------

Guarda_disparo_en_archivo jr $
    ret