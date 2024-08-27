; --------------------------------------------------------------------------------------
;
;   26/08/24
;

Limpia_album_de_borrado_disparos

    ld hl,Ctrl_5
    bit 0,(hl)
    ret z
    res 0,(hl)

    ld a,(Numero_de_disparos_de_Amadeus)    
    and a
    ret nz

Limpiando

    xor a
    ld hl,(Album_de_borrado_disparos)
    ld (hl),a
    ld e,l
    ld d,h
    inc e                                           ; DE = HL+1
    ld bc,$003a
    ldir

    ret


; --------------------------------------------------------------------------------------
;
;   26/08/24
;

Calcula_bytes_pintado_disparos

    ld hl,(Album_de_pintado_disparos)
    ld b,l
    ld hl,(Nivel_scan_disparos_album_de_pintado)
    ld a,l

    sub b
    ld (Num_de_bytes_album_de_disparos),a

    ret

; --------------------------------------------------------------------------------------
;
;   23/08/24
;
;   Limpia la diferencia de bytes entre el (album_de_pintado_disparos) del FRAME anterior y el_
;   _(album_de_pintado_disparos) del FRAME actual, (siempre que el álbum del FRAME anterior contenga más_ 
;   _disparos que el álbum del FRAME actual). 

Limpia_album_de_pintado_disparos

;   Exclusiones.

    ld a,(Num_de_bytes_album_de_disparos_2)
    and a
    ret z

; -----

    and a

    ld a,(Num_de_bytes_album_de_disparos)
    ld b,a    
    ld a,(Num_de_bytes_album_de_disparos_2)

    sub b

    ret z
    ret c

    ld hl,(Nivel_scan_disparos_album_de_pintado)
    ld b,a                                                              ; Nº de bytes a borrar en B.
    xor a                                                               ; "0".

1 ld (hl),a
    inc l
    djnz 1B

    ret

; --------------------------------------------------------------------------------------
;
;   27/08/24
;

Mueve_Disparos

;    Exclusiones:

    ld a,(Numero_de_disparos_de_Amadeus)
    and a
    jr z,2F                                                             ; Salimos si no hay ningún disparo generado.

; .........................

; Nos situamos en el (puntero_de_impresión) de la 1ª caja.

    ld hl,Disparo_1A+3

    inc (hl)
    dec (hl)
    jr z,1F

; La caja contiene disparo. Existe (Impacto) en algún disparo de Amadeus ??
; Consultamos FLAG.
; Si hay impacto, se trata de este disparo??

    ld a,(Impacto2)
    bit 3,a
    call nz, Averigua_Impacto
    
    di
    jr nz,$
    ei


; En este disparo no hay impacto. MOVEMOS !!!

    dec hl
    call Mueve_disparo_Amadeus

1 ld hl,Disparo_2A+3

    inc (hl)
    dec (hl)
    jr z,2F

    dec hl
    call Mueve_disparo_Amadeus

; Disparos de entidades.

2 ld a,(Numero_de_disparos_de_entidades)
    and a
    ret z

    ld b,7                                                               ; Contador de disparos.
    ld hl,Indice_de_disparos_entidades

4 call Extrae_address 
    inc de
    inc de
    ld (Puntero_rancio_disparos_album),de

    inc hl

    inc (hl)                                                           ; Dispone de Puntero_objeto ???
    dec (hl)
    jr z,3F

3 ex de,hl
    djnz 4B

    ret

; ----------------------
;
;

Averigua_Impacto

    inc hl

    inc (hl)
    dec (hl)

    dec hl

    ret 

; ----------------------
;
;
;   INPUTS: HL debe apuntar al (Puntero_de_impresion) del disparo.

Mueve_disparo_Amadeus

    call Extrae_address                                               

    call PreviousScan
    call PreviousScan 
    call PreviousScan 
;    call PreviousScan 

; Después de mover el disparo comprobamos si ha salido de la parte alta de la pantalla.

    ld a,h
    sub $40
    jr c,Elimina_disparo

 ; Introduce nuevo puntero_de_impresión en la caja.

    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d

    ret

; ----------------------
;
;   23/08/24

Elimina_disparo

    ex de,hl

; HL apunta al .db (Puntero_de_impresion) del disparo.
; Recordemos la estructura de datos de una caja de disparos de Amadeus:

;   Disparo_1A defw 0									; Puntero objeto.
;   	defw 0											; Puntero de impresión.
;   	db 0											; Impacto.

    dec hl
    dec hl

    xor a
    ld (hl),a
    inc hl
    ld (hl),a                                           ; Puntero_objeto borrado.
    inc hl
    ld (hl),a
    inc hl
    ld (hl),a                                           ; Puntero_de_impresion borrado.
    inc hl
    ld (hl),a                                           ; Impacto borrado.

    ld hl,Numero_de_disparos_de_Amadeus
    dec (hl)

    ld a,(Disparo_Amadeus)
    or 1
    ld (Disparo_Amadeus),a

    ld hl,Ctrl_5
    set 0,(hl)


    ret

