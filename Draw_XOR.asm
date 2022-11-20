; ******************************************************************************************************************************************************************************************
;
; 17/08/22
;
; DRAW. ************************************************************************************************************************************************************************************
;
; Rutina para pintar objetos en pantalla.
;
; Está diseñada para PINTAR un objeto de ( X Filas x Y Columnas) en pantalla, ej.: (2x2), (3x3), (5x5), etc.
; El tamaño del objeto a imprimir lo definen las variables de programa: (Filas) y (Columns). Ambas son variables de 1 byte y representan caracteres completos de pantalla,_
; _ ejemplo.: 2 (filas de alto) x 4 (columnas de ancho).
;
; La rutina PINTA pinta el objeto o sprite, en la dirección de mem. de pantalla que contiene la variable de programa (Posicion_actual).
; Esta dirección indica, donde se va a imprimir `la 1ª línea del 1er char´ que compone el objeto.
; La rutina divide la pantalla en cuatro cuadrantes e imprime de manera distinta en función del cuadrante de pantalla en el que nos encontremos. 
; Esto se hace así con la finalidad de poder "esconder" objetos en cualquier borde de la pantalla y tener un control total de la misma.
;
; El `paso´ de un cuadrante a otro de la pantalla es detectado automáticamente por la rutina, modificando el puntero (Posición_actual).
; La dirección de mem. donde se encuentran los gráficos del objeto a imprimir se encuentra almacenada en la variable de programa, (Puntero_objeto).
;		
;
;		1. Función XOR cuando queremos que el objeto `pase´ por `delante´ del escenario. En ese caso, la variable de programa (Obj_atras)="0".
;		2. Función OR cuando queremos que el objeto `pase´ por `detrás´ del fondo. En ese caso, la variable de programa (Obj_atras)="1".
;
;	
; INPUT:  AF --
;		  DE --
; 		  IX --
; 		  IY --
;		  HL apunta a la dirección de memoria de pantalla donde se va a pintar el objeto.
; 		  BC contiene: Filas/Columnas del objeto. Ejempl.: 5x5, 3x3, 2x3, 4x2, etc.
; 		  El registro E="0".

; OUTPUT: DESTRUYE AF,BC,DE y HL.
;
;
Draw call Prepara_draw 

	ld a,h 						 					; El objeto existe, o se está iniciando?. Si se está iniciando, (Posicion_inicio = Posicion_actual) y saltamos_
	and a 											; _a la subrutina [Inicializacion] donde asignaremos cuadrante y límites.
	jr z,2F

	ld a,(Cuad_objeto)			 					; El objeto ya se inició. Cargamos en A el cuadrante de pantalla en el que lo hizo y saltamos a 1F.
	jr 1F

2 ld hl,(Posicion_inicio) 							; No hay (Posicion_actual), por lo que el objeto se está iniciando.
	ld (Posicion_actual),hl							; Indicamos que (Posicion_actual) = (Posicion_inicio) y saltamos a la subrutina [Inicializacion], (donde asignaremos_			
;		 											; _ cuadrante a (Posicion_actual)).
	call Inicializacion
	call Prepara_Puntero_mov 						; El objeto está inicializado. Antes de salir inicializamos tb el puntero de movimiento del objeto.

1 push af	 										; Antes de nada, guardo (Cuad_objeto) en A´ para acceder a él más rapido, (me va a hacer falta en la rutina calcolum).
	ex af,af
	pop af 											; Ahora tengo (Cuad_objeto) en A y A´.

; En este punto, el objeto existe. (Posicion_actual)<>"0" y el objeto tiene asignado un cuadrante. En función de la posición que ocupa en pantalla vamos a calcular los_
; _ límites horizontal y vertical. 

    call Comprueba_limite_horizontal
	call Comprueba_limite_vertical
	
3 push bc 											; Guardo el nº de filas y columnas del objeto en BC´.
	exx 												
	pop bc
	exx

	call calcolumn
    call Converter
	ret

; *******************************************************************************************************************************************************************************************
;	23/8/22
;
; 	Comprueba_limite_horizontal.
;

Comprueba_limite_horizontal ld a,(Obj_dibujado)
	and a
	ret nz   										; Salimos de la rutina si estamos borrando el objeto, (Obj_dibujado)="1". 

	ld a,(Ctrl_0)          							; Si no hemos desaparecido por arriba o por abajo, saltamos a ^14F^ para comprobar_ 
	bit 2,a                                         ; _si hemos llegado o sobrepasado el (Limite_horizontal), (seguimos con la rutina).
	jr z,1F                                         ; Si por el contrario hemos desaparecido por arriba o por abajo, (bit2/bit3 de (Ctrl_0)="1"))_
	and $fb 										; _hay que modificar el puntero de posición. (E="1" y salimos de la rutina). Antes inicializaremos los_ 
	ld (Ctrl_0),a 									; _ bits 2 y 3 de (Ctrl_0).
    jr 6F
