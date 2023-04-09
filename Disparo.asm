; ******************************************************************************************************************************************************************************************
;
;   27/03/23
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

    ld a,(Ctrl_0)                       ; Una entidad no podrá disparar si se encuentra por_
    bit 6,a                             ; _ debajo de la fila "$14" de pantalla.
    jr nz,16F

    ld a,(Coordenada_y)
    cp $14
    ret nc

; ----- ----- -----

; Habilita el segundo disparo si el primero ha superado la línea $4860

16 ld hl,ON_Disparo_2A
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
;   La Rutina va almacenando disparos en sus respectivas bases de datos.
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
;
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

    ld a,h                                         ; El 1er scanline de la bala se pinta en pantalla.
    cp $58                                         ; El 2º scanline indica colisión porque entra en zona_
    jr z,2F                                        ; _ de atributos. Evitamos comprobar colisión en el _
;                                                  ; _ 2º scanline si esto es así.    
    ld e,$80                                       ; ----- ( ) ----- ----- 
    call Bucle_2      

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
;   01/04/23
;
;   
;   La entidad se encuentra en la fila $14,$15 o $16 de pantalla.
;   Vamos a comprobar si existe colisión con Amadeus. Consideramos que se produce colisión_
;   _ si hay contacto de los dos scanlines inferiores que forman la entidad con la nave.
;
;   INPUTS: IX contiene el "puntero_de_impresión" de la entidad, (arriba-izq).
;           IY contiene el "puntero_objeto" de la entidad, (arriba-izq).

Detecta_colision_nave_entidad 

; Antes de nada, averiguaremos si la entidad ocupa alguna de las columnas que ocupa Amadeus en pantalla.
; Guardamos las coordenadas_X de la entidad en el almacen:

; Preparamos registros:

    ld hl,Filas+6
    ld d,(hl)                                           ; Coordenada_X de Amadeus en D.
    inc hl
    inc hl
    ld e,(hl)                                           ; (CTRL_DESPLZ) de Amadeus en E y B.
    ld b,e
    ld hl,Filas+20
    ld c,(hl)                                           ; (Cuad_objeto) de Amadeus en C.
    ld hl,Coordenadas_X_Entidad
    call Guarda_coordenadas_X
    
; Guardamos las coordenadas_X de Amadeus en el almacen:

; Preparamos registros:

    ld hl,Amadeus_db+6
    ld d,(hl)                                           ; Coordenada_X de Amadeus en D.
    inc hl
    inc hl
    ld e,(hl)                                           ; (CTRL_DESPLZ) de Amadeus en E y A'.
    ld a,e
    ex af,af'

    ld hl,Amadeus_db+20
    ld c,(hl)                                           ; (Cuad_objeto) de Amadeus en C.
    ld hl,Coordenadas_X_Amadeus
    call Guarda_coordenadas_X

; Vamos a comparar las columnas_X de Amadeus y la entidad.
; B contendrá el nº de (Columns) de la entidad. 2 si (CTRL_DESPLZ)="0" y 3 si es distinto.

    inc b
    dec b
    jr z,5F
    ld b,3
    jr 6F
5 ld b,2

6 ex af,af'
    inc a
    dec a
    jr z,9F
    ld c,3
    jr 10F
9 ld c,2
10 ld a,c
    ex af,af'
    ld de,Coordenadas_X_Entidad
8 ld a,(de)

    ld hl,Coordenadas_X_Amadeus
7 cp (hl)

    jr z,11F

    inc hl
    dec c
    jr nz,7B

    inc de
    ex af,af'
    ld c,a
    ex af,af'
    
    djnz 8B

    ret

; Si coinciden las columnas de la entidad con las de Amadeus, llamaremos a la rutina [Calcula_puntero_de_impresion]. Nos proporcionara:
; Puntero_de_impresión de la entidad en IX y puntero_objeto en IY.

11 ld hl,(Posicion_actual)
    call Calcula_puntero_de_impresion

; Con estos datos podremos situar HL en el penúltimo scanline del puntero_de_impresión de la entidad y_
; _ el registro IY en el 1er dato del penúltimo scanline que forma la entidad, (Puntero_objeto).

    ld b,14
    push ix
    pop hl
1 call NextScan
    djnz 1B
    push hl    
    pop ix                                         ; Puntero_de_impresion de la entidad implicada en el penúltimo scanline.

    push iy
    pop hl

; Sumaremos 28/42 bytes en función de las (Columns) que formen la entidad.

    ld a,(Columns)
    and 1
    jr nz,2F
    ld bc,28
    jr 3F
2 ld bc,42    
3 and a
    adc hl,bc
    push hl
    pop iy                                          ; Puntero_objeto de la entidad implicada apuntando al 1er dato del penúltimo_
;                                                   ; _ scanline.
    push ix
    pop hl

    push hl

; Llegados a este punto, HL apunta al puntero de impresión del penúltimo scanline de pantalla de la entidad.
; IY apunta a los "datos" del penúltimo scanline que forman la entidad.

    ld e,0                                         ; E,(Impacto)="0".
    call Bucle_3                                   ; Comprobamos el 1er scanline.

    ld a,e
    and 1
    jr z,4F

    pop hl
    push hl
    call NextScan

    ld a,h                                         ; El 1er scanline de la bala se pinta en pantalla.
    cp $58                                         ; El 2º scanline indica colisión porque entra en zona_
    jr z,4F                                        ; _ de atributos. Evitamos comprobar colisión en el _
    jr nc,4F
;                                                  ; _ 2º scanline si esto es así.    
    ld e,0                                         ; ----- ( ) -----
    call Bucle_3      

    ld a,e
    and a
    jr nz,$

