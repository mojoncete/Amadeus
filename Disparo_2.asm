; ******************************************************************************************************************************************************************************************
;
;   21/07/23
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

Genera_disparo_Amadeus

;   Esta parte de la rutina se encarga de `RETORNAR' sin generar disparo cuando (CTRL_DESPLZ)_
;   _ tenga valores distintos de $00, $f9, $fb y $fd.
;   NO SE GENERA disparo cuando la entidad no está impresa en su totalidad en pantalla, (está_
;   _ apareciendo o desapareciendo). (Columns)<>(Columnas).
;   Amadeus, (al desplazarse a 2 pixels), podrá generar disparo en cualquier situación. Las entidades_
;   _ sólo podran generar disparo cuando (CTRL_DESPLZ) tenga los valores, $00, $f9, $fb y $fd.
;   IY contendrá la dirección de Puntero_objeto_disparo. 


    di
    jr $
    ei

; Exclusiones:

;    ld a,(Vel_down)
;    ld b,a
;    ld a,(Velocidad_disparo_entidades)  ; No se genera disparo si (Vel_down) de la entidad es superior a_
;    cp b                                ; _ la velocidad del disparo de las entidades. La entidad se _
;    ret c                               ; _ atropellaría con su propio disparo.                               

;    ld a,(Columnas)
;    ld b,a
;    ld a,(Columns)
;    cp b
 ;   ret nz                              ; Salimos si la entidad no está completa en pantalla.                           

; ----- ----- ----- 

;    ld a,(Ctrl_0)                       
;    bit 6,a                             
;    jr nz,14F

;    ld a,(Coordenada_y)
;    cp $13                              ; Una entidad no podrá disparar si se encuentra por_
;    ret nc                              ; _ debajo de la fila "$14" de pantalla.

14 

;    ld hl,Indice_disparo
;    ld a,(CTRL_DESPLZ)
;    ld c,a
;    ld b,0	                            ; B será 0,1,2 o 3 en función del valor de (CTRL_DESPLZ).
;                                           Cuando (CTRL_DESPLZ)="0", B="0"
;                                            ""        ""       "f9", B="1"
;                                            ""        ""       "fb", B="2"
;                                            ""        ""       "fb", B="3"
;    and a
;    jr z,1F
;    and 1        
;    ret z                               ; Salimos si (CTRL_DESPLZ) es distinto de $00, $f9, $fb y $fd.

;    ld a,c
;    ld d,$f9
2 
;    inc hl
;    inc hl
;    inc b 	
;    cp d
;    jr z,1F
;    inc d
;    inc d
;    jr 2B

1 
;    call Extrae_address
;    push hl
;    pop iy                              ; Puntero_objeto_disparo en IY.
;	ld ix, Pinta_Disparo        		; Rutinas_de_impresion en IX.

;	Se cumplen las condiciones necesarias para generar un disparo.
;   Las variables de disparo varían en función del cuadrante en el que se encuentre la entidad/Amadeus.

;    ld a,(Ctrl_0)                       ; bit 6 NZ = "Amadeus". 
;    bit 6,a
;    jr nz,19F

;    xor a
;    ld (Disparo_entidad),a              ; Deshabilitamos el disparo de entidades.

19 
;    ld a,(Cuad_objeto)
;    cp 2
;    jr c,3F
;    jr z,3F

; 	Nos encontramos en la mitad inferior de la pantalla, (3er y 4º cuadrante).

;    and 1
;    jr z,4F

; 	Estamos en el 3er cuadrante de pantalla.
; 	3er CUAD. ----- ----- ----- ----- -----
;
;	En el 3er y 4º cuadrante de pantalla, cabe la posibilidad de que sea una entidad o Amadeus el que dispara.
;	En función del elemento que dispare variara el Puntero_de_impresión y su `Dirección'.
;   En estos cuadrantes también es posible que se genere `Colisión', hay que comprobarlo.

;	ld hl,(Posicion_actual)

;   Amadeus o entidad ???.

;    ld a,(Ctrl_0)
;    bit 6,a
;    jr z,8F

; 	Dispara Amadeus.

;    ld c,$81	                                    ; Dirección "$81", hacia arriba.                        
;    call PreviousScan
;    call PreviousScan

;	Ahora HL apunta 2 scanlines por encima de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 1º y3º de pantalla, sólo cuando (CTRL_DESPLZ)="$f9", B="1" ..... (DEC HL)*2. 
;   _ El resto de combinaciones, B="0","2" o "3" ..... DEC HL.

;    jr 10F

; 	Dispara Entidad.

8 
;    ld bc,$8080	                                    ; Dirección C="$80", hacia abajo.
;                                                   ; Impacto B="$80", no hay impacto.

; 	Guardamos el contenido de BC en la pila pues voy a utilizar el registro B como contador.
;   B contiene "0,1,2 o 3", dato necesario para fijar el puntero de impresión.

;    push bc
;    ld b,16
9 
;    call NextScan
;    djnz 9B
;    pop bc
;    call Ajusta_disparo_parte_izquierda
 ;   jr 17F

; 	Ahora HL apunta un scanline por debajo de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 1º y3º de pantalla, sólo cuando (CTRL_DESPLZ)="$f9", B="1" ..... (DEC HL)*2. 
;   _ El resto de combinaciones, B="0","2" o "3" ..... DEC HL.

10 
;;;;;    call Ajusta_disparo_parte_izquierda
;;;;;    call Comprueba_Colision                            ; Retorna "$81" o "$80" en B indicando si se produce Colisión
;                                                      ; _al generar el disparo.

; 	LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

17 
;;;;;    call Almacena_disparo                      
;;;;;    jr 6F                                             ; RET.
    
; 	Estamos en el 4º cuadrante de pantalla.
; 	4º CUAD. ----- ----- ----- ----- -----
;
;	En el 3er y 4º cuadrante de pantalla, cabe la posibilidad de que sea una entidad o Amadeus el que dispara.
;	En función del elemento que dispare variara el Puntero_de_impresión y su `Dirección'.
;   En estos cuadrantes también es posible que se genere `Colisión', hay que comprobarlo.

4 
;;;;;    ld hl,(Posicion_actual)

;   Amadeus o entidad ???. 

;;;;;    ld a,(Ctrl_0)
;;;;;    bit 6,a
;;;;;    jr z,11F

; 	Dispara Amadeus.

;;;;;    ld c,$81                                          ; Dirección "$81", hacia arriba.                        
;;;;    call PreviousScan
;;;;    call PreviousScan

; 	Ahora HL apunta 2 scanlines por encima de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 2º y 4º, cuando (CTRL_DESPLZ)="$fb" o "$fd"; B="2" y B="3" ..... (INC HL). 
;	En el resto de combinaciones, B="0" o "1", no se corrige el puntero de impresión.

;;;;    jr 13F
 
; 	Dispara Entidad.

11 
;;;;    ld bc,$8080                                        ; Dirección C="$80", hacia abajo.
;                                                     ; Impacto B="$80", no hay impacto.

; 	Guardamos el contenido de BC en la pila pues voy a utilizar el registro B como contador.
;   B contiene "0,1,2 o 3", dato necesario para fijar el puntero de impresión.

;;;;    push bc
;;;;    ld b,16
12 
;;;;    call NextScan
;;;;    djnz 12B
;;;;    pop bc

 ;;;;   call Ajusta_disparo_parte_derecha
;;;;    jr 18F

; 	Ahora HL apunta un scanline por debajo de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 2º y 4º, cuando (CTRL_DESPLZ)="$fb" o "$fd"; B="2" y B="3" ..... (INC HL). 
;	En el resto de combinaciones, B="0" o "1", no se corrige el puntero de impresión.

13 
;;;;    call Ajusta_disparo_parte_derecha
;;;;    call Comprueba_Colision                             ; Retorna "$81" o "$80" en B indicando si se produce Colisión
;                                                       ; _al generar el disparo.

; LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

18 
;;;    call Almacena_disparo                      
;;;    jr 6F                                               ; RET.

; 	La entidad que dispara se encuentra en la mitad superior de pantalla, (cuadrantes 1º y 2º).

3 
;;;    jr z,5F

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

;;;	ld hl,(Posicion_actual)
;;;	call NextScan

; 	Ahora HL apunta una FILA por debajo de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 1º y3º de pantalla, sólo cuando (CTRL_DESPLZ)="$f9", B="1" ..... (DEC HL)*2. 
;   _ El resto de combinaciones, B="0","2" o "3" ..... DEC HL.

;;    call Ajusta_disparo_parte_izquierda

; 	No se produce impacto. B="$80"
; 	Dirección del proyectil hacia abajo. C="$80" 

;;    ld bc,$8080                                     

; 	LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

;;    call Almacena_disparo                      
;;    jr 6F                                           ; RET.

; 	Estamos en el 2º cuadrante de pantalla.
; 	2º CUAD. ----- ----- ----- ----- -----
;
;	En el 1er y 2º cuadrante de pantalla, sólo cabe la posibilidad de que sea una entidad la que dispare,_
;	_ por lo tanto siempre se iniciara el disparo en la parte `baja´ del sprite.
;   La dirección del proyectil siempre será hacia abajo. En los cuadrante 1º y 2º no se comprueba colision_
;   _ pues sabemos que Amadeus sólo puede estar situado en los cuadrantes 3º y 4º.