1 bit 3,a
    jr z,2F
    and $f7
    ld (Ctrl_0),a
6 call Inicializacion
    push af	 										; Antes de nada, guardo (Cuad_objeto) en A´ para acceder a él más rapido, (me va a hacer falta en la rutina calcolum).
	ex af,af
	pop af 											; Ahora tengo (Cuad_objeto) en A y A´.
    jr 5F
2 push HL						        			; Guardo el puntero de pantalla, HL en la pila.

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
	sbc hl,de 										; Posicíon - Límite.

	ex af,af 										; Averiguamos de que mitad de la pantalla partimos.
	cp 2
	jr c,3F
	jr z,3F

	ex af,af 										; Partimos de LA MITAD INFERIOR. Recupero resultado de (Posicíon - Límite) en AF.
    jr z,7F
    jr c,7F 										; ABAJO a ARRIBA .......... E="1" cuando ( Z y C ).
;	ld e,0
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
    push bc

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
	ld bc,$01a0 								  	 ; !!!!! CENTRO DE PANTALLA cuando estamos en la mitad inferior de la misma. !!!!!
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

Comprueba_limite_vertical ld a,(Obj_dibujado)
	and a
	ret nz   										; Salimos de la rutina si estamos borrando el objeto, (Obj_dibujado)="1".  

	ld a,l
	and $1F
	ld d,a 											 
	ld a,(Limite_vertical)
	cp d 											; Límite - Posición.

	ex af,af 										; Consultamos el cuadrante en el que estamos, (A´).
	bit 0,a
	jr z,1F 										; Si A´es PAR, estamos en el 2º o 4º cuadrante. Saltamos a [3F], (cuadrantes 2º y 4º).

; Hemos comparado la posición Y de la entidad con (Limite_vertical) y estamos en la mitad IZQUIERDA de la pantalla.

	ex af,af 										; LADO IZQUIERDO !!!!!!!!!!
	jr c,4F 										; Superamos (lIMITE_VERTICAL) cuando C. 

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

1 ex af,af 											 ; LADO DERECHO !!!!!!!!!!
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
	push bc
    call Modificaccionne
	pop bc
    call Inicializacion
    push af	 										 ; Antes de nada, guardo (Cuad_objeto) en A´ para acceder a él más rapido, (me va a hacer falta en la rutina calcolum).
	ex af,af
	pop af 											 ; Ahora tengo (Cuad_objeto) en A y A´.
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
;	ld e,0
    call Inicializacion
    push af	 										; Antes de nada, guardo (Cuad_objeto) en A´ para acceder a él más rapido, (me va a hacer falta en la rutina calcolum).
	ex af,af
	pop af 											; Ahora tengo (Cuad_objeto) en A y A´.
    jr 3B

; --------------------

Modifica_Pos_actual call Calcula_scanlines_totales  ; Ahora tenemos el nº total de scanlines en B, DE y DE´.
    dec B                                           ; Scanlines-1 en B.
1 call PreviousScan
    djnz 1B
	ld (Posicion_actual),hl
	xor a 											; Carry a "0". Evita que vuelva a entrar consecutivamente.
	ret

; --------------------

Modifica_Pos_actual2 call Calcula_scanlines_totales ; Ahora tenemos el nº total de scanlines en B, DE y DE´.
    dec B                                           ; Scanlines-1 en B.
1 call NextScan
    djnz 1B
	ld (Posicion_actual),hl
	xor a 											; Fijo el acarreo a "0" para asegurarme de no volver a entrar en la rutina.
	ret

; --------------------

; [Calcula_scanlines_totales] DESTRUYE !!!!! BC, DE y DE´.
; [PreviousScan] y [NextScan] DESTRUYE !!!!! AF y HL.

Modificaccionne ex af,af 
    cp 2
    push af                                         ; Guardo el resultado de la comparación.
    ex af,af                                        ; Vuelvo a guardar (Cuad_objeto) en A´.
    pop af                                          ; Resultado de la comparación en AF. Si estamos en la mitad superior de la pantalla, call Modifica_Pos_actual.
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
	 

Inicializacion call calcula_tercio									; Entrega "0", "1" o "2" en A en función del tercio donde nos encontremos.												
	jr z,primit 													; 1er tercio. Estamos en la primera mitad de pantalla, (cuadrantes 1 o 2).
	and 2
	jr nz,segmit
	ld a,l 															; Cuando estamos en el segundo tercio: Las 4 primeras filas pertenecen a la 1ª mitad y las 4 últimas del tercio, a la 2ª.
	cp $7f
	jr c,primit
	jr z,primit
segmit call column  												; 3er tercio, Estamos en la segunda mitad de pantalla, (cuadrantes 3 o 4).
	jr c,tercuad
