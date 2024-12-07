; ----- ----- ----- ----- -----
;
;   28/12/23

Movimiento 

; Nota: Previamente, la rutina [DRAW], ha iniciado la entidad, (Puntero_mov) ya apunta a su cadena de movimiento correspondiente.

    ld a,(Ctrl_2)
    bit 2,a
    jr nz, Desplazamiento_iniciado

    ld hl,(Puntero_mov)
    ld a,(hl)

; HL contiene (Puntero_mov) y este se encuentra en el 1er byte de la cadena de movimiento, (Byte1) ..... % (Vel_up),(Vel_down).

Inicia_desplazamiento.

; Preparamos (Incrementa_puntero). Cada vez que iniciemos un nuevo movimiento le sumaremos 2 uds.

    call Ajusta_velocidad_desplazamiento

; Hemos definido (Vel_left),(Vel_right),(Vel_up) y (Vel_down) en la bandeja DRAW. Ahora (Puntero_mov) está situado en el 3er byte del movimiento, (indica dirección y nº de veces que la ejecutamos).

; Iniciamos (Repetimos_mov).

    ld a,(hl)
    and $0f
    ld (Repetimos_desplazamiento),a
    ld (Repetimos_desplazamiento_backup),a

; Iniciamos (Cola_de_desplazamiento).

    inc hl
    ld a,(hl)
    ld (Cola_de_desplazamiento),a
    dec hl

    ld hl,Ctrl_2
    set 2,(hl)

; Hemos ajustado la velocidad del desplazamiento con los 2 primeros bytes del desplazamiento.
; El 3er byte indica la dirección del desplz., (nibble alto) y las veces que lo ejecutamos, (nibble bajo).

Desplazamiento_iniciado

;! En que parte del movimiento estamos??? Cabe el movimiento completo?

; Después del codo abajo-derecha (Coordenada_X) de la entidad contendrá "4" cuando (Posicion_inicio) sea $4001.

; Cuando (Coordenada_X)="4" ;   Derecha_y_subiendo+8 (11)               
;                               Izquierda_y_subiendo+8 (11)            
; Cuando (Coordenada_X)="5" ;   Derecha_y_subiendo+8 (8)               
;                               Izquierda_y_subiendo+8 (8)            
; Cuando (Coordenada_X)="6" ;   Derecha_y_subiendo+8 (8)               
;                               Izquierda_y_subiendo+8 (8)            
; Cuando (Coordenada_X)="7" ;   Derecha_y_subiendo+8 (7)               
;                               Izquierda_y_subiendo+8 (8)            
; Cuando (Coordenada_X)="8" ;   Derecha_y_subiendo+8 (6)               
;                               Izquierda_y_subiendo+8 (8)            
; Cuando (Coordenada_X)="9" ;   Derecha_y_subiendo+8 (5)               
;                               Izquierda_y_subiendo+8 (7)  
; Cuando (Coordenada_X)="a" ;   Derecha_y_subiendo+8 (4)               
;                               Izquierda_y_subiendo+8 (7)  
; Cuando (Coordenada_X)="b" ;   Derecha_y_subiendo+8 (3)               
;                               Izquierda_y_subiendo+8 (7)  





;    ld bc,Derecha_y_subiendo+2
;    ld hl,(Puntero_mov)
;    ld a,c
;    cp l
;    jr nz,3F

;    jr $

;    ld a,(Coordenada_X)
;    sub 4
;    jr z,4F

;    ld a,(Coordenada_y)                 ; $08 - $0b

;    ld b,a
;    ld hl,Derecha_y_subiendo+7
;    ld a,(hl)
;    sub b
;    ld (hl),a


    call Aplica_desplazamiento

    ld hl,Repetimos_desplazamiento
    dec (hl)
    ret nz

; Hemos terminado de ejecutar el desplazamiento y sus ($0-$f repeticiones).
; Hay que volver a ejecutar este desplazamiento ???.
; Analiza (Cola_de_desplazamiento).

Cola ld a,(Cola_de_desplazamiento)
    and a
    call z,Incrementa_Puntero_indice_mov                        ; Fin de la cadena de MOVIMIENTO ???.
    jr z,Reinicia_el_movimiento

    cp $ff
    jr z,Reinicia_el_movimiento                                 ; Bucle infinito del MOVIMIENTO?.

    cp $fe
    call z,Fijamos_bucle
    jr z,Reinicia_el_movimiento

    cp $fd
    jr nz,1F

