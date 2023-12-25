; ******************************************************************************************************************************************************************************************
;
;   20/05/23
;
;	Recompone_posicion_inicio
;
; 	La rutina hace una llamada a [Mov_right] o [Mov_left] según su posición de inicio.
;	Así conseguimios que la entidad esté completamente oculta a la hora de aparecer por la izquierda_
;	_ o derecha. Tomaremos la columna de (Posicion_inicio) como referencia para hacer la llamada_
;	_ a una u otra rutina.

Recompone_posicion_inicio 

	ld hl,(Posicion_inicio) 
	ld a,l
	and $1f
	jr z,1F

	cp $1f
	jr z,3F

	ld hl,Ctrl_2
	set 0,(hl)
	ld hl,(Puntero_objeto)
	ld (Repone_puntero_objeto),hl
	jr 2F

3 call Mov_left
	jr 2F

1 call Mov_right
2 ld hl,Sprite_vacio
	ld (Puntero_objeto),hl
	ret

; ******************************************************************************************************************************************************************************************
;
;   27/05/23
;
;	Mov_down
;
; 	Mueve el Sprite X px hacia abajo.
;
;
Mov_down 

	call Reponne_punntero_objeto									; Si la entidad no se inició en la 1ª o última columna de pantalla,_
;																	; _ repone (Puntero_objeto).
	ld hl,Ctrl_0
	set 4,(hl) 														; Indicamos con el Bit4 de (Ctrl_0) que hay movimiento. Vamos a utilizar_
; 																	; _esta información para evitar que la entidad se vuelva borrar/pintar_
; 																	; _ en el caso de que no lo haya.
	ld a,(Vel_down)
	ld b,a
    ld hl,(Posicion_actual)	
2 call calcula_tercio 												; Averiguamos el tercio de pantalla en el que nos encontramos.
	and 2
	jr z,1F

; Nos encontramos en el último tercio de pantalla.
; Averiguamos si estamos en el último scanline de la última línea de pantalla.

	ld a,h
	cp $57
	jr nz,1F

	ld a,l
	add $20
	jr nc,1F 														

; ------------------------------
;
;	17/12/15

;	call Reaparece_arriba
	call Reinicio

;	Homos generado todos los movimientos posibles de esta entidad.
;	Si se trata de una Entidad_guía dejará de serlo.

	ld a,(Ctrl_3)
	bit 3,a
	jr nz,3F
	bit 2,a
	jr nz,3F
	
	ld a,(Ctrl_2)
	bit 5,a
	jr z,3F

	res 5,a
	ld (Ctrl_2),a
	ld hl,Ctrl_3
	res 1,(hl)
	set 2,(hl)												; Indica que una Entidad_guía a generado todos sus "movimientos masticados".
;															; El bit2 de (Ctrl_3) evita que la rutina [Main], (cuando gestione entidades), coloque_
;															; _a la siguiente entidad como "Entidad_guía".
;	Reinicializa (Puntero_de_almacen_de_mov_masticados).

4 ld hl,Almacen_de_movimientos_masticados_Entidad_1
	ld (Puntero_de_almacen_de_mov_masticados),hl 			; Reinicializa (Puntero_de_almacen_de_mov_masticados). Sitúa el puntero_

	jr 3F
;															; _ al principio del almacén, (a partir de ahora ejecutaremos "movimientos masticados").
;															; Ya no somos "Entidad_guía".
; ------------------------------


1 call NextScan
	ld (Posicion_actual),hl
    djnz 2B
3 call Genera_coordenadas
	ret

; ******************************************************************************************************************************************************************************************
;
;   27/05/23
;
;	Mov_up
;
; 	Mueve el Sprite hacia arriba.
;
;
Mov_up 

	call Reponne_punntero_objeto										; Si la entidad no se inició en la 1ª o última columna de pantalla,_
;																		; _ repone (Puntero_objeto).	call Reponne_punntero_objeto
	ld hl,Ctrl_0
	set 4,(hl) 															; Indicamos con el Bit4 de (Ctrl_0) que hay movimiento. Vamos a utilizar_
; 																		; _esta información para evitar que la entidad se vuelva borrar/pintar_
; 																		; _ en el caso de que no lo haya.
	ld a,(Vel_up)
	ld b,a
	ld hl,(Posicion_actual)	
3 call calcula_tercio 													; Si no estamos en el 1er tercio de la pantalla no nos preocupamos de la reaparición.
	and a
	jr nz,1F

