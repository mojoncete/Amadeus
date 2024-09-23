Motor_de_disparos_entidades

;    ld a,(Ctrl_5)
;    bit 2,a
;    di
;    jr nz,$
;    ei

    ld a,(Numero_de_disparos_de_entidades)
    cp 7
    ret z                                                                ; Salimos si todas las cajas están vacías.

    ld b,7                                                               ; Contador de disparos, (cajas de disparos).
    ld hl,Indice_de_disparos_entidades

1 call Extrae_address 
    inc de
    inc de
    ld (Puntero_DESPLZ_DISPARO_ENTIDADES),de

    inc hl

    inc (hl)                                                             ; Dispone de Puntero_objeto ???
    dec (hl)
    jr z,3F

    inc hl

;;;Mueve_disparo_Entidad

;    ld a,(Ctrl_5)
;    bit 2,a
;    di
;    jr nz,$
;    ei

    call Extrae_address    
;    call NextScan
;    call NextScan 
;    call NextScan 
    call NextScan 

; Después de mover el disparo comprobamos si ha salido por la parte baja de la pantalla.

;    di
;    jr $
;    ei

    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d

    ld hl,(Puntero_DESPLZ_DISPARO_ENTIDADES)
    jr 2F

    ret

3 ex de,hl
2 djnz 1B

	call Inicia_Puntero_Disparo_Entidades

    ret


; --------------------------------------------------------------------------------------
;
;   19/09/24
;

Genera_datos_de_impresion_disparos_Entidades

;*  Exclusiones.

    ld a,(Numero_de_disparos_de_entidades)
    cp 7
    ret z                                                    

; ---------------

;   En 1er lugar nos situamos en la 1ª caja de disparos de entidades.

;    di
;    jr $
;    ei

    ld a,7
    ex af,af                                                  ;? 7 Cajas como 7 soles. Contador de cajas alojado en A´.

    ld hl,(Puntero_DESPLZ_DISPARO_ENTIDADES)
1 call Extrae_address
 
    inc hl
    ld a,(hl)
    and a

    jr z,Situa_en_siguiente_caja                              ;? Avanza a la siguiente caja si esta está vacía. 
   
    dec hl

    ld (Stack),sp
    ld sp,hl                                                  ;? SP se sitúa en el .db (Puntero objeto) de la caja de disparos de Amadeus.

Genera_scanlines_de_los_disparos_de_entidades.

    pop bc
    pop hl                                                    ;? Puntero_objeto del disparo en BC.
;                                                             ;? Puntero_de_impresión del disparo en HL.
    ld sp,(Nivel_scan_disparos_album_de_pintado)

    pop af
    pop af
    pop af

    ld (Nivel_scan_disparos_album_de_pintado),sp              ;? Nuevo nivel del album de disparos.

    push hl                                                   ;? Sube 2º scanline al álbum.
    call NextScan
    push hl                                                   ;? Sube 1er scanline al álbum.
    push bc                                                   ;? Sube Puntero_objeto del disparo al álbum.

Situa_en_siguiente_caja

    ex af,af                                                  ;? Actualiza contador de cajas y RET si "Z".
    dec a
    jr z,2F
    ex af,af

    inc de
    inc de

    ex de,hl
    jr 1B

2 ld sp,(Stack)
    call Inicia_Puntero_Disparo_Entidades
    ret

; --------------------------------------------------------------------------------------
;
;   18/09/24
;

Genera_disparo_de_entidad_maldosa

;   Estructura de un disparo de entidades.

;   Disparo_1 defw 0								; Puntero objeto.
; 	defw 0											; Puntero de impresión.
;	defw 0											; Control.

;   El byte bajo de Control indica la velocidad a la que fué lanzado el disparo, (Velocidad)_
;   _de la entidad en el momento de disparar.

