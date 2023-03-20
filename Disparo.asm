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
;   _ sólo podran generar disparo cuando (CTRL_DESPLZ) tenga estos valores, $00, $f9, $fb y $fd.
;   IY contendrá la dirección de Puntero_objeto_disparo. 

; Exclusiones:

    ld a,(Columnas)
    ld b,a
    ld a,(Columns)
    cp b
    ret nz                              ; Salimos si la entidad no está completa en pantalla.                           

; ----- ----- -----

; Habilita el segundo disparo si el primero ha superado la línea $4860

    ld hl,ON_Disparo_2A
    call Extrae_address
    inc h
    dec h
    jr z,14F                            ; No hay almacenado ningún disparo de Amadeus. Seguimos con la rutina.

    ld de,$4860                         ; Si el 1er disparo no ha llegado a esta línea no se autoriza el segundo. RET.
    and a
    sbc hl,de
    ret nc

; ----- ----- -----

14 ld hl,Indice_disparo
    ld a,(CTRL_DESPLZ)
    ld c,a
    ld b,0	                            ; B será 0,1,2 o 3 en función del valor de (CTRL_DESPLZ).
;                                           Cuando (CTRL_DESPLZ)="0", B="0"
;                                            ""        ""       "f9", B="1"
;                                            ""        ""       "fb", B="2"
;                                            ""        ""       "fb", B="3"
    and a
    jr z,1F
    and 1        
    ret z                               ; Salimos si (CTRL_DESPLZ) es distinto de $00, $f9, $fb y $fd.

    ld a,c
    ld d,$f9
2 inc hl
    inc hl
    inc b 	
    cp d
    jr z,1F
    inc d
    inc d
    jr 2B

1 call Extrae_address
    push hl
    pop iy                              ; Puntero_objeto_disparo en IY.
	ld ix, Pinta_Disparo        		; Rutinas_de_impresion en IX.

;	Se cumplen las condiciones necesarias para generar un disparo.
;   Las variables de disparo varían en función del cuadrante en el que se encuentre la entidad/Amadeus.

	ld a,(Cuad_objeto)
    cp 2
    jr c,3F
    jr z,3F

; 	Nos encontramos en la mitad inferior de la pantalla, (3er y 4º cuadrante).

    and 1
    jr z,4F

; 	Estamos en el 3er cuadrante de pantalla.
; 	3er CUAD. ----- ----- ----- ----- -----
;
;	En el 3er y 4º cuadrante de pantalla, cabe la posibilidad de que sea una entidad o Amadeus el que dispara.
;	En función del elemento que dispare variara el Puntero_de_impresión y su `Dirección'.
;   En estos cuadrantes también es posible que se genere `Colisión', hay que comprobarlo.

	ld hl,(Posicion_actual)

;   Amadeus o entidad ???.

    ld a,(Ctrl_0)
    bit 6,a
    jr z,8F

; 	Dispara Amadeus.

    ld c,$81	                                    ; Dirección "$81", hacia arriba.                        
    call PreviousScan
    call PreviousScan

;	Ahora HL apunta 2 scanlines por encima de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 1º y3º de pantalla, sólo cuando (CTRL_DESPLZ)="$f9", B="1" ..... (DEC HL)*2. 
;   _ El resto de combinaciones, B="0","2" o "3" ..... DEC HL.

    call Ajusta_disparo_parte_izquierda
    jr 10F

; 	Dispara Entidad.

8 ld c,$80	                                        ; Dirección "$80", hacia abajo.

; 	Guardamos el contenido de BC en la pila pues voy a utilizar el registro B como contador.
;   B contiene "0,1,2 o 3", dato necesario para fijar el puntero de impresión.

    push bc
    ld b,16
9 call NextScan
    djnz 9B
    pop bc

; 	Ahora HL apunta un scanline por debajo de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 1º y3º de pantalla, sólo cuando (CTRL_DESPLZ)="$f9", B="1" ..... (DEC HL)*2. 
;   _ El resto de combinaciones, B="0","2" o "3" ..... DEC HL.

    call Ajusta_disparo_parte_izquierda

10 call Comprueba_Colision                          ; Retorna "$81" o "$80" en B indicando si se produce Colisión
;                                                   ; _al generar el disparo.

; 	LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

    call Almacena_disparo                      
    jr 6F                                           ; RET.
    

; 	Estamos en el 4º cuadrante de pantalla.
; 	4º CUAD. ----- ----- ----- ----- -----
;
;	En el 3er y 4º cuadrante de pantalla, cabe la posibilidad de que sea una entidad o Amadeus el que dispara.
;	En función del elemento que dispare variara el Puntero_de_impresión y su `Dirección'.
;   En estos cuadrantes también es posible que se genere `Colisión', hay que comprobarlo.

4 ld hl,(Posicion_actual)

;   Amadeus o entidad ???. 

    ld a,(Ctrl_0)
    bit 6,a
    jr z,11F

