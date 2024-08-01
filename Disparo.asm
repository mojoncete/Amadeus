

; ----------------------------------------------------------------
;
;   25/02/23
;
;   La Rutina va almacenando disparos en sus respectivas bases de datos.
;   Amadeus dispone de 2 disparos mientras que las entidades disponen de un máximo de 10.
;
;   Antes de salir de la rutina `iniciamos` los punteros de disparos, así vamos almacenando_
;   _ los disparos generados en el primer campo que quede libre de la base de datos.

Almacena_disparo 

    push hl  										; HL contiene el puntero de impresión.                                                                          
    pop af                                          
    ex af,af                                        ; Puntero_de_impresion en AF'.

3 ld a,c 											; C contiene la "dirección" del proyectil.
    and 1
    jr z,1F                                         ; Según la `Dirección' del proyectil sabemos si_
;                                                   ; _ es Amadeus o una entidad la que dispara.    
; 	Dispara AMADEUS.

;	Comprobamos que a Amadeus aún le quedan disparos.
;	Si es así, nos situamos en la siguiente dirección del índice de disparos de Amadeus.
;	Si por el contrario, estamos al final de índice, (no disponemos de más disparos),_
;	_ iniciamos (Puntero_DESPLZ_DISPARO_AMADEUS) situándolo al comienzo del índice y salimos.

    push bc
    ld bc,Indice_de_disparos_Amadeus+4              ; Disparo_3A. Indica que no quedan disparos. Final de índice.
    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)
    and a
    sbc hl,bc
    call z,Inicia_Puntero_Disparo_Amadeus           ; Iniciamos el puntero de desplazamiento del índice y salimos. Amadeus no tiene disparos.
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

; Guardamos en Album_de_lineas_disparos los proyectiles generados.

	ld hl,Ctrl_1
	set 0,(hl) 

	push ix
    pop hl
    push af
    pop ix

	call Guarda_foto_registros

	ld hl,Ctrl_1									; Restauramos el indicador de disparo antes de salir.
	res 0,(hl)

;   Inicializamos los punteros de disparos antes de salir. Pretendemos que los campos vacíos del índice siempre estén
;   _ al final. Los disparos nuevos que se generen se guardarán en el primer cajón vacío del índice.

    call Inicia_Puntero_Disparo_Amadeus
    call Inicia_Puntero_Disparo_Entidades

4 ret

; ----------------------------------------------------------------
;
;   4/3/23
;   
;   Entrega el siguiente dato en el registro B en función de si se produce colisión, o no,_
;   _ al generarse el disparo.
;
;       "$80" ..... No se produce colisión.
;       "$81" ..... Se produce colisión.
;
;   Nota: A fecha de 21/7/23, es necesario que se produzca IMPACTO en los dos primeros scanlines_
;         _ que forman el disparo.


Comprueba_Colision

; Siempre que ejecutemos esta rutina, será Amadeus el que esté alojado en DRAW. 

    push iy                                        ; Puntero objeto (disparo).
    push hl                                        ; Puntero de impresión (disparo).                                 

    call Modifica_H_Velocidad_disparo

    ld a,h                                         ; Si (Velocidad_disparo_entidades)="2", hemos incrementado H.
    cp $58                                         ; Se puede dar el caso de que nos hayamos metido en zona de attr.
    jr z,1F                                        ; En ese caso salimos de la rutina sin comprobar colisión.

    ld e,$80                                       ; E,(Impacto)="$80".
    call Bucle_2                                   ; Comprobamos el 1er scanline.

    ld a,e
    and 1
    jr nz,1F    ;""""                              ; Salimos si E="$80". Necesitamos colisión en los 2 scanlines_
;                                                  ; _ para activar IMPACTO.
    pop hl
    push hl
    call NextScan

    ld a,h                                         ; El 1er scanline de la bala se pinta en pantalla.
    cp $58                                         ; El 2º scanline indica colisión porque entra en zona_
    jr z,1F                                        ; _ de atributos. Evitamos comprobar colisión en el _
;                                                  ; _ 2º scanline si esto es así.    
    ld e,$80                                       ; ----- ( ) ----- ----- 
    call Bucle_2      

1 ld b,e
    pop hl                                         ; Puntero de impresión en HL e indicador de Impacto en B.
    pop iy
    ret                                            

; ---------- ----------

Bucle_2 ld b,2 
2 ld a,(iy)
    and (hl)
    jr z,1F
    ld e,$81
1 inc hl
    inc iy
    djnz 2B
    ret                                         

; ---------- ----------
;
;   21/7/23

Modifica_H_Velocidad_disparo 

    ld a,(Velocidad_disparo_entidades)             ; Si avanzamos menos scanlines de los que ocupa_  
    cp 3                                           ; _ un disparo, siempre habrá IMPACTO. Para evitar esto_
    ret nc                                         ; _ incrementamos H.
    inc h
 
    ret



; -------------------------------------------------------------------------------------------------------------
;
;   13/03/23
;
;   Limpia el album de fotos de disparos después de cada borra/pinta. 50fps.
;
;   DESTRUYE: HL,BC,DE y A.

Limpia_album_disparos ld hl,Album_de_lineas_disparos
    ld a,(hl)
    and a
    ret z                                               ; Salimos de la rutina si no hay ningún disparo en pantalla.

    ld b,h
    ld c,l
    ld hl,(Album_de_lineas_disparos_SP)
    push hl
    and a
    sbc hl,bc                                           
    push hl
    pop bc                                              ; BC contiene el nº de bytes a limpiar.
 
    pop hl
    ld d,h
    ld e,l
    dec de
    lddr                                                ; Limpiamos.

    ld hl,Album_de_lineas_disparos
    ld (Album_de_lineas_disparos_SP),hl

    ret

; -------------------------------------------------------------------------------------------------------------
;
;   18/07/23
;

Motor_de_disparos 

; Gestiona DISPAROS DE AMADEUS.

    ld bc,Disparo_3A                                     ; Último disparo del índice.
    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)               ; Puntero del índice de disparos de Amadeus.

2 call Extrae_address
    ld a,(hl)
    and a
    jr z,1F                                              ; Disparo vacio, saltamos al siguiente.

; ----- ----- ----- ----- ----- -----

    push bc
    call foto_disparo_a_borrar 

; Existe colisión con este disparo???

    inc hl                                               ; El 1er byte indica dirección, el 2º, IMPACTO.
    ld a,(hl)
    dec hl
    and 1
    jr z,9F

;   En este punto:
;
;   HL está situado en el 1er byte de la DB del disparo que ha impactado en Amadeus.
;   IX contiene el puntero de impresión, (zona de pantalla donde se ha producido el impacto_
;   _con la entidad).
; 
;   Disparo_2A defw 0                                ; Control.
;    defw 0                                          ; Puntero objeto.
;    defw 0                                          ; Puntero de impresión.
;    defw 0                                          ; Rutina de impresión.          

    push hl

    ld b,4
19 inc hl
    djnz 19B

    call Extrae_address
    call Genera_coordenadas_disparo

; Ahora tenemos la coordenada_X del disparo en D y la coordenada_y en E.

    ld hl,Coordenadas_disparo_certero
    ld (hl),d
    inc hl
    ld (hl),e

; Elimino el disparo de la base de datos.

    pop hl
    call Elimina_disparo_de_base_de_datos
    ld hl,Impacto2
    set 0,(hl)                                           ; Indicamos que se ha producido Impacto en una entidad.

    jr 11F

9 call Mueve_disparo
    call foto_disparo_a_borrar 

11 pop bc
    jr 7F

; ----- ----- ----- ----- ----- -----

1 sbc hl,bc
    jr z,3F                                              ; Hemos llegado al final del índice de disparos de Amadeus??

7 ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)                 ; Nos situamos en el 2º disparo de Amadeus.
    inc hl
    inc hl
    ld (Puntero_DESPLZ_DISPARO_AMADEUS),hl
    jr 2B

3 call Inicia_Puntero_Disparo_Amadeus                    ; (Banco_de_pruebas.asm). Sitúa el puntero del índice_
;                                                        ; _ de disparos de Amadeus en el 1er disparo de nuestra nave.

; Gestiona DISPAROS DE ENTIDADES.

    ld bc,Disparo_11
    ld hl,(Puntero_DESPLZ_DISPARO_ENTIDADES)

5 call Extrae_address
    ld a,(hl)
    and a
    jr z,4F                                              ; Disparo vacio, saltamos al siguiente.

; ----- ----- ----- ----- ----- -----

    push bc
    call foto_disparo_a_borrar 

; Existe colisión con este disparo???

    inc hl                                               ; El 1er byte indica dirección, el 2º, IMPACTO.
    ld a,(hl)
    dec hl
    and 1
    jr z,10F

;! La colisión se produce con Amadeus??? 
;! Amadeus siempre tiene (Coordenada_y)="$16".

    push hl

    ld b,4
16 inc hl
    djnz 16B                                             ; Sitúa HL en el Puntero_de_impresion del disparo.

    call Extrae_address
    call Genera_coordenadas_disparo

    ld a,e                                               ; Fila en la que se encuentra el disparo en A.
    cp $16
    jr c,15F
 

; EXISTE COLISIÓN EN ZONA DE AMADEUS. -------------------------------------

    push de                                              ; DE contiene las coordenadas del disparo que ha colisionado.

; Preparamos los registros para llamar a [Guarda_coordenadas_X]. Necesitamos averiguar que columnas ocupa Amadeus.

    ld hl,(p.imp.amadeus)

; Coordenada X de Amadeus en D.

    ld a,l
    and $1F
    ld d,a

    ld hl,Amadeus_db+8
    ld e,(hl)                                            ; (CTRL_DESPLZ) de Amadeus en E.

    ld hl,Coordenadas_X_Amadeus
    call Guarda_coordenadas_X

    pop de                                              ; Coordenadas del disparo en DE. D Coordenada_X.

; Comparamos la coordenada_X del disparo con las coordenadas_X de Amadeus.

    ld b,2
20 push bc

    ld b,3
    ld hl,Coordenadas_X_Amadeus
18 ld a,(hl) 
    cp d
    jr nz,17F

;! Colisión Amadeus !!!!!!!!!!

    pop bc
    pop hl
    jr 14F

17 inc hl
    djnz 18B

    inc d                       ; 2ª Coordenada_X del disparo.

    pop bc
    djnz 20B


; No hay colisión. Amadeus se encuentra en una línea inferior.
; Restauramos el indicador de colisión y movemos el disparo, (JR 10F).

15 pop hl  
    inc hl
    dec (hl)
    dec hl
    jr 10F

; Elimino el disparo de la base de datos, indicamos el impacto, SET1,(Impacto2) y limpiamos el_
; _ almacén de coordenadas_X de Amadeus.

14 push hl
    call Elimina_disparo_de_base_de_datos
    ld hl,Impacto2
    set 1,(hl)
    pop hl
    jr 12F

; No existe colisión con este disparo, MOVEMOS DISPARO.

10 call Mueve_disparo
    call foto_disparo_a_borrar 
12 pop bc

    jr 8F

; ----- ----- ----- ----- ----- -----

4 sbc hl,bc
    jr z,6F

8 ld hl,(Puntero_DESPLZ_DISPARO_ENTIDADES)
    inc hl
    inc hl
    ld (Puntero_DESPLZ_DISPARO_ENTIDADES),hl
    jr 5B

6 call Inicia_Puntero_Disparo_Entidades
    call Limpia_Coordenadas_X
    ret

; ------------------------------------------------------------------

foto_disparo_a_borrar 

    ld a,(hl)                                            ; Si el disparo está vacio salimos de la rutina.
    and a                                                ; [Mueve_disparo] a eliminado el disparo de la base de datos_
    ret z                                                ; _ al sobrepasar los límites de pantalla.

    push hl
    inc hl
    inc hl
    ld (Stack),sp
    ld sp,hl                                             ; Situamos el sp en Puntero objeto
    pop iy
    pop ix
    pop hl
    ld sp,(Stack)
    ld a,(Ctrl_1)
    set 0,a
    ld (Ctrl_1),a
    call Guarda_foto_registros
    ld a,(Ctrl_1)
    res 0,a
    ld (Ctrl_1),a
    pop hl
    ret

;---------------------------------------------------
;
;   18/07/23
;

Mueve_disparo 

;   HL apunta al 1er byte, (Control), del disparo en curso.
;   El 1er byte indica dirección, el 2º, IMPACTO. 
;   Dirección del disparo en A. ("$80" hacia abajo, "$81" hacia arriba). 

    push hl

    ld a,(hl)                           

    ld b,4
1 inc hl
    djnz 1B

;   HL apunta ahora a la dirección donde se encuentra el puntero de impresión del disparo.

    call Extrae_address

    and 1
    jr z,2F                             ; Disparamos hacia arriba o abajo???

; Disparo hacia arriba, (Amadeus).    

; Nota: Aquí podemos implementar una variable para modificar la velocidad del disparo en función_
; _ de la dificultad.

    call PreviousScan 
    call PreviousScan
    call PreviousScan
    call PreviousScan

; Detecta si el disparo de Amadeus sale de pantalla:

    ld a,h
    cp $40
    jr nc,3F                                    ; El disparo no ha salido de la pantalla. Compreba colisión.

; Si el proyectil sale de pantalla borramos el disparo de la base de datos.   

    ex de,hl
    ld b,4
6 dec hl
    djnz 6B

    call Elimina_disparo_de_base_de_datos 
    pop hl
    jr 7F

; Se ha desplazado la bala actualizo el puntero de impresión y compruebo colisión.
; HL contiene el puntero de impresión del disparo.
; DE contiene la dirección donde se encuentra el puntero de impresión del disparo.

3 push de
    push bc

    call Comprueba_Colision

; B="$80", no hay colisión. B="$81", existe colisión. 

    ld a,b

    pop bc
    pop de

    ex de,hl

    ld (hl),e                                   ; Acualizamos el (Puntero_de_impresion) del disparo tras el_
    inc hl                                      ; _ movimiento.
    ld (hl),d

    pop hl                                      ; Volvemos a situarnos en el 1er byte, (Control), del disparo_

    inc hl                                      ; _ en curso.
    ld (hl),a                                   ; Modificamos el byte "impacto" de la base de datos del disparo si es necesario.
    dec hl

7 ret

; Disparo hacia abajo, (Entidad).

2 ld a,(Velocidad_disparo_entidades)
    ld b,a
    
4 call NextScan
    djnz 4B 

; Detecta si el disparo de la entidad sale de la pantalla.

    ld a,h
    cp $58
    jr c,3B                                     ; El disparo no ha salido de la pantalla. Compreba colisión.

    ex de,hl
    ld b,4
5 dec hl
    djnz 5B

    call Elimina_disparo_de_base_de_datos 
    pop hl
    jr 7B

; HL apunta al primer byte de la base de datos del disparo.

Elimina_disparo_de_base_de_datos ld bc,7
    xor a
    ld (hl),a
    ld d,h
    ld e,l
    inc de
    ldir
    ret

; -----------------------------------------------------------------
;
;   7/12/23
;

Selector_de_impactos ld a,(Impacto2)    
    and a
    ret z

; Analizamos si hay impacto por disparos.  

; Primero analizamos si algún disparo impacta en Amadeus.

    bit 1,a
    jr z,1F

    ld hl,Amadeus_db+25                                  ; Existe colisión con Amadeus.  
    ld (hl),1                                            ; (Impacto) de Amadeus a "1".
    jr 2F

1 bit 0,a
    ret z

; Aquí llamaremos a la rutina que detecta a que entidad hemos alcanzado.    

    ld hl,Ctrl_1
    set 2,(hl)

2 ret 

; -----------------------------------------------------------------
;
;   25/04/23
;

Determina_resultado_comparativa 

;   Tenemos en Hl el resultado de comparar las coordenadas de esta entidad con las del dispar_
;   _ que tiene colisión, (Coordenadas_disparo_certero).
;
;   HL ..... Coordenada_Y / Coordenada_X de la entidad en curso.
;   DE ..... Coordenada_Y / Coordenada_X de (Coordenadas_disparo_certero).
;
;   SBC HL,DE

; 2º Cuad H = "$ff","$00","$01","$02" .......... 1er Cuad H = "$00","$01","$02","$03"
;         L = "$ff","$00","$01"       ..........          L = "$00","$01","$02"

; 3º Cuad H = "$fe","$ff","$01"             .......... 4º Cuad  H = "$ff",$00","$01","$02","$03"
;         L = "$01","$02","$03"             ..........          L = "$fe",$00","$01","$02"


    ld a,(Cuad_objeto)
    cp 2
    jr z,2F
    jr c,2F

; Cuadrantes 3º y 4º

    and 1
    jr z,4F

; Cuadrante 3º

    ld a,h
    ld b,0

    call Compara_cositas_H3

    inc b
    dec b
    ret z                                   ; B="0". Indica que H es distinto de "0, $fe, $ff o $01". Salimos de la rutina.

    ld a,l                                  ; B="1". La comparación de H es satisfactoria, pasamos a comparar L.
    ld b,0
 
    call Compara_cositas_L3
    ret 

; Cuadrante 4º

4 ld a,h
    ld b,0

    call Compara_cositas_H4

    inc b
    dec b
    ret z                                   ; B="0". Indica que H es distinto de "0, $fe, $ff o $01". Salimos de la rutina.

    ld a,l                                  ; B="1". La comparación de H es satisfactoria, pasamos a comparar L.
    ld b,0
 
    call Compara_cositas_L4
    ret 

; Cuadrantes 1º y 2º.

2 jr z,3F

; 1er Cuadrante

    ld a,h
    ld b,0

    call Compara_cositas_H1

    inc b
    dec b
    ret z                                   ; B="0". Indica que H es distinto de "0, $fe, $ff o $01". Salimos de la rutina.

    ld a,l                                  ; B="1". La comparación de H es satisfactoria, pasamos a comparar L.
    ld b,0
 
    call Compara_cositas_L1
    ret 


; 2º Cuadrante

3 ld a,h
    ld b,0

    call Compara_cositas_H2

    inc b
    dec b
    ret z                                   ; B="0". Indica que H es distinto de "0, $fe, $ff o $01". Salimos de la rutina.

    ld a,l                                  ; B="1". La comparación de H es satisfactoria, pasamos a comparar L.
    ld b,0
 
    call Compara_cositas_L2
    ret 

Compara_cositas_H2 and a
    jr z,1F
;    cp $fd
;    jr z,1F
;    cp $fe
;    jr z,1F
    cp $ff
    jr z,1F
    cp $01
    jr z,1F
    cp $02
    jr z,1F
    ret nz
1 inc b
    ret

Compara_cositas_L2 and a
    jr z,1F
;    cp $fd
;    jr z,1F
    cp $fe
    jr z,1F
    cp $ff
    jr z,1F
    cp $01
    jr z,1F
;    cp $02
;    jr z,1F
    ret nz
1 inc b
    ret

Compara_cositas_H1 and a
    jr z,1F
;    cp $fd
;    jr z,1F
;    cp $fe
;    jr z,1F
    cp $ff
    jr z,1F
    cp $01
    jr z,1F
    cp $02
    jr z,1F
    cp $03
    jr z,1F
    ret nz
1 inc b
    ret

Compara_cositas_L1 and a
    jr z,1F
;    cp $fd
;    jr z,1F
;    cp $fe
;    jr z,1F
;    cp $ff
;    jr z,1F
    cp $01
    jr z,1F
    cp $02
    jr z,1F
    cp $03
    jr z,1F
    ret nz
1 inc b
    ret

Compara_cositas_H3 and a
    jr z,1F
;    cp $fd
;    jr z,1F
    cp $fe
    jr z,1F
    cp $ff
    jr z,1F
    cp $01
    jr z,1F
;    cp $02
;    jr z,1F
;    cp $03
;    jr z,1F
    ret nz
1 inc b
    ret

Compara_cositas_L3 and a
    jr z,1F
;    cp $fd
;    jr z,1F
;    cp $fe
;    jr z,1F
;    cp $ff
;    jr z,1F
    cp $01
    jr z,1F
    cp $02
    jr z,1F
    cp $03
    jr z,1F
    ret nz
1 inc b
    ret

Compara_cositas_H4 and a
    jr z,1F
    cp $fd
    jr z,1F
    cp $fe
    jr z,1F
    cp $ff
    jr z,1F
    cp $01
    jr z,1F
;    cp $02
;    jr z,1F
;    cp $03
;    jr z,1F
    ret nz
1 inc b
    ret

Compara_cositas_L4 and a
    jr z,1F
;    cp $fd
;    jr z,1F
    cp $fe
    jr z,1F
    cp $ff
    jr z,1F
    cp $01
    jr z,1F
;    cp $02
;    jr z,1F
;    cp $03
;    jr z,1F
    ret nz
1 inc b
    ret