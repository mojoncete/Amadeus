; ******************************************************************************************************************************************************************************************
;
;   19/10/22
;
;	Mov_down
;
; 	Mueve el Sprite X px hacia abajo.
;
;
Mov_down ld hl,Ctrl_0
	set 4,(hl) 														; Indicamos con el Bit4 de (Ctrl_0) que hay movimiento. Vamos a utilizar_
; 																	; _esta información para evitar que la entidad se vuelva borrar/pintar_
; 																	; _ en el caso de que no lo haya.
	ld a,(Vel_down)
	ld b,a
    ld hl,(Posicion_actual)	
2 call calcula_tercio 												; Averiguamos el tercio de pantalla en el que nos encontramos.
	and 2
	jr z,1F
	ld a,h
	cp $57
	jr nz,1F
	ld a,l
	add $20
	jr nc,1F

; ------------------------------
	call Reaparece_arriba
;	call Reinicio
; ------------------------------

	jr 3F
1 call NextScan
	ld (Posicion_actual),hl
    djnz 2B
3 call Genera_coordenadas
	ret


; ******************************************************************************************************************************************************************************************
;
;   19/10/22
;
;	Mov_up
;
; 	Mueve el Sprite hacia arriba.
;
;
Mov_up ld hl,Ctrl_0
	set 4,(hl) 															; Indicamos con el Bit4 de (Ctrl_0) que hay movimiento. Vamos a utilizar_
; 																		; _esta información para evitar que la entidad se vuelva borrar/pintar_
; 																		; _ en el caso de que no lo haya.
	ld a,(Vel_up)
	ld b,a
	ld hl,(Posicion_actual)	
3 call calcula_tercio 													; Si no estamos en el 1er tercio de la pantalla no nos preocupamos de la reaparición.
	and a
	jr nz,1F
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
	ld a,(CTRL_DESPLZ)
	and a
	jr z,10F

	ld a,(Ctrl_0)
	bit 7,a
	jr nz,10F														; Consultamos el último movimiento horizontal del SPRITE.
	ld hl,CTRL_DESPLZ
	dec (hl) 														; El último mov. horizontal ha sido a IZQUIERDA, corregimos (CTRL_DESPLZ).

10 ld a,(Ctrl_0)
	bit 6,a
	jr z,11F 														; Estamos moviendo Amadeus???????. Si es así hemos de comprobar que que no hemos llegado al char.30 de la línea, [Stop_Amadeus].

	call Stop_Amadeus_right
	ret z 															; Salimos de Mov_right si hemos llegado al char.30.
	jr 3F

11 ld a,(Coordenada_X)	 	  										; Estamos en el char. 31?								
	cp 31															; Si no es así, saltamos a [3] para seguir con el desplazamiento progrmado.
	jr nz,3F

	ld a,(CTRL_DESPLZ) 		 										; Estamos en el último char. de la línea. Si (CTRL_DESPLZ)="0" saltamos a_	 									
	and a 															; _[3] para continuar con el DESPLZ.
	jr z,3F 														 														

; ---------- ---------- ----------

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
	jr nz,3F
	jr 4F
1 ld a,(CTRL_DESPLZ) 												; Velocidad 2
	cp $fd
	jr nz,3F
	jr 4F
7 ld a,(CTRL_DESPLZ) 												; Velocidad 4
	cp $fb
	jr nz,3F

; ---------- ---------- ----------

4 call Reaparece_izquierda 											; Despues de haber actualizado la coordenada X del Sprite, (de 0 a 31). Si el movimiento es al char. _
;	call Reinicio

; ---------- ---------- ----------

	ld b,2 															; Para hacer que el objeto aparezca poco a poco, hemos de desplazarlo 2 veces: El primer desplazamiento_
5 push bc 															; _pone (CTRL_DESPLZ) a "0" y el segundo a "$ff". Con esto hacemos que el Sprite tenga espacio en blanco delante_
	call DESPLZ_DER
	pop bc
	djnz 5B
	ld hl,(Posicion_actual) 										; Decrementamos su posición actual, pués al desplazarlo a la derecha, volvemos a incrementar el nº de (Columns) y _
	dec hl 															; _ (Posicion_actual) ha pasado de $00 a $01.
	ld (Posicion_actual),hl
	jr 2F 															; Salimos para pintar la nueva posición.

; ---------- ---------- ----------