; 	Dispara Amadeus.

    ld c,$81                                          ; Dirección "$81", hacia arriba.                        
    call PreviousScan
    call PreviousScan

; 	Ahora HL apunta 2 scanlines por encima de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 2º y 4º, cuando (CTRL_DESPLZ)="$fb" o "$fd"; B="2" y B="3" ..... (INC HL). 
;	En el resto de combinaciones, B="0" o "1", no se corrige el puntero de impresión.

    call Ajusta_disparo_parte_derecha
    jr 13F
 
; 	Dispara Entidad.

11 ld c,$80                                        	  ; Dirección "$80", hacia abajo.
  
; 	Guardamos el contenido de BC en la pila pues voy a utilizar el registro B como contador.
;   B contiene "0,1,2 o 3", dato necesario para fijar el puntero de impresión.

    push bc

    ld b,16
12 call NextScan
    djnz 12B

    pop bc

; 	Ahora HL apunta un scanline por debajo de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 2º y 4º, cuando (CTRL_DESPLZ)="$fb" o "$fd"; B="2" y B="3" ..... (INC HL). 
;	En el resto de combinaciones, B="0" o "1", no se corrige el puntero de impresión.

    call Ajusta_disparo_parte_derecha

13 call Comprueba_Colision                            ; Retorna "$81" o "$80" en B indicando si se produce Colisión
;                                                     ; _al generar el disparo.

; LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

    call Almacena_disparo                      
    jr 6F                                           ; RET.

; 	La entidad que dispara se encuentra en la mitad superior de pantalla, (cuadrantes 1º y 2º).

3 jr z,5F

; 	1er CUAD. ----- ----- ----- ----- -----
;
;	En el 1er y 2º cuadrante de pantalla, sólo cabe la posibilidad de que sea una entidad la que dispare,_
;	_ por lo tanto siempre se iniciara el disparo en la parte `baja´ del sprite.
;   La dirección del proyectil siempre será hacia abajo. En los cuadrantes 1º y 2º no se comprueba colision_
;   _ pues sabemos que Amadeus sólo puede estar situado en los cuadrantes 3º y 4º.

; 	Cuando (CTRL_DESPLZ)="0", B="0"
;	   ""        ""       "f9", B="1"
;	   ""        ""       "fb", B="2"
; 	   ""        ""       "fb", B="3"

	ld hl,(Posicion_actual)
	call NextScan

; 	Ahora HL apunta una FILA por debajo de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 1º y3º de pantalla, sólo cuando (CTRL_DESPLZ)="$f9", B="1" ..... (DEC HL)*2. 
;   _ El resto de combinaciones, B="0","2" o "3" ..... DEC HL.

    call Ajusta_disparo_parte_izquierda

; 	No se produce impacto. B="$80"
; 	Dirección del proyectil hacia abajo. C="$80" 

    ld bc,$8080                                     

; 	LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

    call Almacena_disparo                      
    jr 6F                                           ; RET.

; 	Estamos en el 2º cuadrante de pantalla.
; 	2º CUAD. ----- ----- ----- ----- -----
;
;	En el 1er y 2º cuadrante de pantalla, sólo cabe la posibilidad de que sea una entidad la que dispare,_
;	_ por lo tanto siempre se iniciara el disparo en la parte `baja´ del sprite.
;   La dirección del proyectil siempre será hacia abajo. En los cuadrante 1º y 2º no se comprueba colision_
;   _ pues sabemos que Amadeus sólo puede estar situado en los cuadrantes 3º y 4º.

5 ld hl,(Posicion_actual)
	call NextScan

; 	Ahora HL apunta una FILA por debajo de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 2º y 4º, cuando (CTRL_DESPLZ)="$fb" o "$fd"; B="2" y B="3" ..... (INC HL). 
;	En el resto de combinaciones, B="0" o "1", no se corrige el puntero de impresión.

    call Ajusta_disparo_parte_derecha

; 	No se produce impacto. B="$80"
; 	Dirección del proyectil hacia abajo. C="80" 

15 ld bc,$8080 

; 	LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

    call Almacena_disparo                      

6 ret

