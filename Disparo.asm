; --------------------------------------------------------------------------------------
;
;   12/8/24
;

Genera_disparo_Amadeus

;   Exclusiones.

    ld a,(Disparo_Amadeus)
    and a
    ret z                                                    ; Salimos si el disparo de nuestra nave no está habilitado.

Define_puntero_objeto_disparo

;    dec a                                                  
;    ld (Disparo_Amadeus),a                                  ;  Deshabilita el disparo.

;   Inicializamos contador.

    ld b,0
    ld hl,(p.imp.amadeus)
    inc l

    ld a,$80
    cp (hl)
    jr z,1F

    inc b
    ld a,$60
    cp (hl)
    jr z,1F

    inc b
    ld a,$18
    cp (hl)
    jr z,1F

    inc b

;   Calcula el Puntero_de_impresión del disparo.

1 call PreviousScan
    call PreviousScan
    call PreviousScan

    ld a,b
    srl a
    jr z,4F

; --- Guarda el puntero_de_impresión del disparo en la pila.
    push hl
    jr 5F
4 dec l  
    push hl
; ---

;   Calcula el Puntero_objeto del disparo.

5 ld hl,Indice_disparo
    inc b
    dec b
    jr z,2F

;   Nos desplazamos por el índice de disparos.

3 inc l
    inc l
    djnz 3B

; --- Guarda el Puntero_objeto del disparo en la pila.
2 call Extrae_address
    push hl                               
; ---

; Almacenamos (Puntero_objeto) y (Puntero_de_impresion) en su correspondiente caja.
; HL en el 1er .db de la caja y (Puntero_DESPLZ_DISPARO_AMADEUS) avanza una posición en el índice.

    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)
    call Extrae_address

    ld b,2

6 pop de
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    djnz 6B

Detecta_impacto_en_disparo_de_Amadeus

    call Detecta_impacto_en_disparo_de_Amadeus01

    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)
    inc hl
    inc hl
    call Extrae_address
    dec hl                                               ;  Sitúa el puntero en el .db (Impacto) de la caja del disparo.
    jr z,7F
    ld a,1
7 ld (hl),a
    ret z

Genera_coordenadas_de_disparo_Amadeus

;   Esta parte de la rutina sólo aplica cuando un disparo nuestro alcanza a una entidad.
;   Genera las coordenadas de nuestro disparo certero y activa el correspondiente FLAG, (bit3 Impacto2).

    di
    jr $
    ei

    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)
    call Extrae_address
    inc hl
    inc hl

    call Extrae_address                                 ;   Puntero_de_impresión del disparo en HL.
    call Genera_coordenadas

    dec a

    ld hl,Coordenadas_disparo_certero
    ld (hl),a                                           ;   Almacenamos la Coordenada_Y, (Fila) del disparo.
    inc hl
    ld a,(Coordenada_X)                                 
    ld (hl),a                                           ;   Almacenamos la Coordenada_X, (Columna) del disparo.
    
    ld hl,Impacto2
    set 3,(hl)                                          ;   Indica que un disparo de nuestra nave ha alcanzado a una entidad.

    xor a                                               ;   Siempre "Z" cuando ejecutamos [Genera_disparo_Amadeus].
    ret

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 

; ----------------------------------------------
;
;   12/08/24
;


Detecta_impacto_en_disparo_de_Amadeus01

Extraccion_de_datos                                        

    ld hl,Indice_de_disparos_Amadeus
    call Extrae_address

    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl                                                 ;    Puntero_objeto del disparo en DE.

    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl                                                 ;    Puntero_de_impresión del disparo en BC.

    push bc 
    pop hl                                                 ;    Puntero_de_impresión del disparo en HL.

Detecta_impacto_

    ld a,(de)
    and (hl)
    ret nz

    inc de
    inc hl

    ld a,(de)
    and (hl)
    ret

; -------------------------------------------------------------------------------------------------------------
;
;   8/8/24
;   
;   La entidad se encuentra en la fila $14,$15 o $16 de pantalla.
;   Vamos a comprobar si la entidad ocupa alguna de las columnas ocupadas por Amadeus y por lo_
;   _ tanto, existe riesgo alto de colisión entre ambas. 
;
;   MODIFICA: HL,DE,BC y A.
;   OUTPUTS: (Coordenadas_X_Entidad) y (Coordenadas_X_Amadeus) contienen el nº de las columnas que ocupan en pantalla.
;            (Impacto) se coloca a "1" si coincide alguna de las columnas. Alto riesgo de colisión.