cuarcuad call Calcula_dbs_totales
	call puntero_cuarcuad
	call Limite3
	ld a,4
	ld (Cuad_objeto),a
	ex af,af
	call Limite2
	jr 1F
tercuad	call Calcula_dbs_totales 
	call puntero_cuarcuad
	push hl 														; Voy a utilizar las dos parejas de registros para operar. POP antes de salir de la rutina.
	push bc
	ld b,0 															; BC = $00xx, (nº de columnas-1) que tiene el objeto.
	dec c
	ld hl,(Puntero_datas)
	and a
	adc hl,bc
	ld (Puntero_datas),hl
	pop bc
	pop hl	
	call Limite3
	ld a,3
	ld (Cuad_objeto),a 
	ex af,af
	call Limite2
	jr 1F
primit call column 													; Tras el regreso de column, sabremos, (en función del FLAG C), si estamos en un cuadrante_ 
	jr c, primcuad 													; _ par o impar. ¨C¨="1" cuadrante impar.
segcuad call Calcula_dbs_totales
	call puntero_primcuad
	push hl 														; Voy a utilizar las dos parejas de registros para operar. POP antes de salir de la rutina.
	push bc
	ld b,0 															; BC = $00xx, (nº de columnas-1) que tiene el objeto.
	dec c
	ld hl,(Puntero_datas)
	and a
	sbc hl,bc
	ld (Puntero_datas),hl
	pop bc
	pop hl
	call Limite
	ld a,2
	ld (Cuad_objeto),a
	ex af,af
	call Limite2	
	jr 1F
primcuad call Calcula_dbs_totales 									; Nos encontramos en el 1er cuadrante de la pantalla.
	call puntero_primcuad
	call Limite
	ld a,1
	ld (Cuad_objeto),a 
	ex af,af
	call Limite2
1 call Genera_coordenadas											; El objeto está Inicializado y "ocupa una coordenada en el mundo".
	ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; 
;	16/7/22
;
;	Calcula_dbs_totales .......... (Subrutina de [Inicializacion]).
;
;	En función del valor de BC, (Filas/Columns) de un objeto, la rutina entrga dos cantidades:
;
;	INPUTS:
;
;	(Filas)/(Columns) de una entidad en BC.
;
;
;	OUTPUTS:
;
;	[(Filas)*(Columns)]*8 en BC´.
;	[(Filas)*(Columns)] en DE´.
;
;	DESTRUYE:
;
;	AF,BC´ y DE´ 	


Calcula_dbs_totales push bc		   									; Guardo Filas/Columnas en la pila.
	ld a,c															; Compruebo si (Columns) es "1", en ese caso,_
	dec a 															; _cargo el nº de filas en A y multiplico *8. (JR 3F).
	jr nz,2F
	ld a,b
	jr 3F
2 dec c 															; (Columns-1) en C.
	ld a,b
1 add b 															; El loop dl, multiplica Filas*Columnas.
	dec c
	jr nz,1B 
3 push af 															; Guardo Filas * Columnas en la pila.
	sla a
	sla a
	sla a 															; Ahora tengo en A: (Filas*Columnas)*8
	exx 
	ld c,a 															; Finalmente: 
	pop af
	ld e,a 															; (Filas*Columnas)*8 en BC.
	xor a
	ld b,a 															; Filas*Columnas en DE.
	ld d,b
	exx
	pop bc
	ret

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	17/7/22
;
;	Puntero_primcuad .......... (Subrutina de [Inicializacion]).
;
;	Estamos en el 1er cuadrante de pantalla. La rutina fija (Puntero_datas) al final de los .db de .....
; 	
;		(Puntero_objeto) cuando el objeto no está desplazado. (CTRL_DESPLZ)="0".
;		Caja_de_DESPLZ cuando el objeto está desplazado y estamos pintando, (Obj_dibujado)="0".
;		Caja_de_BORRADO cuando el objeto está desplazado y estamos borrando, (Obj_dibujado)="1".

puntero_primcuad push hl 
	exx
	call Fija_punteros
	ld hl,(Puntero_datas)
	call suma
	ld (Puntero_datas),hl
	exx
	pop hl
	ret
suma and a
	adc hl,bc 														; [(Puntero_objeto)+(Filas*Columnas)*8]-1 en HL.
	dec hl
	ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	Puntero_cuarcuad .......... (Subrutina de [Inicializacion]).