5 
;;    ld hl,(Posicion_actual)
;;	call NextScan

; 	Ahora HL apunta una FILA por debajo de (Posicion_actual).
; 	En función de (CTRL-DESPLZ) variará, (en un char., a derecha o izquierda), el puntero de impresión.
; 	En los cuadrantes 2º y 4º, cuando (CTRL_DESPLZ)="$fb" o "$fd"; B="2" y B="3" ..... (INC HL). 
;	En el resto de combinaciones, B="0" o "1", no se corrige el puntero de impresión.

;    call Ajusta_disparo_parte_derecha

; 	No se produce impacto. B="$80"
; 	Dirección del proyectil hacia abajo. C="80" 

15 
;    ld bc,$8080 

; 	LLegados a este punto tendremos:
;
;       Puntero_objeto_disparo en IY.
;       Rutinas_de_impresion en IX.
;       Puntero_de_impresion en HL.
;       Impacto/Dirección en BC.

;    call Almacena_disparo                      

6 

    xor a                                           ;   Siempre "Z" cuando ejecutamos [Genera_disparo_Amadeus].

    ret

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

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 


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

    ld a,(Impacto)
    dec a
    ret z                                                  ; Salimos si la unidad que está en zona de Amadeus ya está impactada. 

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

;   HAY COLISIÓN !!!!!.
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
    inc l
    inc l
    inc l
    ld (hl),e
    inc l
    ld (hl),d

; Situamos también el (Puntero_de_almacen_de_mov_masticados) de Amadeus en la primero explosión.

    ld de,Indice_Explosion_Amadeus
    ld hl,Pamm_Amadeus
    ld (hl),e
    inc l
    ld (hl),d

    ret

; -----

;3 pop hl
;    call NextScan
;    push hl
;    ld a,h                                         ; El 1er scanline de la bala se pinta en pantalla.
;    cp $58                                         ; El 2º scanline indica colisión porque entra en zona_
;    jr z,1F                                        ; _ de atributos. Evitamos comprobar colisión en el _
 ;   jr nc,1F
;                                                  ; _ 2º scanline si esto es así.    
;    djnz 2B

; Aqui tengo que fabricar una rutina que ponga a "0" el .db (Impacto) de la entidad implicada.




 