3 ld a,(Vel_right) 													; El objeto aún no ha llegado al último char. de la línea, (31).
	cp 8 															; Consultamos el perfil de velocidad. Si es distinto de "8" saltamos a [8] para seguir con el desplazamiento y actualizar coordenadas.
	jr nz,8F
	ld hl,(Posicion_actual) 										; (Vel_right)="8". Si no hemos llegado al último char. incrementamos HL, actualizamos coordenadas y salimos.
	ld a,l
	and $1f
	cp 31
	jr nz,9F

; ---------- ---------- ----------

	call Reaparece_izquierda
	
; ---------- ---------- ----------	
	
	jr 2F
9 ld hl,(Posicion_actual)
	inc hl
	ld (Posicion_actual),hl
	jr 2F
8 ld hl,(Posicion_actual)
	call DESPLZ_DER
2 call Genera_coordenadas
	ret

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
;	14/9/22
;

Desplaza_derecha ld a,(Vel_right)
	ld b,a
	ld hl,(Puntero_DESPLZ)
1 inc hl
	inc hl
	djnz 1B 														; (Vel_right) indica cuantas posiciones desplazaremos el (Puntero_DESPLZ)_
	ld (Puntero_DESPLZ),hl 											; _por el índice del Sprite.
	call Extrae_address

;	ld (Caja_de_DESPLZ),hl 											
	ld (Puntero_objeto),hl

	ret

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	24/7/22
;
;	modifica_parametros_1er_DESPLZ_2
;
;	La rutina modifica el nº de columnas del objeto en el 1er desplazamiento.
; 	También incrementa el byte de control de desplazamiento, (desplz. a derecha) y modifica la posición de (Puntero_datas) en función del cuadrante de pantalla en el que nos encontremos.
; 	Si el desplazamiento se produce en el 2º o 4º cuadrante, la rutina decrementará (Posicion_actual).

modifica_parametros_1er_DESPLZ_2 ld a,(CTRL_DESPLZ) 			  ; Incrementamos el nª de (Columns) cuando desplazamos el objeto por 1ª vez.
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
	jr 3f
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

2 ld hl,(Indice_Sprite)
	ld (Puntero_DESPLZ),hl
	call Extrae_address
	ld (Puntero_objeto),hl

3 ret

; ******************************************************************************************************************************************************************************************
;
;	19/10/22
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
	ld a,(CTRL_DESPLZ)
	and a
	jr nz,10F

	ld hl,(Puntero_objeto)
	ld (Puntero_DESPLZ),hl 											; Cuando nos desplazamos a la izquierda, (Puntero_DESPLZ) se sitúa al final del índice del Sprite. El objeto es simétrico.

	ld a,(Ctrl_0)
	bit 6,a
	jr z,3F 														; Estamos moviendo Amadeus???????. Si es así hemos de comprobar que que no hemos llegado al char.1 de la línea, [Stop_Amadeus].

	call Stop_Amadeus_left
	jr nz,3F

	ld hl,(Indice_Sprite) 											; Hemos llegado al char.1, volvemos a situar (Puntero_DESPLZ) al principio del índice del sprite, pues la única posibilidad_ 
	ld (Puntero_DESPLZ),hl 											; _de movimiento es hacia la derecha.
	ret

10 ld a,(Ctrl_0)
	bit 7,a
	jr z,11F														; Consultamos el último movimiento horizontal del SPRITE.
	ld hl,CTRL_DESPLZ
	inc (hl) 														; El último mov. horizontal ha sido a IZQUIERDA, corregimos (CTRL_DESPLZ).
	
11 ld a,(Coordenada_X)	 	 								
	and a 															
	jr nz,3F
	ld a,(CTRL_DESPLZ) 			 									; Si el Sprite no está en el 1er char de la línea, (desaparece por la izquierda), o estando en este, _
	and a 															; _ (CTRL_DESPLZ)="0", cargamos HL con la (Posicion_actual) y ejecutamos la rutina de desplazamiento, _
	jr z,3F 														; _ pués aún podemos desplazarlo antes de desaparecer.

; ---------- ---------- ----------

	ld a,(Vel_left)
	cp 2
	jr z,1F
	jr c,6F
	cp 4
	jr z,7F

; ---------- ---------- ----------

6 ld a,(CTRL_DESPLZ)
	cp $f9 															
	jr nz,3F
	jr 4F
1 ld a,(CTRL_DESPLZ) 												
	cp $fa
	jr nz,3F
	jr 4F