;
;	Asigna una dirección a cada una de las tres variables que podemos necesitar a la hora de `pintar´ el Sprite en pantalla cuando nos encontramos en el 4º cuadrante de pantalla.
; 	Antes de llamar a esta rutina hay que ejecutar la rutina: [Calcula_dbs_totales].

puntero_cuarcuad push hl
	exx
	call Fija_punteros
 	exx
 	pop hl
 	ret

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	14/9/22
;
;	Fija_punteros ..... (Subrutina de [Inicialización]).
;
;	La rutina fija el puntero de dibujado/borrado.
;	
;	Función:	
;	
;	HL apuntará a (Puntero_de_objeto), Caja_de_DESPLZ o Caja_de_BORRADO en función de si estamos PINTANDO/BORRANDO el objeto o de si este, ha sido o no, DESPLAZADO.

Fija_punteros push bc 												; Guardamos en la pila (Filas)*(Columns)*8 y _
	push de 														; _(Filas)*(Columns). BC y DE respectivamente.

	ld a,(Obj_dibujado) 											; Pintamos o borramos???. (Obj_dibujado)="0" PINTAMOS.
	and a
	jr z,1F 	

	ld a,(CTRL_DESPLZ)		 										; Borramos el objeto.
	and a 															; Si (CTRL_DESPLZ)="0", el objeto no está desplazado, en ese caso (Puntero_datas)=(Puntero_objeto).
	jr z,2F 														; Si (CTRL_DESPLZ)="1", el objeto está desplazado, por lo que tendrá una (Columns) más. En ese caso,_
	ld hl,(Caja_de_BORRADO) 											; _(Puntero_datas)=Caja_de_BORRADO. 
	ld (Puntero_datas),hl
	jr 3F

1 ld a,(CTRL_DESPLZ) 												; Pintamos el objeto.								 
	and a 															; Si (CTRL_DESPLZ)="0", el objeto no está desplazado, en ese caso (Puntero_datas)=(Puntero_objeto).
	jr z,2F 														; Si (CTRL_DESPLZ)="1", el objeto está desplazado, por lo que tendrá una (Columns) más. En ese caso,_
	ld hl,(Caja_de_DESPLZ) 											; _(Puntero_datas)=Caja_de_DESPLZ.		
	ld (Puntero_datas),hl 								
	jr 3F

2 ld hl,(Puntero_objeto) 											; (Puntero_datas)=(Puntero_objeto). 
	ld (Puntero_datas),hl	 										; Fijamos el puntero de atributos y salimos.

3 pop de
	pop bc
	ret	

; *********************************************************************************************************************************************************************************************
; 14/8/22	

; Limite y Limite3.
;
;
; Calculan, (a partir del centro de la pantalla y del nº de filas que tiene el Sprite), el (Limite_horizontal).
;
; Limite se aplica en el 1er y 2º cuadrante.
; Limite3 se aplica en el 3er y 4º cuadrante.
;
; NOTA: No destruyen ningún registro!!!.

Limite push hl 														; Guardamos la posición del objeto en pantalla, (HL) y las dimensiones FILAS/COLUMNAS en BC.
	push bc
	ld hl,$48a0														; Esta es la línea que fijamos como referencia para calcular (Limite_horizontal) cuando nos_	
	ld bc,32 														; _encontramos en el 1er o 2º tercio de pantalla.
 	ld a,(Filas)	 								 				
	dec a
	ld d,a 		 													; (Filas)-1 en D.													
	and a 															; Carry off.
1 adc hl,bc 														; El límite se sitúa en: ($4880)+[$20*(Filas-1)]
	dec d 															; Si H es igual a $49 es que ha habido cambio de tercio. En ese caso, situamos H en $57.
	jr nz,1B 														; Si no hay cambio de tercio, H=$4f.
	ld a,h 															; Guardamos la línea límite en la variable: (Limite_horizontal).
	and 1 															; Recuperamos HL y BC y salimos.
	jr z,2F
	ld h,$57
	jr 3F
2 ld h,$4f
3 ld (Limite_horizontal),hl
	pop bc
	pop hl
	ret

Limite3 push HL		 	 											; Guardamos la posición del objeto en pantalla, (HL) y las dimensiones FILAS/COLUMNAS en BC.
	push bc
	ld hl,$4840														; Esta es la línea que fijamos como referencia para calcular (Limite_horizontal) cuando nos_
	ld bc,32 														; _encontramos en el 3er o 4º tercio de pantalla.
 	ld a,(Filas)	 								 				
	dec a
	ld d,a 															; (Filas-1) en D.
	and a 															; Carry off.
1 sbc hl,bc 														; El límite se sitúa en: ($4840)-[$20*(Filas-1)]
	dec d 															; Si H es igual a $4e es que ha habido cambio de tercio. En ese caso, situamos H en $40.
	jr nz,1B														; Si no hay cambio de tercio, H=$48.
	ld a,h 															; Guardamos la línea límite en la variable: (Limite_horizontal).
	and 1 															; Recuperamos HL y BC y salimos.
	jr nz,2F
	ld h,$48
	jr 3F
2 ld h,$40
3 ld (Limite_horizontal),hl
	pop bc
	pop hl
	ret

; *********************************************************************************************************************************************************************************************
; 13/8/22
;
; Limite2
;
; Calcula, (a partir del centro de la pantalla y del nº de columnas que tiene el Sprite), el (Limite_vertical).
;
; Esta subrutina se aplica en todos los cuadrantes.
;
; NOTA: No destruye ningún registro!!!.

Limite2 push hl 													; Guardamos la posición del objeto en pantalla, (HL).
	ld hl,Columns 											
 	ld d,(hl)
 	ex af,af
 	bit 0,a
 	jr z,1F	
 	ex af,af
 	ld a,16 														; $10 + (Columnas-1) = (Limite_vertical), (cuando estamos en los cuadrantes 1º y 3º).
 	add d 															; $0f - (Columnas-1) = (Limite_vertical), (cuando estamos en los cuadrantes 2º y 4º).
 	jr 2F
1 ex af,af
	ld a,15
	sub d
2 ld (Limite_vertical),a
 	pop hl
 	ex af,af 														; Entrega [Cuad_cuadrante] en A.
 	ret

; ***********************************************************************************************************************************************************************
; 
; Esta pequeña subrutina determina el nº de columna en la que nos encontramos, Introducimos en A el valor absoluto de L, (0-31).
; 
; OUTPUT: "FLAG C". Si se produce 1, nos encontramos en las primeras 16 columnas de pantalla, (cuadrantes 1 y 3). Si no es así, (cuadrantes 2 y 4).
;
; ***********************************************************************************************************************************************************************

column ld a,l
	and $1f 											
 	cp $10												
 	ret

; ********************************************************************** calcolumn / calcolumn2 *************************************************************************
;
; Esta subrutina se encarga de asignar valor a la variable (Columnas), (nº de columnas del objeto que podemos pintar).

calcolumn exx                                        	; Calcula (Columnas) en cuadrantes 1º y 3º.
	push bc
	exx
	pop de 												; Situamos en D el contenido de (Filas_objeto) y en E el nº de columnas.
	ld a,l
	and $1f  											; Posición absoluta de L, (0 a 31).
	ex af,af 											; Consultamos A´, (Cuad_objeto). Si estamos en un cuadrante impar, (1º o 3º): Posición abs. de (L+1) - Columnas que tiene el objeto.
	bit 0,a 											; Si estamos en un cuadrante par: ($20 - Posición abs. de (L+1)) - Columnas que tiene el objeto.
	jr nz,1F 											
	ex af,af 											
	ld b,a   											
	ld a,32
	sub b 		
	jr 2F
1 ex af,af
	inc a
2 ld b,a   												; Columnas que tenemos disponibles.
	sub e 												; Restamos el nº de columnas que tiene el objeto. 
	jr c,3F 											; Si el resultado es "0" o no existe acarreo, la variable (Columnas) tendrá el mismo valor que las columnas que tiene el Sprite en su _
	ld a,e 												; _ base de datos.
	ld (Columnas),a 									; Si se produce acarreo, (Columnas) será igual a el resultado de restar: Posición abs. de (L+1) - Columnas que tiene el objeto.
	jr 4F 												; Este valor siempre será inferior a las columnas que tiene el Sprite en su base de datos.
3 ld a,b
	ld (Columnas),a
4 ret

; ******************************************************************************************************************************************************************************************
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

; ***********************************************************************************************************************************************************************
;
;	05/11/22
;
;	La rutina ha de proporcionar los datos necesarios para que la rutina de pintado imprima un objeto en pantalla:
;
;   Necesitamos:	- El nº de scanlines que podemos imprimir del objeto en B.
;             		- La dirección de pantalla del puntero de impresión en HL.
;			  		- La nueva ubicacion de (Puntero_datas) en DE.
;					- También necesitamos saber el nº de columnas que `podemos´ imprimir el objeto.
;	 					Este valor es el resultado de la diferencia entre (Columns)-(Columnas).
;						En función de este valor desplazaremos el puntero SP por los .db de la entidad_
; 	 					_incrementando su posición en "1" o "2" unidades.
;
Converter call Prepara_draw					;	Necesito (Filas)/(Columns) en BC para llamar a [Calcula_dbs_totales].
	push bc									;	También necesito disponer de la variable (Filas), que colocaré en H´ y (Attr),_	
	exx 									;	_que alojaré en L´.
	pop hl 									;	El objetivo de esta rutina es de proveer de todos los datos necesarios a la rutina_

	ld a,(Attr) 							;	_[Pintorrejeo] para que no tenga que acceder a memoria a por ninguno.
	ld l,a									;	Todos los datos necesarios para que [Pintorrejeo] se ejecute correctamente han de estar contenidos en los registros!!!!!
	exx										

	call Calcula_dbs_totales				

	ld hl,Columnas
	ld c,(hl)

	exx
	push bc
	exx
	pop de									;	Tenemos:
