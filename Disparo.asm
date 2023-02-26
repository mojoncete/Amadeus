; ******************************************************************************************************************************************************************************************
;
;   19/02/23
;
; 	La rutina determina si es factible, o no, `generar' un disparo.
;   En el caso de generar disparo la rutina proporciona 4 variables:
;
;
;       -1 .defw ..... Control. %00000001 00000001 
;
;           [Bit0] ..... Dirección. "1" Cuando dispara Amadeus, (hacia arriba), "0" cuando lo_
;               _ hacen las entidades hacia abajo.
;
;           [Bit8] ..... Impacto. "1" Cuando se produce colisión al generar un disparo.
;
;       - 2 .defw ..... Direccíón de memoria de la rutina que imprime el disparo en pantalla.
;           Siempre será la misma: [Pinta_Amadeus_2x2].
;
;       - 3 .defw ..... Puntero de impresión. Dirección de pantalla donde empezamos a pintar_
;           _ la bala.
;
;       - 4 .defw ..... Puntero_objeto_disparo. Dirección donde se encuentran los .db que pintan_
;           _ la bala. El Sprite de la bala consta de 2 columnas y 2 scanlines. Una vez que se_
;           _ genera el proyectil esta dirección permanece inalterable. Esta dirección puede tener_
;           _ 4 valores distintos, ((el valor dependerá del que tenga la variable (CTRL_DESPLZ)_
;           _ en el momento de generarse la bala)).

Genera_disparo 

;   Esta parte de la rutina se encarga de `RETORNAR' sin generar disparo cuando (CTRL_DESPLZ)_
;   _ tenga valores distintos de $00, $f9, $fb y $fd.
;   NO SE GENERA disparo cuando la entidad no está impresa en su totalidad en pantalla, (está_
;   _ apareciendo o desapareciendo). (Columns)<>(Columnas).
;   Amadeus al desplazarse a 2 pixels, podrá generar disparo en cualquier situación pero las Entidades_
;   _ sólo podran generar disparo cuando (CTRL_DESPLZ) tenga dichos valores.
;   IY contendrá la dirección de Puntero_objeto_disparo. 

    ld a,(Columnas)
    ld b,a
    ld a,(Columns)
    cp b
    ret nz                              ; Salimos si la entidad no está completa en pantalla.                           

    ld hl,Indice_disparo
    ld a,(CTRL_DESPLZ)
    ld c,a
    and a
    jr z,1F
    and 1        
    ret z                               ; Salimos si (CTRL_DESPLZ) es distinto de $00, $f9, $fb y $fd.
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
    pop iy                              ; Puntero_objeto_disparo en IY.
    ld ix,Pinta_Amadeus_2x2             ; Rutinas_de_impresion en IX.

; --------------- ---------------- ----------------- -------------
;
;   Genera disparo.
;
;   Generamos variables de disparo. Varían en función del cuadrante en el que nos encontramos.

    ld a,(Cuad_objeto)
    cp 2
    jr c,3F
    jr z,3F

; Estamos en mitad inferior de pantalla, (cuadrantes 3 y 4).

    and 1
    jr z,4F

; Estamos en el 3er cuadrante de pantalla.
; 3er CUAD. ----- ----- ----- ----- -----
;
;	En el 3er y 4º cuadrante de pantalla, cabe la posibilidad de que sea una entidad o Amadeus el que dispara.
;	En función del elemento que dispare variara el Puntero_de_impresión y su `Dirección'.
;   En estos cuadrantes también es posible que se genere `Colisión', hay que comprobarlo.

	ld hl,(Posicion_actual)

;   Compruebo si el disparo lo efectúa Amadeus o una entidad para poder calcular el puntero de impresión.

    ld a,(Ctrl_0)
    bit 6,a
    jr z,8F

; Dispara Amadeus.

    ld c,1                                          ; Dirección "1", hacia arriba.                        
    call PreviousScan
    call PreviousScan
    dec hl                                          ; Puntero de impresión en HL.                                       
    jr 10F

; Dispara Entidad.

8 ld c,0                                            ; Dirección "0", hacia abajo.
    ld b,16
9 call NextScan
    djnz 9B

; Ahora HL apunta una FILA por debajo de (Posicion_actual).

    dec hl                                          ; Puntero de impresión en HL.
10 call Comprueba_Colision                          ; Retorna "1" o "0" en B indicando si se produce Colisión
;                                                   ; _al generar el disparo.

; LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

    call Almacena_disparo                      
    jr 6F                                           ; RET.
    

; Estamos en el 4º cuadrante de pantalla.
; 4º CUAD. ----- ----- ----- ----- -----
;
;	En el 3er y 4º cuadrante de pantalla, cabe la posibilidad de que sea una entidad o Amadeus el que dispara.
;	En función del elemento que dispare variara el Puntero_de_impresión y su `Dirección'.
;   En estos cuadrantes también es posible que se genere `Colisión', hay que comprobarlo.

4 ld hl,(Posicion_actual)

;   Compruebo si el disparo lo efectúa Amadeus o una entidad para poder calcular el puntero de impresión.

    ld a,(Ctrl_0)
    bit 6,a
    jr z,11F

; Dispara Amadeus.

    ld c,1                                          ; Dirección "1", hacia arriba.                        
    call PreviousScan
    call PreviousScan
    jr 14F
 
; Dispara Entidad.

11 ld c,0                                            ; Dirección "0", hacia abajo.
    ld b,16
