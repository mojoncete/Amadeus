

;   25/06/23
;
;   Base de datos. PATRONES DE MOVIMIENTO.
;
;   Codificación:
;
;   La descripción de un movimiento consta de 5 bytes como mínimo:
;
;   db (Contador_db_mov),[(Desplaz.1),(Desplaz2),(Desplaz3),.....],(Repetimos_mov).
;
;
;   (Contador_db_mov) ..... Nº de bytes que componen el desplazamiento, (0-255).
;
;                       Hay que tener en cuenta que cada (Desplaz.) está constituido por 3 bytes.
;                       Así que cada movimiento podrá estar constituido como máximo, por 85 desplazamientos. 
;
;   (Desplaz.1),(Desplaz.2),(Desplaz.3) ..... Bytes que describen la velocidad, dirección y repeticiones de cada uno de_
;                       los desplazamientos que componen el movimiento.                        
;
;                       Los bytes 1 y 2 definen la velocidad del desplazamiento.
;
;                       (Byte1) ..... % (Vel_up),(Vel_down)  
;                               ..... %01000010 Vel_up 4
;                                               Vel_down 2
;                               ..... $42
;
;                       (Byte1) ..... % (Vel_left),(Vel_right)  
;   
;                               ..... %01000010 Vel_left 4
;                                               Vel_right 2
;                               ..... $42
;
;                       El 3er byte describe la dirección y repeticiones del desplazamiento.
;
;                       (Byte3) ..... Descripción del desplazamiento.
;
;                       % up,down,left,right, Repetición del desplazamiento, (0-15).
;
;                                     %01010011 ..... (Abajo-derecha), 3 veces.
;                                     $53
;
;                       Esta tabla nos ayudará a codificar rápido los desplazamientos del mov.
;                       Supongamos que solo ejecutamos 1 vez, cada desplazamiento:
;
;                       Arriba ..... $81
;                       Arriba - izquierda ..... $a1
;                       Arriba - derecha ..... $91
;               
;                       Abajo ..... $41
;                       Abajo - izquierda ..... $61
;                       Abajo - derecha ..... $51
;
;   (Repetimos_mov) ..... Nº de veces que repetimos el movimiento completo. (0-255).

; ----- ----- ----- ----- -----

Indice_mov_Baile_de_BadSat defw Bajo_decelerando
;    defw Codo_abajo_derecha

Bajo_decelerando db 1,$14,$11,$48,1             
    db 1,$12,$11,$4f,2
    db 1,$11,$11,$4f,2,0                                        ; El final del movimiento se indica con un "0" en 

; ----- ----- ----- ----- -----
;
;   27/06/23

Movimiento 

    ld a,(Contador_db_mov)                                      ; Hemos iniciado un movimiento ?. Si (Contador_db_mov) aún es "0" hay que inicializarlo._
    and a                                                       ; _Para hacerlo, hemos de fijar antes (Puntero_mov). 
    jr z,Inicializa_movimiento

    jr Movimiento_iniciado                                      ; Saltamos a [Decoder] si ya hemos iniciado la cadena.

; Inicializa movimiento, (comienza un movimiento).
; Nota: Previamente, la rutina [DRAW], ha iniciado la entidad, (Puntero_mov) ya apunta a su cadena de movimiento correspondiente.

Inicializa_movimiento ld hl,(Puntero_mov)
    ld a,(hl)
    ld (Contador_db_mov),a                                      ; Contador de bytes de la cadena inicializado. (El 1er byte de cada cadena de mov. indica el nº de bytes que_
    and a                                                       ; _ tiene la cadena.
    jr z, Reinicia_el_movimiento                                ; Hemos terminado de ejecutar todas las cadenas de movimiento. 

; HL contiene (Puntero_mov) y este se encuentra en el 1er byte de la cadena de movimiento, (Contador_db_mov).

    inc hl
    call Ajusta_velocidad_desplazamiento

; Iniciamos (Repetimos_mov).

    ld a,(hl)
    and $0f
    ld (Repetimos_desplazamiento),a


; Hemos ajustado la velocidad del desplazamiento con los 2 primeros bytes del desplazamiento.
; El 3er byte indica la dirección del desplz., (nibble alto) y las veces que lo ejecutamos, (nibble bajo).

Movimiento_iniciado

    call Aplica_desplazamiento

    ld hl,Repetimos_desplazamiento
    dec (hl)
    ret nz

; Hemos terminado de ejecutar el desplazamiento y sus ($0-$f repeticiones).
; Hay que volver a ejecutar este desplazamiento ???.

    ld hl,(Puntero_mov)
    inc hl

    ld a,(hl)
    and a
    jr z,$


    jr $


; Este movimiento NO CONTIENE más desplazamientos. Saltamos al siguiente movimiento del índice de movimientos_
; _ de la entidad.

;    call z, Incrementa_Puntero_indice_mov

; !!!!!!!!!!!!!!!! Voy por aquí.

; Pasamos al siguiente desplazamiento del movimiento actual.
; Actualizamos el puntero (Puntero_mov), al comienzo del nuevo desplazamiento e iniciamos.

;    jr Inicializa_movimiento











Reinicia_el_movimiento 

    call Inicia_Puntero_mov
    xor a
    ld (Contador_db_mov),a
    ld (Incrementa_puntero),a
    jp Movimiento


; ---------- --------- --------- ---------- ----------
;
;   26/6/23
;
;   Inicia_Puntero_mov
;
;   

Inicia_Puntero_mov ld hl,(Puntero_indice_mov)
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld (Puntero_mov),hl
    ret
    
; ---------- --------- --------- ---------- ----------
;
;   27/06/23
;
;   Aplica_movimiento.
    
Aplica_desplazamiento 

; Analizamos (bit a bit) el nibble alto del 3er byte que compone el desplazamiento y ejecutamos.

    ld hl, (Puntero_mov) 
    bit 7,(hl)
    jr z,1F
    call Mov_up
1 ld hl, (Puntero_mov) 
    bit 6,(hl)
    jr z,2F
    call Mov_down
2 ld hl, (Puntero_mov)
    bit 5,(hl)
    jr z,3F
    call Mov_left
3 ld hl, (Puntero_mov)
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
;   27/06/23
;
;   Incrementa_Puntero_indice_mov

Incrementa_Puntero_indice_mov jr $