; ---
; Ya estamos ejecutando una repetición del último MOVIMIENTO ???.

    ld a,(Ctrl_2)
    bit 3,a
    jr nz,Reinicia_el_movimiento

; Si no es así, iniciamos la REPETICIÓN del movimiento activando el BIT 3 de Ctrl_2.

    ld hl,Ctrl_2                                                ; Vamos a indicar con este BIT a la rutina [Reinicia_el_movimiento],_
    set 3,(hl)                                                  ; _ que (Cola_de_desplazamiento)="$fe", por lo que vamos a REINICIAR el_ 

    call Inicia_Repetimos_movimiento
    jr z,Reinicia_el_movimiento                                 ; _ MOVIMIENTO (X nº de veces), siendo X un valor comprendido entre (1-255).                                
; ---

1 cp 1
    jp z,Siguiente_desplazamiento                               ; Pasamos al siguiente desplazamiento del movimiento?.
 
    dec a
    ld (Cola_de_desplazamiento),a                               
    
    ld a,(Repetimos_desplazamiento_backup)                      ; Cuando (Cola_de_desplazamiento) actúa como contador del_
    ld (Repetimos_desplazamiento),a                             ; _ desplazamiento y este no ha llegado a "0", decrementamos_
;                                                               ; _ el contador y RESTAURAMOS (Repetimos_desplazamiento).
    ret

Reinicia_el_movimiento 

    ld a,(Ctrl_2)
    bit 3,a
    jr z,2F

; (Cola_de_desplazamiento)="254".

    ld hl,Repetimos_movimiento                                  ; Decrementamos (Repetimos_movimiento) hasta completar repeticiones.
    dec (hl)
    jr nz,2F

