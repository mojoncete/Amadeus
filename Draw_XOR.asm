; ******************************************************************************************************************************************************************************************
;
; 26/06/23
;
; DRAW. ************************************************************************************************************************************************************************************

Draw 

	call Prepara_draw 
	ld a,h 						 					; El objeto existe, o se está iniciando?. Si se está iniciando, (Posicion_inicio = Posicion_actual) y saltamos_
	and a 											; _a la subrutina [Inicializacion] donde asignaremos cuadrante y límites.
	jr z,2F

	ld a,(Cuad_objeto)			 					; El objeto ya se inició. Cargamos en A el cuadrante de pantalla en el que lo hizo y saltamos a 1F.
	jr 1F

2 ld hl,(Posicion_inicio) 							; No hay (Posicion_actual), por lo que el objeto se está iniciando.
	ld (Posicion_actual),hl							; Indicamos que (Posicion_actual) = (Posicion_inicio) y saltamos a la subrutina [Inicializacion], (donde asignaremos_			
	call Inicializacion   							; _(Limite_horizontal), (Limite_vertical) y (Cuad_objeto). También asignaremos las coordenadas X e Y. (Posición 0,0)_
;													; _la esquina superior izquierda de la pantalla.	

	call Inicia_Puntero_mov							; El objeto está inicializado. Antes de salir inicializamos tb el puntero de movimiento de la entidad.

1 ld a,(Ctrl_0)
	bit 5,a
	jr nz,3F										; Si acabamos de inicializar un objeto, NO COMPROBAMOS LÍMITES. 

	call Comprueba_limite_horizontal   				
	call Comprueba_limite_vertical

; Llegados a este punto, tengo Filas/Columnas en BC y (Cuad_objeto) en A´.
; -----------------------
; -----------------------
; -----------------------

3 call calcula_CColumnass							; Define el valor de la variable (Columnas). Nº de columnas que se van a pintar de la entidad.
	call Calcula_puntero_de_impresion				; Después de ejecutar esta rutina tenemos el puntero de impresión en HL.

	ld a,(Ctrl_0)									; Antes de salir de la rutina REStauramos el bit5 de Ctrl_0 para que nos vuelva_
	res 5,a											; _a ser de utilidad.
	ld (Ctrl_0),a

	ret

; *******************************************************************************************************************************************************************************************
;	21/01/23
;
; 	Comprueba_limite_horizontal.
;
;	La rutina comprueba si hemos sobrepasado el (Limite_horizontal) definido en la rutina [Inicializacion]. Este será:_
;	_ $4fc0 si partimos de los cuadrantes 1 o 2 de pantalla o $4820 si partimos de los cuadrantes 3 o 4.
; 
;	Si sobrepasamos o alcanzamos el límite horizontal establecido, la rutina cargará el registro E con un "1".
;	Si NO HEMOS SOBREPASADO (Limite_horizontal), E="0".
;	E="1" indica que HEMOS SOBREPASADO el (Limite_horizontal).
;	E="2" indica que NO HEMOS SOBREPASADO el (Limite_horizontal) pero hemos alcanzado o superado EL CENTRO DE PANTALLA.



Comprueba_limite_horizontal ld a,(Ctrl_0)          	; Si no hemos desaparecido por arriba o por abajo, saltamos a 1F para comprobar_ 
	bit 2,a                                         ; _si hemos llegado o sobrepasado (Limite_horizontal). Seguimos con la rutina.
	jr z,1F                                         ; Si por el contrario hemos desaparecido por arriba o por abajo, (bit2/bit3 de (Ctrl_0)="1"))_
	and $fb 										; _hay que modificar el puntero de posición. (E="1" y salimos de la rutina). Antes inicializaremos los_ 
	ld (Ctrl_0),a 									; _ bits 2 y 3 de (Ctrl_0).
    jr 6F
1 bit 3,a
    jr z,2F
    and $f7
    ld (Ctrl_0),a
6 call Inicializacion
    jr 5F