12 call NextScan
    djnz 12B

; Ahora HL apunta una FILA por debajo de (Posicion_actual).

14 ld a,(CTRL_DESPLZ)
    and a
    jr z,13F
    dec hl                                          ; Puntero de impresión en HL.
13 call Comprueba_Colision                          ; Retorna "1" o "0" en B indicando si se produce Colisión
;                                                   ; _al generar el disparo.

; LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

    call Almacena_disparo                      
    jr 6F                                           ; RET.

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

    dec hl                                          ; Puntero de impresión en HL.
    ld bc,0                                         ; Impacto,(B)="0". Dirección,(C)="0".

; LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

    call Almacena_disparo                      
    jr 6F                                           ; RET.

; Estamos en el 2º cuadrante de pantalla.
; 2º CUAD. ----- ----- ----- ----- -----
;
;	En el 1er y 2º cuadrante de pantalla, sólo cabe la posibilidad de que sea una entidad la que dispare,_
;	_ por lo tanto siempre se iniciara el disparo en la parte `baja´ del sprite.
;   La dirección del proyectil siempre será hacia abajo. En los cuadrante 1º y 2º no se comprueba colision_
;   _ pues sabemos que Amadeus sólo puede estar situado en los cuadrantes 3º y 4º.

5 ld hl,(Posicion_actual)
	call NextScan

; Ahora HL apunta una FILA por debajo de (Posicion_actual).

    ld a,(CTRL_DESPLZ)
    and a
    jr z,7F
    dec hl
7 ld bc,0                                         ; Impacto,(B)="0". Dirección,(C)="0".

; LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

    call Almacena_disparo                      

; Preparamos registros para llamar a [Guarda_foto_registros].

6 

;    push ix
;    pop hl
;    push af
;    pop ix


;    call Guarda_foto_registros

;    jr $

    ret

; ----------------------------------------------------------------
;
;   25/02/23
;
;   La Rutina va almacenando disparos en sus respectivas bases de datos.
;   Amadeus dispone de 2 disparos mientras que las entidades disponen de un máximo de 10.

Almacena_disparo 

    push hl                                                                             
    pop af                                          
    ex af,af                                        ; Puntero_de_impresion en AF'.

3 inc c
    dec c
    jr z,1F                                         ; Según la `Dirección' del proyectil sabemos si_
;                                                   ; _ es Amadeus o una entidad la que dispara.    

; Dispara AMADEUS.

    push bc
    ld bc,Indice_de_disparos_Amadeus+4              ; Disparo_3A
    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)
    and a
    sbc hl,bc
    call z,Inicia_Puntero_Disparo_Amadeus
    pop bc
    jr z,4F

    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)
    inc hl
    inc hl
    ld (Puntero_DESPLZ_DISPARO_AMADEUS),hl          ; (Puntero_DESPLZ_DISPARO_AMADEUS) ya apunta al siguiente_
;                                                   ; _ Disparo_(+1).        
    jr 2F

; Dispara una entidad.

1 push bc
    ld bc,Indice_de_disparos_entidades+20           ; Disparo_11
    ld hl,(Puntero_DESPLZ_DISPARO_ENTIDADES)
    and a
    sbc hl,bc
    call z,Inicia_Puntero_Disparo_Entidades
    pop bc
    jr z,4F

    ld hl,(Puntero_DESPLZ_DISPARO_ENTIDADES)
    inc hl
    inc hl
    ld (Puntero_DESPLZ_DISPARO_ENTIDADES),hl        ; El (Puntero_DESPLZ_IND_DISPARO) ya apunta al siguiente_
;                                                   ; _ Disparo_(+1).        
2 call Extrae_address                               ; HL contiene la dirección donde vamos a almacenar_
;                                                   ; _ los 8 bytes que definen el disparo:                                                  
;
;                                                     Puntero_objeto_disparo en IY.
;                                                     Rutinas_de_impresion en IX.
;                                                     Puntero_de_impresion en HL.
;                                                     Impacto/Dirección en BC. 

    dec hl                                          ; Esta parte de la rutina comprueba si este_
    ld a,(hl)                                       ; _ almacén de disparo está vacio. Si no es así, saltamos_
    inc hl                                          ; _ al siguiente.
    and a                                           
    jr nz,3B                                         

    ex af,af
    ld (Stack),sp                                   ; Guardo SP en (Stack).)
    ld sp,hl

    push ix                                         ; Rutina de impresión.
    push af                                         ; Puntero de impresión.
    push iy                                         ; Puntero objeto.
    push bc                                         ; Control.
 
    ld sp,(Stack)

4 ret

; ----------------------------------------------------------------
;
;   20/02/23

Comprueba_Colision push hl
    ld e,0                                         ; E,(Impacto)="0".
    call Bucle_2                                   ; Comprobamos el 1er scanline.
    inc e
    dec e
    jr z,1F                                        ; Si no se produce impacto comprobamos el 2º scanline.
; Hay impacto.
2 ld b,e
    pop hl                                         ; Puntero de impresión en HL e indicador de Impacto en B.
3 ret                                            
1 pop hl
    push hl
    call NextScan
    call Bucle_2
    jr 2B

; ---------- ----------

Bucle_2 ld b,2 
2 ld a,(hl)
    and a
    jr nz,1F
    inc hl
    djnz 2B
3 ret
1 ld e,1
    jr 3B

; -------------------------------------------------------------------------------------------------------------


  

 