; Fin de las repeticiones del último movimiento.

    ld hl,Ctrl_2
    res 3,(hl)                                                  ; Decrementamos el BIT de repeticiones de movimiento.

    ld hl,(Puntero_mov)
    inc hl
    inc hl
    inc hl
    ld (Puntero_mov),hl                                         ; Situamos (Puntero_mov) en (Cola_de_desplazamiento) y saltamos a `Cola'_
;                                                               ; _ para ejecutar su mandato. :)
    ld a,(hl)
    ld (Cola_de_desplazamiento),a        

    jp Cola

2 call Inicia_Puntero_mov

    ld hl,Ctrl_2
    res 2,(hl)

    jp Movimiento

Siguiente_desplazamiento 

;   Situamos (Puntero_mov) en el siguiente desplazamiento del movimiento.
;   Indicamos que hay que iniciar un nuevo desplazamiento.

    ld hl,Ctrl_2
    res 2,(hl)

    ld hl,(Puntero_mov)
    inc hl
    inc hl
    ld (Puntero_mov),hl

    ld a,(hl)
    and a
    call z,Incrementa_Puntero_indice_mov 
    jp z,Reinicia_el_movimiento 

    ret

; Subrutinas -----------------------------------------
; ---------- --------- --------- ---------- ----------
;
;   24/07/23
;
;   Fijamos_bucle
;
;   

Fijamos_bucle 

    ld a,(Incrementa_puntero)
    inc a
    ld (Incrementa_puntero_backup),a                    

    call Incrementa_Puntero_indice_mov
    ld hl,(Puntero_indice_mov)
    ld (Puntero_indice_mov_bucle),hl
    ret

; ---------- --------- --------- ---------- ----------
;
;   07/7/23
;
;   Inicia_Repetimos_movimiento
;
;   

Inicia_Repetimos_movimiento

; Iniciamos (Repetimos_movimiento).

    ld ix,(Puntero_mov)
    ld a,(ix+2)
    ld (Repetimos_movimiento),a

    ret

; ---------- --------- --------- ---------- ----------
;
;   26/6/23
;
;   Inicia_Puntero_mov
;
;   

Inicia_Puntero_mov ld hl,(Puntero_indice_mov)
    call Extrae_address
    ld (Puntero_mov),hl
    ret
    
; ---------- --------- --------- ---------- ----------
;
;   27/06/23
;
;   Aplica_movimiento.
    
Aplica_desplazamiento 

; Analizamos (bit a bit) el nibble alto del 3er byte que compone el desplazamiento y ejecutamos.

    ld hl,(Puntero_mov) 

    ld a,(hl)
    and $f0
    ret z                       ; Salimos de la rutina si no hay desplazamiento.

    bit 7,(hl)
    jr z,1F
    call Mov_up

1 ld hl,(Puntero_mov) 
    bit 6,(hl)
    jr z,2F
    call Mov_down

2 ld hl,(Puntero_mov)
    bit 5,(hl)
    jr z,3F
    call Mov_left

3 ld hl,(Puntero_mov)
    bit 4,(hl) 
    ret z
    call Mov_right

    ret

; ---------- --------- --------- ---------- ----------
;
;   26/06/23
;
;   Ajusta_velocidad_desplazamiento.

Ajusta_velocidad_desplazamiento 

; 1er byte de la cadena de movimiento.
; Indica (Vel_up), (nibble alto) y (Vel_down) el nibble bajo.

    call Extrae_nibble_alto

    ld (Vel_up),a
    ld a,c
    and $0f
    ld (Vel_down),a

; Saltamos al 2º byte de la cadena de movimiento.
; Indica (Vel_left), (nibble alto) y (Vel_right) el nibble bajo.

    inc hl
    call Extrae_nibble_alto

    ld (Vel_left),a
    ld a,c
    and $0f
    ld (Vel_right),a

; Nos situamos en el 3er byte del desplazamiento. Actualizamos (Puntero_mov).

    inc hl
    ld (Puntero_mov),hl
    ret

Extrae_nibble_alto ld b,4
    ld a,(hl)
    ld c,a
    and $f0
1 srl a    
    djnz 1B
    ret

; ---------- --------- --------- ---------- ----------
;
;   5/7/23
;
;   Incrementa_Puntero_indice_mov

Incrementa_Puntero_indice_mov 

    ld hl,Incrementa_puntero
    inc (hl)

    ld hl,(Puntero_indice_mov)
    ld bc,2
    and a
    add hl,bc
    ld (Puntero_indice_mov),hl

    ld a,(hl)    
    and a

;! STOP. Fin del patrón de movimiento de la entidad.

;    jr z,$

;! Reinicia el Patrón de movimiento.    

    call z,Inicializa_Puntero_indice_mov_2

    xor a                                   ; Siempre salimos de la rutina con el flag "Z" activo.

    ret

; ---------- --------- --------- ---------- ----------
;
;   15/01/24
;
;   Inicializa_Puntero_indice_mov

Inicializa_Puntero_indice_mov_2 

; Existe etiqueta de bucle principal???

    ld hl,(Puntero_indice_mov_bucle)
    inc h
    dec h
    jr z,2F

    ld (Puntero_indice_mov),hl
    jr 3F

; Inicializamos (Puntero_indice_mov) con la 1ª dirección del índice del patrón de movimiento.

2 ld a,(Incrementa_puntero)
    ld b,a

    ld hl,(Puntero_indice_mov)
1 dec hl
    dec hl
    djnz 1B
    ld (Puntero_indice_mov),hl

    xor a
    ld (Incrementa_puntero),a
    jr 4F

3 ld a,(Incrementa_puntero_backup)
    ld (Incrementa_puntero),a
4 ret

; ----------------------------------------------------------------------
;
;   24/11/24
;
;   Sitúa HL en el .defw (Contador_general_de_mov_masticados) de este (Tipo) de entidad.

Situa_en_contador_general_de_mov_masticados ld a,(ix+0)             ; ld a,(Tipo)
    call Calcula_salto_en_BC
    ld hl,Contador_general_de_mov_masticados_Entidad_1
    and a
    adc hl,bc
    ret

; ----------------------------------------------------------------------
;
;   24/11/24
;
;   Transfiere los datos del Contador_general_de_mov_masticados de este (Tipo) de entidad al (Contador_de_mov_masticados) de la entidad correspondiente.
;   
;   INPUT: HL apunta al (.defw) (Contador_general_de_mov_masticados) de este (Tipo) de entidad).

Transfiere_datos_de_contadores ld c,(hl)
    inc hl
    ld b,(hl)                                                   ; BC contiene los mov_masticados totales de este (Tipo) de entidad.
    ld (ix+9),c
    ld (ix+10),b                                                ; ld (Contador_de_mov_masticados),bc
    ret