2 push hl						        			; Guardo (Posicion_actual), HL en la pila.

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
; Comprobamos si hemos llegado al (Limite_horizontal). E="0".

	ex de,hl 										; Averiguamos si hemos llegado o sobrepasado el (Limite_horizontal). Hemos simplificado la operación SBC_			
	ld hl,(Limite_horizontal) 						; _cargando el tercio de pantalla en el byte alto.
	call calcula_tercio 							; (Posicion_actual) - (Limite_horizontal).
	ld h,a 											 
	ex de,hl 										; ARRIBA a ABAJO .......... E="1" cuando ( Z y NC ).
	call calcula_tercio                             ; ABAJO a ARRIBA .......... E="1" cuando ( Z y C ).
	ld h,a 											 
	and a 											
	sbc hl,de 										; Posicíon <"menos"> Límite.
	ex af,af 										; Guardo el registro F con los flags resultantes de la operación SBC.
	ld a,(Cuad_objeto)
	cp 2
	jr c,3F
	jr z,3F
	ex af,af 										; Partimos de LA MITAD INFERIOR. Recupero resultado de (Posicíon - Límite) en AF.
    jr z,7F
    jr c,7F 										; ABAJO a ARRIBA .......... E="1" cuando ( Z y C ). HEMOS SOBREPASADO_
 	ld e,0											; _ (Limite_horizontal), saltamos a 7F.
	pop hl

; Partimos de la mitad INFERIOR de pantalla y `NO HEMOS´ superado (Limite_horizontal). Tenemos que averiguar si hemos superado el centro de pantalla_
; _para indicar con E="2" en caso necesario.											

    push hl
    push bc
	call calcula_tercio
	cp 1
	jr nz,11F 										; Sólo comprobamos la línea centro cuando nos encontramos en el 2º tercio de pantalla.
    call Comprueba_centro 							; ABAJO A ARRIBA .......... E="2" cuando ( Z y C ).
    jr z,9F
    jr c,9F
11 ld e,0
    jr 8F
3 ex af,af 											; Partimos de LA MITAD SUPERIOR. Recupero resultado de (Posicíon - Límite) en AF.
	jr z, 7F
	jr nc, 7F										; E="1" cuando ( Z y NC ).
 	ld e,0
	pop hl
	jr 4F  
7 ld e,1 											; SOBREPASAMOS (Limite_horizontal) !!!. E="1", pop HL y RET.
    jr 10F

; Partimos de la mitad SUPERIOR de pantalla y `NO HEMOS´ superado (Limite_horizontal). Tenemos que averiguar si hemos superado el centro de pantalla_
; _para indicar con E="2" en caso necesario.

4 push hl
    push bc											; Guardamos (Posicion_actual) y (Filas/Columns) en la pila.
	call calcula_tercio
	cp 1
	jr nz,8F										; Sólo comprobamos la línea centro cuando nos encontramos en el 2º tercio de pantalla.
    call Comprueba_centro 							; ARRIBA a ABAJO .......... E="2" cuando ( Z y NC ).
    jr z,9F
    jr nc,9F
	jr 8F
9 ld e,2
8 pop bc
10 pop hl
5 ret

; --------------------
;
; 25/08/22

Comprueba_centro call calcula_tercio
    ld h,a
	ex af,af
	cp 2
	jr c,1F 				
	jr z,1F
	ld bc,$01a0 								  	 ; ¡¡¡¡¡ CENTRO DE PANTALLA cuando estamos en la mitad inferior de la misma. !!!!!
	jr 2F
1 ld bc,$0160                                     	 ; ¡¡¡¡¡ CENTRO DE PANTALLA cuando estamos en la mitad superior de la misma. !!!!!
2 ex af,af
    and a
    sbc hl,bc
    ret

; *********************************************************************************************************************************************************************************************
;
;   16/8/22
;
;	Comprueba_limite_vertical
;
;	Modifica el registro L del puntero de pantalla cuando se sobrepasa la columna límite, (Limite2).
;	Dependiendo del cuadrante en el que nos encontremos, sumaremos o restaremos, (Columnas-1) a L. 
;	

Comprueba_limite_vertical ld hl,(Posicion_actual)
	ld a,l
	and $1F
	ld d,a 											 
	ld a,(Limite_vertical)
	cp d 											; Límite - Posición.
	ex af,af 										; Resultado de CP d en F'.
	ld a,(Cuad_objeto)								; Averiguamos en que cuadrante estamos.
	bit 0,a
	jr z,1F 										; Si A´es PAR, estamos en el 2º o 4º cuadrante. Saltamos a [3F], (cuadrantes 2º y 4º).

; Hemos comparado la posición Y de la entidad con (Limite_vertical) y estamos en la mitad IZQUIERDA de la pantalla.

	ex af,af 										; LADO IZQUIERDO !!!!!!!!!!
	jr c,4F 										; Superamos (lIMITE_VERTICAL) cuando hay "acarreo".