; 											;	(Filas)/(Columnas) en BC.
;											;	[(Filas)*(Columns)]*8 en BC´y DE.
;											;	[(Filas)*(Columns)] en DE´.
    ld a,(Cuad_objeto)
    cp 2
    call c,Cuad_one
    call z,Cuad_two
    ret m
    and 1
    call nz,Cuad_three 						; 	Salimos de la rutina si hemos ejecutado antes, alguna de las_	
    ret m 									;	_anteriores, [Cuad_one], [Cuad_two] o [Cuad_three].
    call Cuad_four
	ret

Cuad_four ld de,(Puntero_datas)
	push de
	pop ix 									;	New Puntero_datas en DE e IX.	
	ld a,(Columns)
	sub c
	exx
	ld b,a
	exx
	ex af,af 								;	(Columns)-(Columnas) en B´ y A´.
	call Filas_por_ocho
	ld hl,(Posicion_actual)
	ret

Cuad_three push bc							;	(Filas)/(Columnas) en la pila.
	ld hl,(Puntero_datas)
	ld b,c
	dec b 									;	(Columnas)-1 en B.
	jr z,1F
2 dec hl
	djnz 2B
1 ex de,hl
	push de
	pop ix 									;	New Puntero_datas en DE e IX.
	ld hl,(Posicion_actual)
	ld b,c
	dec b
	jr z,3F