; --------------------------------------------------------------------------------------
;
;   21/8/24
;

Pinta_disparos 

    ld (Stack),sp
    ld b,2

Borra_disparos ld sp,(Album_de_borrado_disparos)

2 pop de
    
    inc d
    dec d

    jr z,1F

Imprime_scanlines_de_disparo     

    pop hl

; Puntero objeto en DE.
; Puntero_de_impresión en HL.

; 1er scanline.

    ld a,(de)
    xor (hl)
    ld (hl),a

    inc de
    inc l

    ld a,(de)
    xor (hl)
    ld (hl),a

; 2º scanline.

    pop hl
    dec de

    ld a,(de)
    xor (hl)
    ld (hl),a

    inc de
    inc l

    ld a,(de)
    xor (hl)
    ld (hl),a

; Seguimos pintando / borrando disparos si los hay. SP está situado ahora en el siguiente disparo del álbum de scanlines de disparos.

    jr 2B

3 ld sp,(Album_de_pintado_disparos)
    jr 2B

1 djnz 3B
    ld sp,(Stack)
    ret

; --------------------------------------------------------------------------------------
;
;   21/8/24
;
;   Modifica: HL y DE.


Genera_datos_de_impresion_disparos_Amadeus

;   Exclusiones:

    ld a,(Numero_de_disparos_de_Amadeus)
    and a
    ret z                                                     ; Salimos si no hay ningún disparo generado.

; -----

    ld (Stack),sp
    ld sp,Disparo_1A                                          ; SP se sitúa en el .db (Puntero objeto) de la 1ª caja de disparos de Amadeus.

1 ld hl,Indice_de_disparos_entidades                          ; Compararemos SP con HL para saber cual es la última caja que examinar.
    sbc hl,sp                                                 ; Última caja ??? 
    jr z,Salida

    pop de                                                    ; Puntero_objeto del disparo en DE.

    inc d
    dec d

    jr nz,Genera_scanlines_de_disparo_Amadeus

Siguiente_disparo_Amadeus    

    pop de
    inc sp
    jr 1B

Genera_scanlines_de_disparo_Amadeus

    pop hl                                                    ; Puntero_objeto del disparo en DE.
;                                                             ; Puntero_de_impresión del disparo en HL.
    inc sp
    ld (Puntero_rancio_disparos_album),sp                     ; Guardamos la dirección de la siguiente caja de disparos que tenemos que comprobar.

    ld sp,(Nivel_scan_disparos_album_de_pintado)

    pop bc
    pop bc
    pop bc

    ld (Nivel_scan_disparos_album_de_pintado),sp              ; Nuevo nivel del album de disparos.

    push hl                                                   ; Sube 2º scanline al álbum.
    call PreviousScan
    push hl                                                   ; Sube 1er scanline al álbum.
    push de                                                   ; Sube Puntero_objeto del disparo al álbum.

    ld sp,(Puntero_rancio_disparos_album)
    jr 1B


Salida 

    ld sp,(Stack)
    ret

; --------------------------------------------------------------------------------------
;
;   17/08/24
;

Genera_disparo_Amadeus

;   Exclusiones.

    ld a,(Disparo_Amadeus)
    and a
    ret z                                                    ; Salimos si el disparo de nuestra nave no está habilitado.

;! Provisionalmente sólo 1 disparo !!!!!!
    dec a
    ld (Disparo_Amadeus),a

;   Inc nº de disparos de Amadeus.

    ld hl,Numero_de_disparos_de_Amadeus
    inc (hl)

; ----- ----- ----- -----

Define_puntero_objeto_disparo

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

;   El Puntero_de_impresión del disparo apunta al último scanline de los tres que componen el disparo, (el de abajo).
  
1 call PreviousScan

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

    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)
    call Extrae_address

    inc de
    inc de
    push de

    call Detecta_impacto_en_disparo_de_Amadeus01

    pop hl
    call Extrae_address
    dec hl                                               ;  Sitúa el puntero en el .db (Impacto) de la caja del disparo.

    ret z

    ld a,1
    ld (hl),a

Genera_coordenadas_de_disparo_Amadeus

;   Esta parte de la rutina sólo aplica cuando un disparo nuestro alcanza a una entidad.
;   Genera las coordenadas de nuestro disparo certero y activa el correspondiente FLAG, (bit3 Impacto2).

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
;   27/08/24
;
;   INPUTS: HL contiene la dirección de caja del disparo correspondiente, (1er .db de la caja).

;    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)
;    call Extrae_address

Detecta_impacto_en_disparo_de_Amadeus01

Extraccion_de_datos                                        

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
    inc hl
    ld (hl),d

; Situamos también el (Puntero_de_almacen_de_mov_masticados) de Amadeus en la primero explosión.

    ld de,Indice_Explosion_Amadeus
    ld hl,Pamm_Amadeus
 
    ld (hl),e
    inc hl
    ld (hl),d

    ret


 