Colision_Entidad_Amadeus

; Posible contacto de entidad con Amadeus. ?????

; Exclusiones:

    ld a,(Shield)
    and a
    ret nz                                                 ; No comprobamos contacto si existe Shield.

    ld hl,Ctrl_3
    bit 6,(hl)
    ret nz                                                 ; Salimos si Amadeus ha sido destruido y estamos esperando nueva nave o mensaje final.

    ld hl,Impacto2                                         ; Salimos si tenemos una posible colisión de una entidad anterior. Tenemos almacenadas las coordenadas X de otra entidad.
    bit 2,(hl)
    ret nz

	ld a,(Coordenada_y)
	cp $14
	ret c                                                  ; Salimos si la entidad no está en zona de Amadeus.

    ld a,(Impacto_Amadeus)                                 ; Evita que se produzca colisión con dos entidades a la vez. 
    and a
    ret nz

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

    ld hl,(Puntero_store_caja)
    inc l
    inc l
    inc l
    inc l
    ld (Entidad_sospechosa_de_colision),hl               ; En caso de que no exista colisión con Amadeus hemos de poner el .db (Impacto) de la (Entidad_sospechosa_de_colision) a "0" más adelante.

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
;   04/7/24
;   

Detecta_colision_nave_entidad 

; Exclusiones:

; Salimos de la rutina si no hay advertencia de posible colisión.

	ld hl,Impacto2	
	bit 2,(hl)
	ret z

; Detección byte a byte de colisión ENTIDAD-NAVE.

    ld hl,(Pamm_Amadeus)
    call Extrae_address                            
    ld d,h
    ld e,l                                         ; (Puntero_objeto) en DE.

    ld hl,(p.imp.amadeus)                          ; (Puntero_de_impresion) en HL.
    ld b,16                                        ; Contador de scanlines en B.
    ld iyl,3                                       ; Contador de impacto. Si su valor es "0" se considera "Colisión". Esto me permitirá ajustar la sensibilidad de la colisión en Amadeus.

1 push bc
    ld b,3
    push hl

; .db

3 ld a,(de)
    and a
    jr nz,4F                                        

    inc l                                       
    jr 2F                                         ; No aplica CPI, no hay píxels en este .db.

4 cpi                                             ; Comparamos el 1er .db de los tres de ancho que tiene el sprite de Amadeus.
    jr z,2F

; Impacto.
    dec iyl
    jr z,5F

2 inc e
    djnz 3B
 
    pop hl

; Hay salto de línea en el puntero de impresión ???

    ld a,h
    sub $57
    jr nz,6F

; Comprobamos la parte baja de Amadeus. Modifico manualmente el salto de línea en HL para no haver llamadas a [NextScan].

    ld hl,(p.imp.amadeus)
    ld a,$20
    and a
    add l
    ld l,a
    jr 7F

6 inc h

7 pop bc
    djnz 1B                                        

;   Fin de la comparativa.

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
    ld (hl),0                                       ; Coloca a "0" el .db (Impacto) de la (Entidad_sospechosa_de_colision).
    ret

;   COLISIÓN !!!!!.
;
;   .db (Impacto) de Amadeus a "1".
;   SET el bit3 de (Impacto2).
;
;   Nota: El .db (Impacto) de la entidad implicada lo puso a "1" la rutina [Compara_coordenadas_X]. 

5 pop hl
    pop bc

    ld hl,Impacto_Amadeus
    ld (hl),1                                      
    ld hl,Impacto2                                 ; Cuando se produce Colisión, RES el bit2 de (Impacto2) y_
    res 2,(hl)                                     ; _ SET el bit3. El bit3 de (Impacto2) indica que hay contacto_

    ld de,Indice_Explosion_entidades
    ld hl,(Entidad_sospechosa_de_colision)         ; Situamos el (Puntero_de_almacen_de_mov_masticados) de la entidad impactada en la primera palabra del índice de explosiones.
    inc hl
    inc hl
    inc hl
    ld (hl),e
    inc l
    ld (hl),d

; Situamos también el (Puntero_de_almacen_de_mov_masticados) de Amadeus en la primero explosión.

    ld de,Indice_Explosion_Amadeus
    ld hl,Pamm_Amadeus
    ld (hl),e
    inc hl
    ld (hl),d

    ret


 