4 dec hl 									; 	Puntero de impresión en HL.
	djnz 4B	
3 pop bc 									;	Recupero (Filas)/(Columnas) en BC.
	call Filas_por_ocho						;	Scanlines que componen la entidad en B. 
	ld a,(Columns)
	sub c
	exx
	ld b,a
	exx
	ex af,af 								;	(Columns)-(Columnas) en B´ y A´. 
	xor a
	dec a
	and a
	ret

Cuad_two push bc
    ld hl,Columns
    ld b,(hl)
    ld hl,(Puntero_datas)
1 inc hl
    djnz 1B 								;	Ahora (Puntero_datas) en el último .db.
    and a
	sbc hl,de
    ex de,hl 					    	
    push de
    pop ix                                  ;	New (Puntero_datas) en DE e IX.
    pop bc                                  ;   (Filas)/(Columnas) en BC.
    call Filas_por_ocho
	push bc 								;	Guardo Scanlines/Columns en la pila.
	dec b 									;	Scanlines-1.
 	ld hl,(Posicion_actual)
2 call PreviousScan
	djnz 2B 								;	Ahora Puntero de impresión en HL.
 	ld a,(Columns)
	sub c
	exx
	ld b,a
	exx
	ex af,af 								; 	(Columns)-(Columnas) en B´ y A´.
	pop bc
	xor a 									;	A tiene un valor negativo antes de salir de la rutina. 
	dec a
	and a
	ret
    
Cuad_one ld hl,(Puntero_datas) 				;	En el 1er cuadrante, (Puntero_datas) apuntará al último .db del objeto. Para situarlo_
	and a 									;	_en el 1er .db, restaremos el nº total de .db a hl y sumaremos 1.
	sbc hl,de
	inc hl
	ex de,hl 								;	New (Puntero_datas) en DE.
	call Filas_por_ocho                                               
	dec b									;	[(Filas)*8]-1 en [B].
	push bc
	ld hl,(Posicion_actual)
1 call PreviousScan
	djnz 1B 									
	ld b,c									;	(Columnas) en B.
	dec b
	jr nz,2F
	jr 3F
2 dec l
	djnz 2B	 								;	Ahora tenemos el puntero de impresión, (donde vamos a empezar a pintar el 1er .db)_
3 pop bc 									;	_ en HL. (Arriba-izquierda).
	inc b 									;	Scanlines totales a imprimir en B y (Columnas) en C.
    push bc
	exx
	pop bc 									;	Scanlines/(Columnas) en BC´.
	ld a,(Columns)
	sub c
	ld b,a 									; 	B´ contiene (Columns)-(Columnas).
	jr z,4F 								; 	Si el objeto se imprime completo, (Columns)-(Columnas)="0" saltamos a 4F y salimos.
	exx 									;	El objeto no se imprime completo. Hay que situar, New (Puntero_datas) en el .db_
	push af 								;	_correspondiente. Sumaemos la diferencia entre (Columns) y (Columnas) al puntero.
	ex af,af 								;	El objeto está apareciendo.
	pop af
5 inc de
	dec a
	jr nz,5B
	jr 6F
4 exx
	ex af,af								; 	BC contiene Scanlines/(Columns).
6 push de 									;	HL contiene el Puntero de impresión.
	pop ix 									;	DE e IX contienen el New Puntero_datas.