;   El byte alto muestra la siguiente información:
;
;   Nibble bajo    ..... Inicialmente contiene "7d". Utilizaremos estos bits para desplazar X nº de veces el disparo hacia abajo_
;                        _antes de desplazarse a derecha/izquierda.
;
;   Nibble alto    ..... Bits (2) y (3) ..... Indican si el disparo va hacia la derecha o hacia la izquierda.
;
;                        10xx ..... Izquierda.
;                        01xx ..... Derecha.
;                        00xx ..... Recto.

;*  Exclusiones.

;   La entidad no podrá disparar mientras se encuentre en las filas: 0,1,14,15,16.
;   La entidad no podrá disparar si hay 7 disparos en pantalla.

    ld a,(Numero_de_disparos_de_entidades)
    and a
    ret z

    ld a,(Coordenada_y)
    and a
    ret z

    dec a
    ret z

    cp 14
    ret nc

;   En este punto el registro B siempre está a "0" y HL apunta al `nuevo´ ( Puntero de impresión) de la entidad.
;   (Puntero_objeto) del disparo inicial siempre será el mismo en cualquier caso, ( para que quede centrado ) en cualquier_
;   _ posición de cualquier entidad, (como ocurre con el puntero de impresión de las explosiones de entidades).
;

    ld iy,Disparo_de_entidad

;    di
;    jr $
;    ei

    ld hl,Ctrl_5
    set 2,(hl)

;   Decrementa el numero de disparos de entidades.   

;    ld hl,Ctrl_5
;    set 2,(hl)

    ld hl,Numero_de_disparos_de_entidades
    dec (hl)

;   Puntero de impresión del disparo en BC. 

    ld hl,Puntero_de_impresion_disparo_de_entidad
    ld c,(hl)
    inc hl
    ld b,(hl)                                           


1 ld hl,(Puntero_DESPLZ_DISPARO_ENTIDADES)
    call Extrae_address
 
;   Comprobamos si la caja está vacía.

    inc hl
    ld a,(hl)
    and a

    jr nz,Situa_en_siguiente_disparo                    ; Avanza a la siguiente caja si esta esta completa. 

;   Generamos disparo. !!!!!!!!!!!!!!!!

    dec hl

    ld a,iyl
    ld (hl),a                                         
    inc hl
    ld a,iyh
    ld (hl),a                                           ; Guarda el (puntero objeto) del disparo en la caja.

    inc hl

    ld (hl),c
    inc hl
    ld (hl),b                                           ; Guarda el puntero de impresión.

    inc hl                                              

    ld a,(Velocidad)                                    ; Guarda la velocidad de la entidad/disparo.
    ld (hl),a

    inc hl

;! Ajusta el grado de inclinación del disparo.

    ld (hl),7                                           ; Guarda Byte de Control.

; Determina tendencia del disparo.

    ld a,(CX_Amadeus)
    ld b,a
    ld a,(Coordenada_X)
    sub b
    jr c,Disparo_a_derecha

Disparo_a_izquierda cp 4

    jr c,Salida_02
    jr z,Salida_02

    set 7,(hl)
    jr Salida_02

Disparo_a_derecha ld b,a
    ld a,$ff
    sub b

    cp 4    

    jr c,Salida_02
    jr z,Salida_02

    set 6,(hl)
    jr Salida_02

;   --- --- ---

Situa_en_siguiente_disparo 

    inc de
    inc de

    ld (Puntero_DESPLZ_DISPARO_ENTIDADES),de
    jr 1B

Salida_02

	call Inicia_Puntero_Disparo_Entidades
    ret
    
; --------------------------------------------------------------------------------------
;
;   31/08/24
;

Compara_con_coordenadas_de_disparo

    ld a,(Coordenada_y)
    ld b,a
    ld a,(Coordenadas_disparo_certero)
    sub b

; A = "0" ok
; A = "1" ok

    jr z,Comprueba_coordenada_X
    dec a
    jr z,Comprueba_coordenada_X
    
; A = "$ff" ok

    cp $fe
    jr z,Comprueba_coordenada_X

    ret

Comprueba_coordenada_X

    ld a,(Coordenada_X)
    ld b,a
    ld hl,Coordenadas_disparo_certero+1
    ld a,(hl)
    sub b

; A = "0" ok
; A = "1" ok

    jr z,Activa_Impacto_en_entidad
    dec a
    jr z,Activa_Impacto_en_entidad

; A = "2" ok

    dec a
    jr z,Activa_Impacto_en_entidad    

; A = "$ff"

    cp $fd 
    ret nz

Activa_Impacto_en_entidad

;   Indica Impacto en la entidad por disparo de Amadeus, "2".

    ld a,2
    ld (Impacto),a

;   (Puntero_de_almacen_de_mov_masticados) ahora apuntará a la explosión.

    ld de,Indice_Explosion_entidades
    ld hl,Puntero_de_almacen_de_mov_masticados

    ld (hl),e
    inc hl
    ld (hl),d

;   Hemos encontrado la entidad impactada, Restauramos FLAG para dejar de buscar en este FRAME.

    ld hl,Impacto2
    res 3,(hl)

    ret

; --------------------------------------------------------------------------------------
;
;   11/09/24
;

Limpia_album_de_borrado_disparos

    ld hl,Ctrl_5
    bit 0,(hl)
    ret z
    res 0,(hl)

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
;   11/09/24
;
;   Limpia la diferencia de bytes entre el (album_de_pintado_disparos) del FRAME anterior y el_
;   _(album_de_pintado_disparos) del FRAME actual, (siempre que el álbum del FRAME anterior contenga más_ 
;   _disparos que el álbum del FRAME actual). 

Limpia_album_de_pintado_disparos

;*   Exclusiones.

    ld a,(Num_de_bytes_album_de_disparos_2)
    and a
    ret z

; -----

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

Motor_Disparos_Amadeus

;   Averiguamos si la 1ª caja contiene disparo, para ello nos situamos en el byte alto del (Puntero_de_impresion).

    ld hl,Disparo_Amad+1

    inc (hl)
    dec (hl)
    
    ret z

;   Esta caja contiene un disparo.

    call Consulta_Impacto
    call z,Mueve_disparo_Amadeus

    ret

; ----------------------
;
;
;   Nos colocamos en el .db (Impacto) e interrogamos.
;
;   OUTPUT: (Z) / (NZ) FLAG. NZ indica que existe (Impacto).


Consulta_Impacto

;   Vamos a comprobar si existe (Impacto) de este disparo con alguna entidad antes de mover la entidad y el propio disparo. Lo vamos a hacer así para que la detección_
;   _sea lo más coherente posible. 

    push hl
    dec hl                                      
    call Detecta_impacto_en_disparo_de_Amadeus                          ; Nos situamos en el 1er .db de la caja y comprobamos Impacto.  
    pop hl
    inc hl                                                              ; (Puntero_de_impresion) en HL.

    ret z

    ld a,(Impacto2)    
    set 3,a
    ld (Impacto2),a
 
    push hl
    call Genera_coordenadas_de_disparo_Amadeus
    pop hl
    call Elimina_disparo

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
    call PreviousScan 

; Después de mover el disparo comprobamos si ha salido de la parte alta de la pantalla.

    ld a,h
    sub $40
    ex de,hl
    jr c,Elimina_disparo

 ; Introduce nuevo puntero_de_impresión en la caja.

    ld (hl),e
    inc hl
    ld (hl),d

    ret

; ----------------------
;
;   11/9/24

Elimina_disparo

; HL apunta al .db (Puntero_de_impresion) del disparo.
; Recordemos la estructura de datos de una caja de disparos de Amadeus:

;   Disparo_1A defw 0									; Puntero objeto.
;   	defw 0											; Puntero de impresión.

    dec hl
    dec hl

    xor a
    ld (hl),a
    inc hl
    ld (hl),a                                           ;? Puntero_objeto borrado.

    inc hl
    ld (hl),a
    inc hl
    ld (hl),a                                           ;? Puntero_de_impresion borrado.

    ld a,1
    ld (Permiso_de_disparo_Amadeus),a

    ld hl,Ctrl_5                                        ;? Indica que ha desaparecido un disparo.
    set 0,(hl)

    xor a
    inc a                                               ;? Siempre que eliminamos un disparo tenemos: "NZ".

    ret

; --------------------------------------------------------------------------------------
;
;   21/8/24
;

Pinta_disparos 

;    ld a,(Ctrl_5)
;    bit 2,a
;    jr nz,$

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
;   14/09/24
;
;   Modifica: HL y DE.


Genera_datos_de_impresion_disparos_Amadeus

    ld (Stack),sp
    ld sp,Disparo_Amad                                        ;? SP se sitúa en el .db (Puntero objeto) de la caja de disparos de Amadeus.
    pop de                                                    ;? Puntero_objeto del disparo en DE.

    inc d                                                     ;? Salimos si no hay disparo.
    dec d

    jr z,Salida

Genera_scanlines_de_disparo_Amadeus

    pop hl                                                    ;? Puntero_objeto del disparo en DE.
;                                                             ;? Puntero_de_impresión del disparo en HL.
    ld sp,(Nivel_scan_disparos_album_de_pintado)

    pop bc
    pop bc
    pop bc

    ld (Nivel_scan_disparos_album_de_pintado),sp              ;? Nuevo nivel del album de disparos.

    push hl                                                   ;? Sube 2º scanline al álbum.
    call PreviousScan
    push hl                                                   ;? Sube 1er scanline al álbum.
    push de                                                   ;? Sube Puntero_objeto del disparo al álbum.

Salida 

    ld sp,(Stack)
    ret

; --------------------------------------------------------------------------------------
;
;   12/09/24
;

Genera_disparo_Amadeus

;*  Exclusiones.

    ld a,(Permiso_de_disparo_Amadeus)
    and a
    ret z                                                    ;? Salimos si no hay permiso de disparo.

    dec a
    ld (Permiso_de_disparo_Amadeus),a                        ;? No volveremos a tener permiso de disparo hasta que desaparezaca este disparo.

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

5 ld hl,Indice_disparo_Amadeus
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
; HL en el 1er .db de la caja.

    ld hl,Disparo_Amad

    ld b,2

6 pop de
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    djnz 6B

    ret

Genera_coordenadas_de_disparo_Amadeus

;   HL deberá apuntar al .db (Puntero_de_impresion) del disparo.
;   Esta parte de la rutina sólo aplica cuando un disparo nuestro alcanza a una entidad.
;   Genera las coordenadas de nuestro disparo certero y activa el correspondiente FLAG, (bit3 Impacto2).

    call Extrae_address
    call Genera_coordenadas

    dec a

    ld hl,Coordenadas_disparo_certero
    ld (hl),a                                           ;   Almacenamos la Coordenada_Y, (Fila) del disparo.
    inc hl
    ld a,(Coordenada_X)                                 
    ld (hl),a                                           ;   Almacenamos la Coordenada_X, (Columna) del disparo.
    
    xor a
    inc a                                               ;   Fuerza "NZ" a la salida.

    ret

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 

; ----------------------------------------------
;
;   27/08/24
;
;   INPUTS: HL contiene la dirección de caja del disparo correspondiente, (1er .db de la caja).
;   OUTPUT: FLAG Z indica NO IMPACTO, NZ indica IMPACTO.

Detecta_impacto_en_disparo_de_Amadeus

Extraccion_de_datos                                        

    inc de
    inc de                                                 ;    Se sitúa en Puntero_objeto aumentdao del disparo para comprobar colisión.   

    ld e,(hl)
    inc hl
    ld d,(hl)

    inc hl                                                 

    ld c,(hl)
    inc hl
    ld b,(hl)
 
    push bc 
    pop hl                                                 ;    Puntero_de_impresión del disparo en HL.

;   La detección de colisión se efectúa con el disparo impreso en pantalla.

    call PreviousScan
    call PreviousScan

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


 