; No hay cambio de cuadrante!!!!! Estamos en el lado izquierdo de la pantalla y no hemos sobrepasado (Limite_vertical).
; Lo primero que haremos será comprobar si hemos llegado o superado el centro de la pantalla.
 
    ld a,(Coordenada_X)
    ld d,Centro_izquierda
    and a
    sub d 											 ; Posición - Centro_izquierda.
    jr z,3F
    jr nc,3F                                         ; Si no hemos superado (Limite_vertical) pero si hemos superado el centro de la pantalla,_
;                                                    ; _salimos sin modificar nada.
    jr 2F
1 ex af,af 											 ; LADO DERECHO de la pantalla !!!!!!!!!!!
	jr nc,4F 										 ; Superamos (lIMITE_VERTICAL) cuando NC.

; No hay cambio de cuadrante!!!!! Estamos en el lado derecho de la pantalla y no hemos sobrepasado (Limite_vertical).
; Lo primero que haremos será comprobar si hemos llegado o superado el centro de la pantalla.

    ld a,(Coordenada_X)
    ld d,Centro_derecha
    and a
    sub d
    jr z,3F
    jr c,3F                                          ; Si no hemos superado (Limite_vertical) pero si hemos superado el centro de la pantalla,_
;                                                    ; _salimos sin modificar nada.
2 bit 0,e
    jr z,3F 										 ; No hemos sobrepasado (Centro_izquierda). Si E="0", salimos sin modificar posición.
	push bc 										 ; Reservo (Filas) / (Columns) en la pila.
    call Modificaccionne
	pop bc
    call Inicializacion
3 ret 				 								 ; Salimos de la rutina.

; ----- ----- ----- Cambio de cuadrante ----- ----- -----

4 push bc
	ld bc,Columns 		 	 						 ; Cambio de cuadrante. Sobrepasamos (Limite_vertical).					
	ld a,(bc)
	dec a 														
	ld b,a 											 ; Columnas-1 en B.
	ld a,l
	ex af,af                                         ; Cambio de cuadrante, estamos en la parte derecha de la pantalla.
	bit 0,a
	jr z,5F
	ex af,af 										 ; Estamos en la parte izquierda de la pantalla, (cuadrantes 1º o 3º). En ese caso, restamos (Columnas-1) a L.
	jr 7F

; Cambio de cuadrante, partimos de la parte DERECHA de la pantalla. Por el centro ?? o desaparecemos ??.

5 ex af,af 											 ; Estamos en la parte derecha de la pantalla, (cuadrantes 2º o 4º). En ese caso, sumamos (Columnas-1) a L.
	push af                                          ; Guardo la posición, (L), en la pila, (la contiene el acumulador).
	ld a,(Ctrl_0)
	bit 1,a
	jr nz,6F                                         ; Cambio de cuadrante por desaparecer por la derecha!!!                                       
	pop af                                           ; Cambio de cuadrante por desaparecer por el centro!!!

; Hemos sobrepasado el (Limite_vertical) de la mitad derecha a la izquierda. Ahora necesitamos saber si E="0".

    inc e
    dec e
    jr nz,12F
	add b 				 							 ; Si hemos sobrepasado el (Limite_vertical) pero no hemos llegado al centro horizontal_			 																			
    ld l,a	 										 ; _de la pantalla, E="0" modificamos L, Inicializamos el objeto y salimos.
	ld (Posicion_actual),hl
13 jr 9F                                           
12 bit 0,e
    jr nz,14F                                        ; Si hemos sobrepasado (Limite_vertical) y hemos llegado o superado_
;                                                    ; _el centro horizontal de la pantalla, E="2", salimos sin modificar nada.
	pop bc
	jr 3B
14 add b
    ld l,a
	ld (Posicion_actual),hl
    call Modificaccionne                             ; Si hemos sobrepasado (Limite_vertical) y (Limite_horizontal), E="1". Modificamos HL,L,_
    jr 9F 											 ; _inicializamos y salimos.
6 and $fd 											 ; Cambio de cuadrante por desaparecer por la derecha!!!. Reinicializo el bit 1 de (Ctrl_0).
    ld (Ctrl_0),a
	pop af
	jr 9F

; Cambio de cuadrante, partimos de la parte IZQUIERDA de la pantalla. Por el centro ?? o desaparecemos ??.

