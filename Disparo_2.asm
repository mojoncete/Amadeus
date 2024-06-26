Colision_Entidad_Amadeus

; Posible contacto de entidad con Amadeus. ?????

	ld a,(Coordenada_y)
	cp $14
	ret c

; -------------------------------------------------------------------------------------------------------------
;
;   25/06/24
;   
;   La entidad se encuentra en la fila $14,$15 o $16 de pantalla.
;   Vamos a comprobar si la entidad ocupa alguna de las columnas ocupadas por Amadeus y por lo_
;   _ tanto, existe riesgo alto de colisión entre ambas. 
;
;   MODIFICA: HL,DE,BC y A.
;   OUTPUTS: (Coordenadas_X_Entidad) y (Coordenadas_X_Amadeus) contienen el nº de las columnas que ocupan en pantalla.
;            (Impacto) se coloca a "1" si coincide alguna de las columnas. Alto riesgo de colisión.

Genera_coordenadas_X

;   Guardamos las coordenadas_X de la entidad y Amadeus en sus correspondientes almacenes.
;   DRAW tiene almacenados, en este momento, los datos de la última ENTIDAD que hemos desplazado.

;   Limpiamos almacenes.

;    call Limpia_Coordenadas_X

;   Almacenamos las coordenadas X de la entidad peligrosa, (en curso).

    ld hl,Coordenadas_X_Entidad
    ld a,(Coordenada_X)
    call Guarda_coordenadas_X

;   Almacenamos las coordenadas X de Amadeus.

    ld a,(CX_Amadeus)
    call Guarda_coordenadas_X
    call Compara_coordenadas_X
    ret nz

    ld a,1                                               ; El .db (Impacto)="1" indica que es altamente probable que esta_
    ld (Impacto),a                                       ; _ entidad colisione con Amadeus, (ha superado, o está en la fila $14) y 
    ld hl,Impacto2                                       ; _ alguna de las columnas_X que ocupa coinciden con las de Amadeus.
    set 2,(hl)

    ret

 ; ----- ----- ----- ----- -----

Guarda_coordenadas_X ld (hl),a
    inc a
    inc l
    ld (hl),a
    inc a
    inc l
    ld (hl),a
    inc l
    ret

Limpia_Coordenadas_X xor a
    ld b,6
    ld hl,Coordenadas_X_Amadeus
1 ld (hl),a
    inc hl
    djnz 1B
    ret

; ----- ----- ----- ----- -----

Compara_coordenadas_X 

    ld ix,Coordenadas_X_Entidad
    ld a,(ix+0)
    call Comparando
    ret z

    inc a
    call Comparando_1
    ret z

    inc a
    call Comparando_1
    ret

; ----- ----- ----- ----- -----
;
;   4/12/23
;
;   Sub. de [Compara_coordenadas_X]. Deja de comparar cuando encuentra coincidencia.

Comparando 

    inc ixl
    inc ixl
    inc ixl

    ld b,(ix+0)
    ld c,(ix+1)
    ld d,(ix+2)

Comparando_1 cp b
    ret z
    cp c
    ret z
    cp d
    ret

; -----------------------------------------------------------------------
;
;   7/12/23
;   

Detecta_colision_nave_entidad 

; LLegados a este punto, los datos que contiene DRAW son los de Amadeus.

    di
    jr $
    ei

    ld iy,(Puntero_objeto)
    ld hl,(Puntero_de_impresion)

    push hl

; ----- ----- -----
    ld e,0                                         ; Indica impacto.
    ld b,10
2 call Bucle_3                                     ; Comprobamos el 1er scanline.
    ld a,e
    cp 5                                           ;! Ajusta sensibilidad del impacto "Amadeus-Entidad".
    jr c,3F

; LLegados a este punto:
;
;   HAY COLISIÓN !!!!!.
;
;   .db (Impacto) de Amadeus a "1".
;   SET el bit3 de (Impacto2).
;
;   Nota: El .db (Impacto) de la entidad implicada lo puso a "1" la rutina [Compara_coordenadas_X]. 

    ld hl,Impacto
    ld (hl),1                                      
    ld hl,Impacto2                                 ; Cuando se produce Colisión, RES el bit2 de (Impacto2) y_
    res 2,(hl)                                     ; _ SET el bit3. El bit3 de (Impacto2) indica que hay contacto_
    set 3,(hl)                                     ; _  entre una entidad y Amadeus.

    jr 1F

; -----

3 pop hl
    call NextScan
    push hl
    ld a,h                                         ; El 1er scanline de la bala se pinta en pantalla.
    cp $58                                         ; El 2º scanline indica colisión porque entra en zona_
    jr z,1F                                        ; _ de atributos. Evitamos comprobar colisión en el _
    jr nc,1F
;                                                  ; _ 2º scanline si esto es así.    
    djnz 2B

; Aqui tengo que fabricar una rutina que ponga a "0" el .db (Impacto) de la entidad implicada.

; LLegados a este punto:
;
;   NO HAY COLISIÓN !!!!!.
;
;   .db (Impacto) de Amadeus a "0".
;   RES el bit2 de (Impacto2).
;
;   Nota: El .db (Impacto) de la entidad implicada lo puso a "1" la rutina [Compara_coordenadas_X]. 
;   Lo colocamos a "0".

    ld hl,Impacto2                                 
    res 2,(hl)                                     
    ld hl,(Entidad_sospechosa_de_colision)
    ld (hl),0

1 pop hl                                           ; Puntero de impresión en HL e indicador de Impacto en B.
    ret                                            

 ; ---------- ----------

Bucle_3 push bc                                    ; guardamos el contador de scanlines en la pila.
    ld a,(Columns)
    ld b,a 
2 ld a,(iy)
    cp (hl)
    jr z,1F

    inc e

1 inc hl
    inc iy
    djnz 2B
    pop bc
    ret                                   