7 ld a,(CTRL_DESPLZ)
	cp $fc
	jr nz,3F

; ---------- ---------- ----------

4 call Reaparece_derecha 											; Despues de haber actualizado la coordenada X del Sprite, (de 0 a 31). Si el movimiento es al char. _
;	call Reinicio

; ---------- ---------- ----------

	ld b,2 															; Para hacer que el objeto aparezca poco a poco, hemos de desplazarlo 2 veces: El primer desplazamiento_
5 push bc 															; _pone (CTRL_DESPLZ) a "0" y el segundo a "$ff". Con esto hacemos que el Sprite tenga espacio en blanco delante_
	ld hl,(Puntero_objeto)
	ld (Puntero_DESPLZ),hl
	call DESPLZ_IZQ
	pop bc
	djnz 5B
	ld hl,(Posicion_actual) 										; Incrementamos su posición actual, pués al desplazarlo a la izquierda, volvemos a incrementar el nº de (Columns) y _
	inc hl 															; _ (Posicion_actual) ha pasado de $1f a $1e.
	ld (Posicion_actual),hl
	jr 2F 															; Salimos para pintar la nueva posición.

; ---------- ---------- ----------

3 ld a,(Vel_left)
	cp 8
	jr nz,8F
	ld hl,(Posicion_actual)
	ld a,l
	and $1f
	jr nz,9F

; ---------- ---------- ----------

	call Reaparece_derecha

; ---------- ---------- ----------

	jr 2F
9 ld hl,(Posicion_actual)
	dec hl
	ld (Posicion_actual),hl
	jr 2F
8 ld hl,(Posicion_actual)
	call DESPLZ_IZQ
2 call Genera_coordenadas 
	ret

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	22/9/22

DESPLZ_IZQ call Desplaza_izquierda
    call modifica_parametros_1er_DESPLZ
	call Ciclo_completo_2
	ld hl,Ctrl_0 													; Indica que nos hemos desplazado a la izquierda
	res 7,(hl)
	ret

Desplaza_izquierda ld a,(Vel_left)
	ld b,a
	ld hl,(Puntero_DESPLZ)
1 dec hl
	dec hl
	djnz 1B 														; Seleccionamos FRAME en función de la velocidad del Sprite.
	ld (Puntero_DESPLZ),hl
	call Extrae_address
	ld (Caja_de_DESPLZ),hl 											
	ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	modifica_parametros_1er_DESPLZ
;
;	La rutina modifica el nº de columnas del objeto en el 1er desplazamiento.
; 	También decrementa el byte de control de desplazamiento, (desplz. a izq) y modifica la posición de (Puntero_datas) en función del cuadrante de pantalla en el que nos encontremos.
; 	Si el desplazamiento se produce en el 2º o 4º cuadrante, la rutina decrementará (Posicion_actual).

modifica_parametros_1er_DESPLZ ld a,(CTRL_DESPLZ) 				  ; Incrementamos el nª de (Columns) cuando desplazamos el objeto por 1ª vez.
	and a
	jr nz,1F
	ld hl,Columns 												  
	inc (hl)
	ld a,(Cuad_objeto)
	and 1
	jr nz,1F
	ld hl,(Posicion_actual) 									  ; Decrementamos 1 char. el valor de (Posicion_actual), la primera vez que desplazamos el objeto y se encuentra en los _	
	dec hl 														  ; _ cuadrantes 2 y 4 de pantalla.
	ld (Posicion_actual),hl
	call Dec_CTRL_DESPLZ
	jr 2F
1 call Dec_CTRL_DESPLZ
2 ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
Ciclo_completo_2 ld a,(CTRL_DESPLZ)
	cp $f8
	jr z,1F 												        ; Salimos de la rutina si no hemos completado 8 o más desplazamientos.
	jr 3f
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
2 call Genera_coordenadas
3 ret

; ---------- ---------- ---------- ---------- ---------- ----------
;
;	Dec_CTRL_DESPLZ
;
;	Subrutina de [modifica_punteros].
;
;	Decrementa el valor del byte de control, (CTRL_DESPLZ) en función del nº de veces que hayamos desplazado el objeto, (Vel_left).	

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
;	Subrutina de [modifica_punteros].
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

Reinicio ld hl,(Posicion_inicio)

;	ld (Posicion_actual),hl
	ld hl,0
	ld (Posicion_actual),hl
	

	ret	