;											;	A´y B´contienen (Columns)-(Columnas).											
;											;	H´ (Filas)
;											;	L´ (Attr)
	xor a
	dec a
	and a 									;	A es negativo antes de salir de la rutina.
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

	call Genera_coordenadas

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

	call Genera_coordenadas

    ld a,l              ; Estabamos en el scanline "0" y al decrementar nos situamos en el "7" y cambiamos de tercio.
    sub $20             ; Vamos a comprobarlo...
    ld l,a
    ret c               ; Salimos si estábamos en la primera línea y se produce el cambio de tercio.

    ld a,h              ; No estamos en la primera línea del tercio, por lo que inicializamos H sumando una_
    add a,8             ; _unidad a los bits que definen el tercio TT, (add a,$08).
    ld h,a
    ret

; ----------------------------------------------------------
;
;	17/10/22
;
;	(Macro). Esta operación es utilizada en las cuatro subrutinas de Converter.
;
;	Multiplica la cantidad contenida en B por 8. (B)*8.

Filas_por_ocho sla b
	sla b
	sla b
	ret

; -----------------------------------------------------------------------------------
;
;	14/11/22

Extrae_foto_registros ld (Stack),sp															; Guardo el puntero de pila y lo sitúo al principio del Album_de_fotos
	ld sp,Album_de_fotos

2 exx																		; Extraemos de Album_de_fotos los valores de los registros.
	pop hl
	pop bc
	exx

	ex af,af
	pop af
	ex af,af

	pop ix
	pop de
	pop bc
	pop hl

	ld (Stack_2),sp
	ld sp,(Stack)

	call Pintorrejeo														; call Pintorrejeo. Hemos pintado la entidad.
;																			; Esta dirección ha de ser correcta. Cada vez que modifique 
	ld (Stack),sp
	ld a,(Numero_de_malotes)
	dec a
	jr z,1F
 	ld (Numero_de_malotes),a	 
	ld sp,(Stack_2)
	jr 2B

1 ld sp,(Stack)

	ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	17/10/22
;
;	Instrucciones donde interviene el Stack Pointer, (SP).

;	ADC HL,SP	LD (addr),SP
;	ADD HL,SP	LD SP,(addr)
;	ADD IX,SP	LD SP,nn
; 	ADD IY,SP	LD SP,HL
;				LD SP,IX
;	DEC SP		LD SP,IY

;	EX (SP),HL
;	EX (SP),IX
;	EX (SP),IY

;	INC SP

Pintorrejeo  

;	INPUTS:
;
;   Estos parámetros los proporciona la subrutina Converter.

; 	BC contiene los Scanlines/(Columnas) a imprimir.
;	HL contiene el Puntero de impresión, dirección de pantalla, (arriba-izquierda) del sprite.
;	DE e IX contienen el New Puntero_datas.
;	A´y B´contienen (Columns)-(Columnas).											
;	H´ (Filas)
;	L´ (Attr)

	call Define_atributos 

	exx
	ld de,$0002 								;	El registro D' nos indicará, (si está a "1"), que vamos a imprimir_
	exx											;	_una entidad de 4 Columnas. Utilizaremos la subrutina (Columnas2) para hacerlo.	
; 												;	Inicializamos D'.
    ld a,c
    cp 2
    jr z,Columnas2
    jp c,Columnas1
	and 1
    jr nz,Columnas3

	exx
	inc d
	exx
	jr Columnas2

; -----------------------------------------------------------------------------------------

Columnas3 push bc

	ld (Stack),sp						; Guardo SP.
	ld sp,ix							; Sitúo el SP en el 1er .db de la entidad.

1 pop de
		
    ld a,e								; Funcion_xor de la FILA.
	xor (hl)
    ld e,a
	inc hl
	ld a,d
	xor (hl)
	ld d,a
    dec hl

    ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	
    pop de
    ld a,e
    xor (hl)
    ld e,a

    ld (hl),e
    dec sp
    dec l
    dec l
    jr 2F

4 djnz 1B
 
6 ld sp,(Stack)
	pop bc
    ret

2 inc h       						; Incrementamos el scanline.
    ld a,h
    and 7
    jr nz,3F              			; Salimos de la rutina si el scanline se encuentra entre (1-7).
	ld a,l             				; Scanlines a "0", cambiamos de tercio. (Siempre que estemos en la última línea, LLL).
    add a,$20           			; Vamos a comprobarlo...
    ld l,a
    jr nc,5F               			; Salimos si se produce el cambio de tercio.

; Si se produce cambio de tercio:

	ld a,h 							; Salimos de la rutina si estamos en el último tercio de la pantalla y se produce cambio de cuadrante.
	sub $58
	jr z,6B
	jr nc,6B
	jr 3F

5 ld a,h              				; No estamos en la última línea del tercio, por lo que inicializamos H restando una_
    sub 8               			; _unidad a los bits que definen el tercio TT, (sub $08).
    ld h,a

3 jr 4B
 
; -----------------------------------------------------------------------------------------