7 push af
	ld a,(Ctrl_0)
	bit 0,a
	jr nz,8F
	pop af

; Hemos sobrepasado el (Limite_vertical) de la mitad IZQUIERDA a la DERECHA. Ahora necesitamos saber si E="0".

	inc e
    dec e
    jr nz,10F
	sub b 																						
    ld l,a
	ld (Posicion_actual),hl
    jr 9F                                           ; Si hemos sobrepasado el (Limite_vertical) pero no hemos llegado al centro horizontal_
;                                                   ; _de la pantalla, E="0" modificamos L, Inicializamos el objeto y salimos.
10 bit 0,e
    jr nz,16F                                       ; Si hemos sobrepasado (Limite_vertical) y hemos llegado o superado_
;                                                   ; _el centro horizontal de la pantalla, E="2", salimos sin modificar nada.
	pop bc
	jr 3B
16 sub b
    ld l,a
	ld (Posicion_actual),hl
    call Modificaccionne                            ; Si hemos sobrepasado (Limite_vertical) y (Limite_horizontal), E="1". Modificamos HL,L,_
    jr 9F
8 and $fe 											; ; Cambio de cuadrante por desaparecer por la izquierda !!!!!. Reinicializo el bit 0 de (Ctrl_0).
    ld (Ctrl_0),a
	pop af
9 pop bc
	ld e,0
    call Inicializacion
    push af	 										; Antes de nada, guardo (Cuad_objeto) en A´ para acceder a él más rapido, (me va a hacer falta en la rutina calcolum).
	ex af,af
	pop af 											; Ahora tengo (Cuad_objeto) en A y A´.
    jr 3B

; --------------------

Modifica_Pos_actual ld b,15                                         ; Scanlines-1 en B.
1 call PreviousScan
    djnz 1B
	ld (Posicion_actual),hl
	xor a 											; Carry a "0". Evita que vuelva a entrar consecutivamente.
	ret

; --------------------

Modifica_Pos_actual2 ld b,15                                         ; Scanlines-1 en B.
1 call NextScan
    djnz 1B
	ld (Posicion_actual),hl
	xor a 											; Fijo el acarreo a "0" para asegurarme de no volver a entrar en la rutina.
	ret

; --------------------
;
;	22/01/23
;
;	E="1". Hemos cambiado de cuadrante. 
;	Si estamos en la mitad superior de pantalla: CALL [Modifica_Pos_actual].
;	Si estamos en la mitad inferior de pantalla: CALL [Modifica_Pos_actual2].


Modificaccionne 
	
	ld a,(Cuad_objeto)
	cp 2
    call z,Modifica_Pos_actual                      ; Si por el contrario estamos en la mitad inferior, call Modifica_Pos_actual2.
    call c,Modifica_Pos_actual
	ret z
    call Modifica_Pos_actual2
    ret

; *************************************************************************************************************************************************************************************************
;
;	13/8/22
;
;	Inicializacion
;
;	Entrega "1", "2", "3" o "4" en (Cuad_objeto) en función del cuadrante de pantalla en el que nos encontremos.
;	Fija los punteros del objeto a pintar, (varían en función del cuadrante en el que nos encontremos).
;	También calcula los límites horizontal y vertical. Estos dependen del tamaño del objeto a imprimir.
;	
; 	La rutina se ejecuta cada vez que el objeto supera el (Limite_horizontal) y el (Limite_vertical). Esto sucede_
;	_ cada vez que el objeto supera el centro de la pantalla tanto en sentido horizontal como vertical y cuando_
;	_ desaparece/aparece.	

;	[Puntero_datas]: Dirección de memoria donde se encuentra el 1er byte que pinta el objeto. 
;	[Puntero_attr_datas]: Dirección de memoria donde se encuentra el byte de atributos del objeto. 
;
;	INPUT: [HL] contendrá la dirección de pantalla a la que queremos asignar cuadrante. HL=(Posicion_inicio).
; 		   [BC] contendrá (Filas)/(Columns) del objeto a inicializar.
; 		   [E] ="0"

; 	OUTPUT: DESTRUYE [AF] y [D].
	 
Inicializacion call calcula_tercio																			
	jr z,primit 													
	and 2
	jr nz,segmit
	ld a,l 															
	cp $7f
	jr c,primit
	jr z,primit
segmit call column  												
	jr c,tercuad