; Nos encontramos en el 1er tercio de pantalla.
; Averiguamos si estamos en el primer scanline de la primera línea de pantalla.

    ld a,h 																; Si estamos en el 1er tercio de pantalla pero no nos encontramos en el 1er scanline_
    cp $40 																; _del mismo, podemos seguir subiendo.
    jr nz,1F
    ld a,l
    sub $20
    jr nc,1F
    dec h

; -----------------------------
    call Reaparece_abajo                                                ; El objeto ha desaparecido por la parte superior de la pantalla, H="$3f". Hacemos llamada a _
;	call Reinicio
; -----------------------------

    jr 2F                                                               ; _ [Reaparece_abajo] para preparar la `reaparición´ por la parte inferior.
1 call PreviousScan
	ld (Posicion_actual),hl
    djnz 3B
2 call Genera_coordenadas
	ret

; -----------------------------
;
;	27/5/23
;
;	Si la rutina [Recompone_posicion_inicio] no inició la entidad en la 1ª o última columna de pantalla,_
;	_restaurará (Puntero_objeto) con el contenido de (Repone_puntero_objeto).
;
;	Esta rutina sólo será llamada desde las rutinas de movimiento vertical, [Mov_down] y [Mov_up].
;	Las rutinas [Mov_left] y [Mov_right] modifican (Puntero_objeto) cada vez que se ejecutan.
;
;	Modifica: A y (Puntero_objeto).

Reponne_punntero_objeto	ld a,(Ctrl_2) 													
	bit 0,a
	ret z
	res 0,a
	ld (Ctrl_2),a
	ld hl,(Repone_puntero_objeto)
	ld (Puntero_objeto),hl
	ret

; ******************************************************************************************************************************************************************************************
;
;	19/10/22
;
;	Mov_right.
;
; 	Desplaza el Sprite (x)Pixels a la derecha.
;

Mov_right ld hl,Ctrl_0
	set 4,(hl) 														; Indicamos con el Bit4 de (Ctrl_0) que hay movimiento. Vamos a utilizar_
; 																	; _esta información para evitar que la entidad se vuelva borrar/pintar_
; 																	; _ en el caso de que no lo haya.
	ld a,(Ctrl_0)
	bit 6,a
	jr z,10F 														; Estamos moviendo Amadeus???????. Si es así hemos de comprobar que no hemos llegado al char.30 de la línea, [Stop_Amadeus].

	call Stop_Amadeus_right
	ret z 															; Salimos de Mov_right si hemos llegado al char.30.
	jr 8F

10 ld a,(Coordenada_X)	 	  										; Estamos en el char. 31?								
	cp 31															; Si no es así, saltamos a [3] para seguir con el desplazamiento progrmado.
	jr nz,8F

	ld a,(CTRL_DESPLZ) 		 										; Estamos en el último char. de la línea. Si (CTRL_DESPLZ)="0" saltamos a_	 									
	and a 															; _[3] para continuar con el DESPLZ.
	jr z,8F 														 														

; ---------- ---------- ----------
;
;	Estamos en el último char. de la fila y (CTRL_DESPLZ) es distinto de "0".

	ld a,(Vel_right) 												; En función del factor de velocidad, iniciaremos la salida de la pantalla,_									;
	cp 2 															; _(Reaparece_izquierda), cuando (CTRL_DESPLZ) alcance un valor determinado.
	jr z,1F
	jr c,6F
	cp 4
	jr z,7F
	jr $ 															; Sólo se permite velocidad 1,2,4 y 8.

; ---------- ---------- ----------
;
; Perfiles de velocidad
;

6 ld a,(CTRL_DESPLZ) 												; Velocidad 1
	cp $fe 															
	jr nz,8F
	jr 3F
1 ld a,(CTRL_DESPLZ) 												; Velocidad 2
	cp $fd
	jr nz,8F
	jr 3F
7 ld a,(CTRL_DESPLZ) 												; Velocidad 4
	cp $fb
	jr nz,8F

; ---------- ---------- ----------

3 
	call Reaparece_izquierda 										; Despues de haber actualizado la coordenada X del Sprite, (de 0 a 31). Si el movimiento es al char. _
;	call Reinicio

; ---------- ---------- ----------
;
;	Esta parte de la rutina se encarga de hacer que el Sprite aparezca pixel a pixel por la izquierda.

	ld b,2 															; Para hacer que el objeto aparezca poco a poco, hemos de desplazarlo 2 veces: El primer desplazamiento_
5 push bc 															; _pone (CTRL_DESPLZ) a "0" y el segundo a "$ff". Con esto hacemos que el Sprite tenga espacio en blanco delante_
	call DESPLZ_DER
	pop bc
	djnz 5B
	ld hl,(Posicion_actual) 										; Decrementamos su posición actual, pués al desplazarlo a la derecha, volvemos a incrementar el nº de (Columns) y _
	dec hl 															; _ (Posicion_actual) ha pasado de $00 a $01.
	ld (Posicion_actual),hl
	call Genera_coordenadas
	jr 2F 															; Salimos para pintar la nueva posición.

; ---------- ---------- ----------

8 ld hl,(Posicion_actual)
	call DESPLZ_DER
2 ret

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	22/9/22
;

DESPLZ_DER call Desplaza_derecha
    call modifica_parametros_1er_DESPLZ_2
    call Ciclo_completo
	ld hl,Ctrl_0 													; Indica que nos hemos desplazado a la derecha.
	set 7,(hl)
	ret

; ******************************************************************************************************************************************************************************************
;	15/02/23
;

Desplaza_derecha ld a,(Vel_right)
	ld b,a
	ld hl,(Puntero_DESPLZ_der)
1 inc hl
	inc hl
	djnz 1B 														; (Vel_right) indica cuantas posiciones desplazaremos el (Puntero_DESPLZ)_
	ld (Puntero_DESPLZ_der),hl 										; _por el índice del Sprite.
	call Extrae_address
	ld (Puntero_objeto),hl

; Modifica (Puntero_DESPLZ_izq).

; Vamos a descontar a "8" el nº de movimientos que hemos efectuado a la derecha.
; Cuántos movimientos hemos hecho ??
; DE contiene (Puntero_DESPLZ_der).

7 ld hl,(Indice_Sprite_der)
	ex de,hl
	and a
	sbc hl,de
	srl l
6 ld a,8
	sub l
	jr nc,3F	

; Hemos salido del índice. Hay que ajustar (Puntero_DESPLZ_der) dentro del mismo.
; B="0".

4 inc b
	inc a
	jr nz,4B
	ld a,b
	ex af,af
	ld hl,(Indice_Sprite_der)
5 inc hl
	inc hl
	djnz 5B
	ld (Puntero_DESPLZ_der),hl
	call Extrae_address
	ld (Puntero_objeto),hl			

; Si nos hemos salido del índice es porque hemos completado un ciclo completo. Habrá que actualizar_
; _(Posicion_actual).

	ld hl,Posicion_actual
	inc (hl)
    ex af,af
	ld l,a
	jr 6B	

; Permanecemos en el índice. No hay que reajustar (Puntero_DESPLZ_izq).
	
3 ld b,a
	ld hl,(Indice_Sprite_izq)
2 inc hl
	inc hl
	djnz 2B 													 	
	ld (Puntero_DESPLZ_izq),hl
8 ret

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	24/7/22
;
;	modifica_parametros_1er_DESPLZ_2
;
;	La rutina modifica el nº de columnas del objeto en el 1er desplazamiento.
; 	También incrementa el byte de control de desplazamiento, (desplz. a derecha) y modifica la posición de (Puntero_datas) en función del cuadrante de pantalla en el que nos encontremos.
; 	Si el desplazamiento se produce en el 2º o 4º cuadrante, la rutina decrementará (Posicion_actual).

modifica_parametros_1er_DESPLZ_2 ld a,(CTRL_DESPLZ)		 		  ; Incrementamos el nª de (Columns) cuando desplazamos el objeto por 1ª vez.
	and a
	jr nz,1F
    sub 9                							              ; Situamos en $f7 el valor de partida de (CTRL_DESPLZ) tras el 1er desplazamiento. 
    ld (CTRL_DESPLZ),a

	ld hl,Columns 												  
	inc (hl)
	ld a,(Cuad_objeto)
	and 1
	jr z,1F
	ld hl,(Posicion_actual) 									  ; Incrementamos 1 char. el valor de (Posicion_actual), la primera vez que desplazamos el objeto y se encuentra en los _	
	inc hl 														  ; _ cuadrantes 1 y 3 de pantalla.
	ld (Posicion_actual),hl
	call Genera_coordenadas
	call Inc_CTRL_DESPLZ
	jr 2F
1 call Inc_CTRL_DESPLZ
2 ret

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	24/7/22
;
;	Ciclo_completo.
;
;	FUNCIONAMIENTO: Si (CTRL_DESPLZ)="$ff" significa que nos hemos desplazado 1 char.
;
;	En ese caso, inicializamos (CTRL_DESPLZ). (CTRL_DESPLZ)="0".
; 	Decrementamos (Columns).
;	Modificamos (Posicion_actual) en función del cuadrante en el que nos encontremos.
;	Borramos la caja de desplazamientos, call Limpia_caja_de_DESPLZ.		 


Ciclo_completo ld a,(CTRL_DESPLZ)
	cp $ff
	jr z,1F 												     ; Salimos de la rutina si no hemos completado 8 o más desplazamientos.
	and $f0
	jr nz,3F

; (CTRL_DESPLZ) fuera de rango, (por encima de $ff), hay que reajustar.	

	ld a,(CTRL_DESPLZ)
	ld b,a
	ld a,$f8
	add b
	ld (CTRL_DESPLZ),a 
	jr 3F
1 ld hl,Columns													 ; Tras 8 desplazamientos el objeto desplazado es igual al original.
	dec (hl) 													 ; Decrementamos el nº de (Columns).
	xor a 														 ; Reiniciamos (CTRL_DESPLZ).
	ld (CTRL_DESPLZ),a 
	ld a,(Cuad_objeto) 											 ; Si estamos situados en el cuadrante 1º o 3º de la pantalla no modificamos_
	and 1 														 ; _(Posicion_actual). Limpiamos la (Caja_de_DESPLZ) y salimos.
	jr nz,2F
	ld hl,(Posicion_actual)                                      ; Incrementamos (Posicion_actual) en los cuadrantes 2º y 4º.
	inc hl
	ld (Posicion_actual),hl
	call Genera_coordenadas

; Inicia el puntero de Sprite.

2 call Inicia_puntero_objeto_der
3 ret

; ******************************************************************************************************************************************************************************************
;
;	15/02/23
;
;	Mov_left.
;
; 	Desplaza el Sprite (x)Pixels a la izquierda.
;
Mov_left 

	ld hl,Ctrl_0
	set 4,(hl) 														; Indicamos con el Bit4 de (Ctrl_0) que hay movimiento. Vamos a utilizar_
; 																	; _esta información para evitar que la entidad se vuelva borrar/pintar_
; 																	; _ en el caso de que no lo haya.
	ld a,(Ctrl_0)
	bit 6,a
	jr z,11F 														; Estamos moviendo Amadeus???????. Si es así hemos de comprobar que que no hemos llegado al char.1 de la línea, [Stop_Amadeus].

	call Stop_Amadeus_left
	ret z
	jr nz,8F

11 ld a,(Coordenada_X)	 	 								
	and a 															
	jr nz,8F

	ld a,(CTRL_DESPLZ) 			 									; Si el Sprite no está en el 1er char de la línea, (desaparece por la izquierda), o estando en este, _
	and a 															; _ (CTRL_DESPLZ)="0", cargamos HL con la (Posicion_actual) y ejecutamos la rutina de desplazamiento, _
	jr z,8F 														; _ pués aún podemos desplazarlo antes de desaparecer.

; ---------- ---------- ----------

	ld a,(Vel_left)
	cp 2
	jr z,1F
	jr c,6F
	cp 4
	jr z,7F

; ---------- ---------- ----------

6 ld a,(CTRL_DESPLZ)
	cp $f8 														
	jr nz,8F
	jr 4F
1 ld a,(CTRL_DESPLZ) 												
	cp $f9
	jr nz,8F
	jr 4F
7 ld a,(CTRL_DESPLZ)
	cp $fb
	jr nz,8F

; ---------- ---------- ----------

4 
	call Reaparece_derecha 											; Despues de haber actualizado la coordenada X del Sprite, (de 0 a 31). Si el movimiento es al char. _
;	call Reinicio

; ---------- ---------- ----------

	ld b,2 															; Para hacer que el objeto aparezca poco a poco, hemos de desplazarlo 2 veces: El primer desplazamiento_
5 push bc 															; _pone (CTRL_DESPLZ) a "0" y el segundo a "$ff". Con esto hacemos que el Sprite tenga espacio en blanco delante_

;	ld hl,(Indice_Sprite_izq)			
;	ld (Puntero_DESPLZ_izq),hl

	call DESPLZ_IZQ
	pop bc
	djnz 5B
	ld hl,(Posicion_actual) 										; Incrementamos su posición actual, pués al desplazarlo a la izquierda, volvemos a incrementar el nº de (Columns) y _
	inc hl 															; _ (Posicion_actual) ha pasado de $1f a $1e.
	ld (Posicion_actual),hl
	call Genera_coordenadas
	jr 2F 															; Salimos para pintar la nueva posición.

; ---------- ---------- ----------

; Movemos, no hay recolocación.

8 ld hl,(Posicion_actual)
	call DESPLZ_IZQ
2 ret

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	22/9/22

DESPLZ_IZQ 

	call Desplaza_izquierda
    call modifica_parametros_1er_DESPLZ
	call Ciclo_completo_2
	ld hl,Ctrl_0 													; Indica que nos hemos desplazado a la izquierda
	res 7,(hl)
	ret

Desplaza_izquierda 

	ld a,(Vel_left)
	ld b,a
	ld hl,(Puntero_DESPLZ_izq)
1 inc hl
	inc hl
	djnz 1B 														; Seleccionamos FRAME en función de la velocidad del Sprite.
	ld (Puntero_DESPLZ_izq),hl
	call Extrae_address
	ld (Puntero_objeto),hl		

; Modifica (Puntero_DESPLZ_der).

; Vamos a descontar a "8" el nº de movimientos que hemos efectuado a la izq.
; Cuántos movimientos hemos hecho ??
; DE contiene (Puntero_DESPLZ_izq).

7 ld hl,(Indice_Sprite_izq)
	ex de,hl
	and a
	sbc hl,de
	srl l
6 ld a,8
	sub l
	jr nc,3F	

; Hemos salido del índice. Hay que ajustar (Puntero_DESPLZ_izq) dentro del mismo.
; B="0".

4 inc b
	inc a
	jr nz,4B
	ld a,b
	ex af,af
	ld hl,(Indice_Sprite_izq)
5 inc hl
	inc hl
	djnz 5B
	ld (Puntero_DESPLZ_izq),hl
	call Extrae_address
	ld (Puntero_objeto),hl			

; Si nos hemos salido del índice es porque hemos completado un ciclo completo. Habrá que actualizar_
; _(Posicion_actual).

	ld hl,Posicion_actual
	dec (hl)
	ex af,af
	ld l,a
	jr 6B

; Permanecemos en el índice. No hay que reajustar (Puntero_DESPLZ_izq).

3 ld b,a
	ld hl,(Indice_Sprite_der)
2 inc hl
	inc hl
	djnz 2B 													 	
	ld (Puntero_DESPLZ_der),hl
8 ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	modifica_parametros_1er_DESPLZ
;
;	La rutina modifica el nº de columnas del objeto en el 1er desplazamiento.
; 	También decrementa el byte de control de desplazamiento, (desplz. a izq) y modifica la posición de (Puntero_datas) en función del cuadrante de pantalla en el que nos encontremos.
; 	Si el desplazamiento se produce en el 2º o 4º cuadrante, la rutina decrementará (Posicion_actual).

modifica_parametros_1er_DESPLZ ld a,(CTRL_DESPLZ) 				    ; Incrementamos el nª de (Columns) cuando desplazamos el objeto por 1ª vez.
	and a
	jr nz,1F
    dec a              							            	    ; Situamos en $f7 el valor de partida de (CTRL_DESPLZ) tras el 1er desplazamiento. 
    ld (CTRL_DESPLZ),a
	ld hl,Columns 												  
	inc (hl)
	ld a,(Cuad_objeto)
	and 1
	jr nz,1F
	ld hl,(Posicion_actual) 									    ; Decrementamos 1 char. el valor de (Posicion_actual), la primera vez que desplazamos el objeto y se encuentra en los _	
	dec hl 														    ; _ cuadrantes 2 y 4 de pantalla.
	ld (Posicion_actual),hl
	call Genera_coordenadas
	call Dec_CTRL_DESPLZ
	jr 2F
1 call Dec_CTRL_DESPLZ
2 ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Ciclo_completo_2 ld a,(CTRL_DESPLZ)
	cp $f7
	jr z,1F 												   		; Salimos de la rutina si no hemos completado 8 o más desplazamientos.
	jr nc,3F

; (CTRL_DESPLZ) fuera de rango, (por debajo de $f7), hay que reajustar.

	ld b,0
4 inc b
	inc a
	cp $f7
	jr nz,4B
	ld a,$ff
	sub b
	ld (CTRL_DESPLZ),a
	jr 3F

; Se completa el ciclo de movimiento. (CTRL_DESPLZ)="0", se generan coordenadas y se corrige (Posicion_actual).

1 ld hl,Columns
	dec (hl)
	xor a
	ld (CTRL_DESPLZ),a
	ld a,(Cuad_objeto)
	and 1
	jr z,2F
	ld hl,(Posicion_actual)                                         ; Decrementamos (Posicion_actual) en los cuadrantes 2º y 4º.
	dec hl
	ld (Posicion_actual),hl
	call Genera_coordenadas

; Inicia (Puntero_DESPLZ_izq) y (Puntero_objeto).

2 call Inicia_puntero_objeto_izq 
3 ret

; ---------- ---------- ---------- ---------- ---------- ----------
;
;	19/10/22
;
;	(cp 29) para un Amadeus de 3 Columns.
;	(cp 30)   ""  ""    ""     2 Columns.

Stop_Amadeus_right ld a,(Coordenada_X)	 	  										 ; Posición horizontal de Amadeus.							
	cp 30																			 ; Hemos llegado al límite derecho de la pantalla??.
	ret

; ---------- ---------- ---------- ---------- ---------- ----------
;
;	19/10/22
;
;	(cp 2) para un Amadeus de 3 Columns.
;	(cp 1)   ""  ""    ""     2 Columns.

Stop_Amadeus_left ld a,(Coordenada_X)	 	  										 ; Posición horizontal de Amadeus.							
	cp 1																			 ; Hemos llegado al límite izquierdo de la pantalla??. 
	ret

; ---------- ---------- ---------- ---------- ---------- ----------
;
;	24/7/22
;
;	Inc_CTRL_DESPLZ
;
;
;   Incrementa el valor del byte de control, (CTRL_DESPLZ) en función del nº de veces que hayamos desplazado el objeto, (Vel_right).	

Inc_CTRL_DESPLZ ld hl,CTRL_DESPLZ 													
	ld a,(Vel_right)
	and a
	jr z,1F
	ld b,a
3 inc (hl)	 								 						 
	djnz 3B
	jr 2F
1 inc (hl)
2 ret

; ---------- ---------- ---------- ---------- ---------- ----------
;
;	5/2/23
;
;	Dec_CTRL_DESPLZ
;
;
;   Decrementa el valor del byte de control, (CTRL_DESPLZ) en función del nº de veces que hayamos desplazado el objeto, (Vel_right).	

Dec_CTRL_DESPLZ ld hl,CTRL_DESPLZ													
	ld a,(Vel_left)
	and a
	jr z,1F
	ld b,a
3 dec (hl)	 								 						 
	djnz 3B
	jr 2F
1 dec (hl)
2 ret

; ---------- ---------- ---------- ---------- ---------- ----------

Reaparece_derecha ld hl,(Posicion_actual)	 					
	ld bc,31 														
	and a
	adc hl,bc
	ld (Posicion_actual),hl
	ld hl,Ctrl_0														; $xxx1
	set 0,(hl)
	ret

; ---------- ---------- ---------- ---------- ---------- ----------

Reaparece_izquierda ld hl,(Posicion_actual)	 					
	ld bc,31 														
	and a
	sbc hl,bc
	ld (Posicion_actual),hl 											; $xx1x
	ld hl,Ctrl_0
	set 1,(hl)
	ret

; ---------- ---------- ---------- ---------- ---------- ----------

Reaparece_abajo inc h
	ld bc,$17e0
	and a
	adc hl,bc
	ld (Posicion_actual),hl
	ld hl,Ctrl_0
	set 2,(hl)
	ret

; ---------- ---------- ---------- ---------- ---------- ----------

Reaparece_arriba ld bc,$17e0
	and a
	sbc hl,bc
	ld (Posicion_actual),hl
	ld hl,Ctrl_0
	set 3,(hl)
	ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	15/07/23

Reinicio 

; Vamos a reiniciar los punteros y variables de movimiento.

	xor a
	ld hl,Puntero_indice_mov_bucle
	call Limpia_contenido_hl

	ld hl,Posicion_actual
	call Limpia_contenido_hl

	call Inicializa_Puntero_indice_mov
	call Inicia_Puntero_mov

	ld hl,Incrementa_puntero
	ld b,5
1 ld (hl),a
	inc hl
	djnz 1B

	ld hl,Ctrl_2
	res 2,(hl)							; El movimiento de la entidad, deja de estar iniciado.

	ret

Limpia_contenido_hl	ld (hl),a
	inc hl
	ld (hl),a
	ret	
	
	