Columnas2 ld (Stack),sp					; Guardo SP.
	ld sp,ix						; Sitúo el SP en el 1er .db de Coracao.
2 pop de 							; 2º .db y 1er .db en DE respectivamente. Esto decrementa en 2 pos. el puntero SP.
	jr 4F	

1 ld (hl),e							; Imprimo el scanline con la función XOR implementada.
	inc hl
	ld (hl),d
	dec hl
	jr 5F 							; Vamos a preparar el puntero de impresión HL, en el scanline siguiente.

3 exx 								; Consulto (Columns)-(Columnas), (Corrección del puntero SP).
	inc b
	dec b
	jr z,8F 						; Si (Columns)=(Columnas) no hago corrección de SP.

7 inc sp							; Hago la corrección de SP y repongo (Columns)-(Columnas) en B´.
	djnz 7B
	
	ex af,af
	ld b,a
	ex af,af

8 exx
 	djnz 2B
9 ld sp,(Stack)	

	ret

; --------------------------

4 ld a,e						; Funcion_xor de la FILA. .db XOR (HL). El resultado sigue en DE.
	xor (hl)
	ld e,a
	inc hl
	ld a,d
	xor (hl)
	ld d,a
	dec hl
	jr 1B

; Nota: No utilizo la rutina Next Scan / Previous Scan porque estoy utilizando la pila para pintar.

5 exx
	inc d
	dec d
	jr z,11F 					; Imprimimos 2 o 4 Columnas???

	dec e 						; Vamos a imprimir 4 Columnas. Decrementamos el contador E'.
	jr z,12F

	exx
	inc l
	inc l
	jr 2B

12 inc e
	inc e
	exx
	dec l
	dec l 						; Inicializamos E' y HL a su posición inicial para imprimir el siguiente scanline.
	jr 13F

11 exx 
13 inc h       				; Incrementamos el scanline.
	ld a,h
	and 7
    jr nz,6F              		; Salimos de la rutina si el scanline se encuentra entre (1-7).
	ld a,l             			; Scanlines a "0", cambiamos de tercio. (Siempre que estemos en la última línea, LLL).
    add a,$20           		; Vamos a comprobarlo...
    ld l,a
    jr nc,10F               	; Salimos si no se produce el cambio de tercio.

; Si se produce cambio de tercio:

	ld a,h 						; Salimos de la rutina si estamos en el último tercio de la pantalla y se produce cambio de cuadrante.
	sub $58
	jr z,9B
	jr nc,9B
	jr 6F
		
10 ld a,h              				; No estamos en la última línea del tercio, por lo que inicializamos H restando una_
    sub 8               			; _unidad a los bits que definen el tercio TT, (sub $08).
    ld h,a
6 jr 3B

; -----------------------------------------------------------------------------------------

Columnas1 ld a,(de)
	xor (hl)
	ld (hl),a
    jr 2F
5 djnz Columnas1                    ; Quedan scanlines que imprimir ???. REPETIMOS.
    ret
2 inc h       						; Incrementamos el scanline.
    ld a,h
    and 7
    jr nz,3F              			; Salimos de la rutina si el scanline se encuentra entre (1-7).
	ld a,l             				; Scanlines a "0", cambiamos de tercio. (Siempre que estemos en la última línea, LLL).
    add a,$20           			; Vamos a comprobarlo...
    ld l,a
    jr nc,8F               			; Salimos si se produce el cambio de tercio.

; Si se produce cambio de tercio:

	ld a,h 							; Salimos de la rutina si estamos en el último tercio de la pantalla y se produce cambio de cuadrante.
	sub $58
	ret z
	ret nc
	jr 3F 							; Se produce el cambio de tercio pero no estamos en el 3er tercio.
8 ld a,h              				; No estamos en la última línea del tercio, por lo que inicializamos H restando una_
    sub 8               			; _unidad a los bits que definen el tercio TT, (sub $08).
    ld h,a
3 exx 								; Comprobamos si estamos imprimiendo un sprite compuesto por 1 sóla (Columns), o se trata_
	inc B                           ; _de imprimir parte de un Sprite, (imprimimos 1 Columna de un sprite compuesto por más).
	dec b
	jr z,6F
	exx
	ex af,af 						; A contiene ahora (Columns)-(Columnas).
7 inc de 							; El sprite consta de más de una columna, debemos desplazar el puntero DE hasta el siguiente_
	dec a  							; _.DB, este valor de desplazamiento lo proporciona: [(Columns)-(Columnas)]+1.
	jr nz,7B 						
	inc de 							; Corrección de DE. Es necesaria para situar el puntero DE en el .db correspondiente.
	exx 							; Restauramos A´ con la variable (Columns)-(Columnas) para volverla a utilizar en el siguiente_
	ld a,b 							; _scanline.
	exx
	ex af,af
	jr 5B
6 exx
    inc de
    jr 5B 