cuarcuad ld a,4
	ld (Cuad_objeto),a
	ld hl,$4820
	ld (Limite_horizontal),hl
	ld hl,Limite_vertical
	ld (hl),$0d
	ex af,af
	jr 1F
tercuad	
	ld a,3
	ld (Cuad_objeto),a 
	ld hl,$4820
	ld (Limite_horizontal),hl
	ld hl,Limite_vertical
	ld (hl),$12
	ex af,af
	jr 1F
primit call column 													
	jr c, primcuad 													
segcuad 
	ld a,2
	ld (Cuad_objeto),a
	ld hl,$4fc0
	ld (Limite_horizontal),hl
	ld hl,Limite_vertical
	ld (hl),$0d
	ex af,af
	jr 1F
primcuad 
	ld a,1
	ld (Cuad_objeto),a 
	ld hl,$4fc0
	ld (Limite_horizontal),hl
	ld hl,Limite_vertical
	ld (hl),$12
	ex af,af

1 push bc
	push hl
	push de

	ld hl,(Posicion_actual)
	call Genera_coordenadas

	pop de
	pop hl
	pop bc

	ld hl,Ctrl_0
	set 5,(hl)
	ret

; ------------------------------------------------------------------------------------------------------------------

; Esta pequeña subrutina determina el nº de columna en la que nos encontramos, Introducimos en A el valor absoluto de L, (0-31).
; 
; OUTPUT: "FLAG C". Si se produce 1, nos encontramos en las primeras 16 columnas de pantalla, (cuadrantes 1 y 3). Si no es así, (cuadrantes 2 y 4).

column ld a,l
	and $1f 											
 	cp $10												
 	ret

; --------------------------------------------------------------------------------------------------------------------
;
; Esta subrutina se encarga de asignar valor a la variable (Columnas), (nº de columnas del objeto que podemos pintar).
;
; 14/12/22
;
;	Modifica: A y BC.

calcula_CColumnass ld a,(Cuad_objeto)
	and 1
	jr z,1F

; Nos encontramos en la parte izquierda de la pantalla

	ld a,(Coordenada_X)
	ld b,a
	inc b											; (Coordenada_X)+1 en B.
	ld a,c
	sub b											; (Columns)-[(Coordenada_X)+1] en A.
	jr c,2F
	ld b,a
	ld a,c
	sub b
	ld (Columnas),a
	jr 4F
2 ld a,c
	ld (Columnas),a
	jr 4F

; Nos encontramos en la parte derecha de la pantalla.

1 ld a,(Coordenada_X)
	add c
	dec a
	sub $1f
	jr c,3F
	ld b,a
	ld a,c
	sub b
	ld (Columnas),a
	jr 4F
3 ld a,c
	ld (Columnas),a
4 exx
	ld c,a
	exx
 ret	

; --------------------------------------------------------------------------------------------------------------------
;
;   19/7/23
;
;	Calcula el puntero de impresión del sprite, (arriba-izquierda).
;	Almacena en IY (Puntero_objeto). La rutina de impresión requiere de esta dirección para situar el SP a la hora de pintar.
;
;	OUTPUT: IX Contienen el puntero de impresión.
;			HL e IY Contienen (Puntero_objeto).
;
;	DESTRUYE: HL,B Y A.	

Calcula_puntero_de_impresion ld a,(Cuad_objeto)
	cp 2
	jr c,1F
	jr z,1F
	and 1
	jr z,3F

; Estamos situados en el 3er cuadrante de pantalla. ----- ----- -----

	call Operandos					; (Posicion_actual) en HL y (Columnas)-1 en B.

9 ld a,l
	and $1f
	jr z,7F
	dec hl
	djnz 9B
	jr 7F

; Estamos situados en el 4º cuadrante de pantalla. ----- ----- -----

3 ld hl,(Posicion_actual) 
	jr 7F

1 jr z,2F

; Estamos situados en el 1er cuadrante de pantalla. ----- ----- -----

	call Operandos					; (Posicion_actual) en HL y (Columnas)-1 en B.

4 ld a,l
	and $1f
	jr z,6F
	dec hl
	djnz 4B
6 ld b,15
5 call PreviousScan
	djnz 5B
	jr 7F

; Estamos situados en el 2º cuadrante de pantalla. ----- ----- -----

2 call Operandos					; (Posicion_actual) en HL y (Columnas)-1 en B.
	ld b,15
8 call PreviousScan
	djnz 8B

7 push hl
	pop ix

	ld hl,(Puntero_objeto)
	push hl
	pop iy