4 pop hl                                           ; Puntero de impresión en HL e indicador de Impacto en B.
    ret                                            

 ; ---------- ----------

Bucle_3 ld a,(Columnas)
    ld b,a 
2 ld a,(iy)
    and (hl)
    jr z,1F
    
    ld e,1

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
;   28/03/23
;

Motor_de_disparos ld bc,Disparo_3A
    ld hl,(Puntero_DESPLZ_DISPARO_AMADEUS)               ; Avanza disparo.

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

; Elimino el disparo de la base de datos.

    push hl
    call Elimina_disparo_de_base_de_datos
    pop hl
    ld a,1
    ld (Impacto2),a                                       ; Indicamos que se ha producido Impacto en una entidad.
    jr 11F

9 call Mueve_disparo
    call foto_disparo_a_borrar 

11 pop bc

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

; ----- ----- ----- ----- ----- -----

    push bc
    call foto_disparo_a_borrar 

; Existe colisión con este disparo???

    inc hl                                               ; El 1er byte indica dirección, el 2º, IMPACTO.
    ld a,(hl)
    dec hl
    and 1
    jr z,10F

; La colisión se produce con Amadeus??? 
; Amadeus siempre tiene (Coordenada_y)="$16".

    push hl

    ld b,4
16 inc hl
    djnz 16B                                             ; Sitúa HL en el Puntero_de_impresion del disparo.

    call Extrae_address
    call Genera_coordenadas_disparo
    ld a,e                                               ; Fila en la que se encuentra el disparo en A.
    cp $16
    jr c,15F

; (Colisiones en filas 16 y 17).

    push de                                              ; DE contiene las coordenadas del disparo que ha colisionado.

; Preparamos los registros para llamar a [Guarda_coordenadas_X]. Necesitamos averiguar que columnas ocupa Amadeus.

    ld hl,Amadeus_db+6
    ld d,(hl)                                           ; Coordenada_X de Amadeus en D.
    inc hl
    inc hl
    ld e,(hl)                                           ; (CTRL_DESPLZ) de Amadeus en E.
    ld hl,Amadeus_db+20
    ld c,(hl)                                           ; (Cuad_objeto) de Amadeus en C.
    ld hl,Coordenadas_X_Amadeus

    call Guarda_coordenadas_X

    pop de                                              ; Coordenadas del disparo en DE. D Coordenada_X.

; Comparamos la coordenada_X del disparo con las coordenadas_X de Amadeus.

    ld hl,Coordenadas_X_Amadeus
    ld a,(hl) 
18 cp d
    jr nz,17F

; Colisión Amadeus !!!!!!!!!!

    pop hl
    jr 14F

17 inc hl
    ld a,(hl)

    and a
    jr z,15F                                             ; No hay colisión con Amadeus.
    jr 18B

; No hay colisión. Amadeus se encuentra en una línea inferior.
; Restauramos el indicador de colisión y movemos el disparo, (JR 10F).

15  pop hl  
    inc hl
    dec (hl)
    dec hl
    jr 10F

; -----------------------debug

; Elimino el disparo de la base de datos.

14 push hl
    call Elimina_disparo_de_base_de_datos
    pop hl

    ld a,2                                               ; Indicamos que se ha producido Impacto en Amadeus.
    ld (Impacto2),a
    jr 12F

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

; HL apunta a la dirección donde se encuentra el puntero de impresión en pantalla.

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
    jr nc,3F                                    ; El disparo no ha salido de la pantalla. Compreba colisión.

; Si el proyectil sale de pantalla borramos el disparo de la base de datos.   

    ex de,hl
    ld b,4
6 dec hl
    djnz 6B

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
    jr c,3B                                     ; El disparo no ha salido de la pantalla. Compreba colisión.

    ex de,hl
    ld b,4
5 dec hl
    djnz 5B

    call Elimina_disparo_de_base_de_datos 

    jr 4B

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
;   Guarda las Coordenadas_X que ocupa Amadeus/Entidad en la pantalla.
;
;   2 Coordenadas_X, (si CTRL_DESPLZ es "0").
;   3 Coordenadas_X, (si CTRL_DESPLZ es distinto de "0").
;
;   Esta información se almacenará en un pequeño almacen de 3 bytes: Coordenadas_X_Amadeus o Coordenadas_X_Entidad.
;
;   INPUTS:
;
;   DE contiene (Coordenada_X)/(CTRL_DESPLZ) de la Entidad/Amadeus respectivamente.
;   C contiene (Cuad_objeto) de la Entidad/Amadeus.
;   HL contiene la dirección del 1er byte de los almacenes de 3 bytes, (Coordenadas_X_Amadeus) o (Coordenadas_X_Entidad). 

;   MODIFICA: A, HL, DE y C

Guarda_coordenadas_X ld (hl),d                          ; Cargamos la 1ª Coordenada_X en su almacen.
    ld a,c
    and 1
    jr nz,1F
    inc d
    jr 2F                                               ; Amadeus se compone como mínimo de 2 chars.:

;   (Coordenada_X) de (Posicion_actual) + (Coordenada_X) de (Posicion_actual)-1 cuando estamos en los cuadrantes 1º y 3º de pantalla.
;   (Coordenada_X) de (Posicion_actual) + (Coordenada_X) de (Posicion_actual)-1 cuando estamos en los cuadrantes 1º y 3º de pantalla.   

1 dec d
2 inc hl
    ld (hl),d

    ld a,e                                              ; Si (CTRL_DESPLZ) de Amadeus es distinto de "0", Amadeus estará formado por 3 chars. y_
    and a                                               ; _ por lo tanto tendrá 3 coordenadas X.
    ret z

    xor a
    ld e,a
    jr Guarda_coordenadas_X