; ----------------------------------------------------------------
;
;	Estas dos subrutinas se encargan de `corregir´, el puntero de impresión del proyectil_
;	_ en función del valor de la variable (CTRL_DESPLZ) y de la situación en pantalla,_
;	_ (lado izq. o derecho), de la entidad que lo genera.

Ajusta_disparo_parte_derecha ld a,b
    cp 2
    jr c,1F
    inc hl
1 ret

Ajusta_disparo_parte_izquierda ld a,b
	cp 1
	jr nz,1F
	dec hl                                          
1 dec hl
    ret

; ----------------------------------------------------------------
;
;   25/02/23
;
;   La Rutina va almacenando disparos en sus respectiva bases de datos.
;   Amadeus dispone de 2 disparos mientras que las entidades disponen de un máximo de 10.

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

; Guardamos en Album_de_fotos_disparos los proyectiles generados.

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
;       "$80" ..... No se produce colisión.
;       "$81" ..... Se produce colisión.

;   Nota: Es necesario que se produzca colisión en los dos scanlines que forman el disparo.
;         La sensibilidad la puedo ajustar eliminando la segunda línea "ld e,$80" de [Comprueba_Colision].


Comprueba_Colision push iy                         ; Puntero objeto (disparo).
    push hl                                        ; Puntero de impresión.                                 
    ld e,$80                                       ; E,(Impacto)="$80".
    call Bucle_2                                   ; Comprobamos el 1er scanline.
    pop hl
    push hl
    call NextScan
    ld e,$80
    call Bucle_2      

; Hay impacto.

2 ld b,e
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

; -------------------------------------------------------------------------------------------------------------
;
;   13/03/23
;
;   Limpia el album de fotos de disparos después de cada borra/pinta. 50fps.
;
;   DESTRUYE: HL,BC,DE y A.

Limpia_album_disparos ld hl,Album_de_fotos_disparos
    ld a,(hl)
    and a
    ret z                                               ; Salimos de la rutina si no hay ningún disparo en pantalla.

    ld b,h
    ld c,l
    ld hl,(Stack_snapshot_disparos)
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

    ld hl,Album_de_fotos_disparos
    ld (Stack_snapshot_disparos),hl

    ret

; -------------------------------------------------------------------------------------------------------------
;
;   14/03/23
;

Motor_de_disparos ld bc,Disparo_3A
    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)               ; Avanza disparo.

2 call Extrae_address
    ld a,(hl)
    and a
    jr z,1F                                              ; Disparo vacio, saltamos al siguiente.


; **********************************************************************************************
; Hay colisión ?????????????                             18/03/23

    inc hl
    ld a,(hl)
    and 1
    jr nz,$
    dec hl
; **********************************************************************************************

; ----- ----- ----- ----- ----- -----

    push bc
    call foto_disparo_a_borrar 
    call Mueve_disparo
    call foto_disparo_a_borrar 
    pop bc

    jr 7F

; ----- ----- ----- ----- ----- -----

1 sbc hl,bc
    jr z,3F                                              ; Hemos llegado al final del índice de disparos de Amadeus??

7 ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)                 ; Avanza disparo.
    inc hl
    inc hl
    ld (Puntero_DESPLZ_DISPARO_AMADEUS),hl
    jr 2B

3 call Inicia_Puntero_Disparo_Amadeus
    
    ld bc,Disparo_11
    ld hl,(Puntero_DESPLZ_DISPARO_ENTIDADES)

5 call Extrae_address
    ld a,(hl)
    and a
    jr z,4F                                              ; Disparo vacio, saltamos al siguiente.

; **********************************************************************************************
; Hay colisión ?????????????                             18/03/23

    inc hl
    ld a,(hl)
    and 1
    jr nz,$
    dec hl
; **********************************************************************************************

; ----- ----- ----- ----- ----- -----

    push bc

    call foto_disparo_a_borrar 
    call Mueve_disparo
    call foto_disparo_a_borrar 
 
    pop bc

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

Mueve_disparo push hl
    ld a,(hl)
    ld b,4
1 inc hl
    djnz 1B

    call Extrae_address

    and 1
    jr z,2F

; Disparo hacia arriba, (Amadeus).    

; Nota: Aquí podemos implementar una variable para modificar la velocidad del disparo en función_
; _ de la dificultad.

    call PreviousScan 
    call PreviousScan
    call PreviousScan

; Detecta si el disparo de Amadeus sale de pantalla:

    ld a,h
    cp $40
    jr nc,3F

; Si el proyectil sale de pantalla borramos el disparo de la base de datos.   

    call Elimina_disparo_de_base_de_datos 
    jr 4F

; Se ha desplazado la bala, compruebo colisión.

3 push de
    push bc
    call Comprueba_Colision
    ld a,b
    pop bc
    pop de

    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d

4 pop hl
    inc hl
    ld (hl),a                                   ; Modificamos el byte "impacto" de la base de datos del disparo si hay colisión.
    dec hl
    ret

; Disparo hacia abajo, (Entidad).

; Nota: Aquí podemos implementar una variable para modificar la velocidad del disparo en función_
; _ de la dificultad.

2 call NextScan
    call NextScan
    call NextScan

  ; Detecta si el disparo de la entidad sale de la pantalla.

    ld a,h
    cp $58
    jr c,3B

    call Elimina_disparo_de_base_de_datos 
    jr 4B


Elimina_disparo_de_base_de_datos 

    ex de,hl
    ld b,4
1 dec hl
    djnz 1B
    ld bc,7

    xor a
    ld (hl),a
    ld d,h
    ld e,l
    inc de

    ldir

    ret