; Hemos calculado el puntero_de_impresion de Amadeus ????.	

	ld a,(Ctrl_0)
	bit 6,a
	ret z

; Almacenaremos el puntero de impresión de Amadeus para usarlo en la rutina de colisión `disparo de_
; _ entidad / Amadeus´.

	ld (p.imp.amadeus),ix

	ret

; --------------------------------------------------------------------------------------------------------------------
;
;	2/1/23
;
;	Sub-rutina de [Calcula_puntero_de_impresion].
;	
;	Tras esta rutina tenemos:
;
;	OUTPUT: HL contiene (Posicion_actual).
;			B contiene (Columnas)-1. Nota: Este valor `nunca' será "0". El valor mínimo es "1".
;
;	DESTRUYE!!!!! HL,B y A.

Operandos ld hl,(Posicion_actual)
	ld a,(Columnas)
	dec a
	jr nz,1F
	inc a
1 ld b,a
	ret

; --------------------------------------------------------------------------------------------------------------------
;
;	Prepara_draw
;
;	Es una rutina de carga.
;	Carga los registros BC,HL y E para posteriormente llamar a la rutina de pintado [DRAW].
;	
;	FUNCIONAMIENTO:
;
;	- LD (Filas/Columns) del objeto a pintar en [BC].
;	- LD (Posicion_actual) del objeto en [HL].
;	- LD E,0. (Dígito de control utilizado por Draw para cálculos internos de la rutina. Ha de estar a "0").
;
;	DESTRUYE:
;
;	Logicamente, BC,HL y E quedan destruidos.	

Prepara_draw ld hl,Filas 		 					 					 ; Prepara los registros BC, E y HL. 
	ld b,(hl) 														     ; Carga Filas/Columns del objeto a pintar o inicializar en BC. 
	inc hl 												 				 ; Carga (Posicion_actual) en HL.
	ld c,(hl) 											
	ld hl,(Posicion_actual)
	ld e,0 																 ; Byte de control. Ha de estar a "0" cuando llamamos a [DRAW].
	ret

;----------------------------------------------------------------------------------------------------------------
;
;	5/08/22
;
;   NextScan. 
;
;   Calcula la dirección de mem. de pantalla donde se sitúa el siguiente scanline. (Inc H, línea abajo).
;
;   INPUT: HL contendra la dirección de mem. de video sobre la que queremos calcular el siguiente scanline.
;
;   OUTPUT: HL contendrá la nueva dirección de memoria de pantalla.
;
;       DESTRUIDOS: AF y HL !!!
;
;   010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  
;

NextScan inc h          ; Incrementamos el scanline.
    ld a,h
    and 7
    ret nz              ; Salimos de la rutina si el scanline se encuentra entre (1-7).

	ld a,l              ; Scanlines a "0", cambiamos de tercio. (Siempre que estemos en la última línea, LLL).
    add a,$20           ; Vamos a comprobarlo...
    ld l,a
    ret c               ; Salimos si se produce el cambio de tercio.

    ld a,h              ; No estamos en la última línea del tercio, por lo que inicializamos H restando una_
    sub 8               ; _unidad a los bits que definen el tercio TT, (sub $08).
    ld h,a
    ret

;----------------------------------------------------------------------------------------------------------------     
;
;	5/08/22
;
;   PreviousScan.
;
;   Calcula la dirección de mem. de pantalla donde se sitúa el scanline anterior. (Dec H, línea arriba).
;
;   INPUT: HL contendra la dirección de mem. de video sobre la que queremos calcular el scanline anterior.
;
;   OUTPUT: HL contendrá la nueva dirección de memoria de pantalla.
;
;       DESTRUIDOS: AF y HL !!!
;
;   010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  
;

PreviousScan ld a,h         
    dec h               ; Dec H.
    and 7
    ret nz              ; Salimos de la rutina si el scanline se encuentra entre (1-7).

    ld a,l              ; Estabamos en el scanline "0" y al decrementar nos situamos en el "7" y cambiamos de tercio.
    sub $20             ; Vamos a comprobarlo...
    ld l,a
    ret c               ; Salimos si estábamos en la primera línea y se produce el cambio de tercio.

    ld a,h              ; No estamos en la primera línea del tercio, por lo que inicializamos H sumando una_
    add a,8             ; _unidad a los bits que definen el tercio TT, (add a,$08).
    ld h,a
    ret


	









