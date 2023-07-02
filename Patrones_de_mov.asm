

;   02/07/23
;
;   Base de datos. PATRONES DE MOVIMIENTO.
;
;   Codificación:
;
;   La descripción de un movimiento consta de 1 o más desplazamientos.
;
;   Un desplazamiento tiene la siguiente estructura:
;
;   (Byte1),(Byte2),(Byte3),(Cola_de_desplazamiento).   (4 Bytes).
;
;                       Los bytes 1 y 2 definen la velocidad del desplazamiento.
;
;                       (Byte1) ..... % (Vel_up),(Vel_down)  
;                               ..... %01000010 Vel_up 4
;                                               Vel_down 2
;                               ..... $42
;
;                       (Byte2) ..... % (Vel_left),(Vel_right)  
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
;   (Cola_de_desplazamiento) db 0			; Este byte indica:
;
;											;	"$00" ..... Hemos finalizado la cadena de movimiento.
;											;				En este caso hemos de incrementar (Puntero_indice_mov)_
;											;				_ y pasar a la siguiente cadena de movimiento del índice.
;
;											;	"$01 - "$fe" ..... Repetición del movimiento. 
;											;						Nº de veces que vamos a repetir el movimiento completo.
;											;						En este caso, volveremos a inicializar (Puntero_mov),_	
;							    			;						_ con (Puntero_indice_mov) y decrementaremos (Cola_de_desplazamiento).
;				
;											;	"$ff" ..... Bucle infinito de repetición del MOVIMIENTO.
;											;				Nunca vamos a saltar a la siguiente cadena de movimiento del índice,_	
;											;				,_ (si es que la hay). Volvemos a inicializar (Puntero_mov) con (Puntero_indice_mov).	

; ----- ----- ----- ----- -----

Indice_mov_Baile_de_BadSat defw Bajo_decelerando
;    defw Codo_abajo_derecha

Bajo_decelerando db $14,$11,$4f,1             
    db $12,$11,$4f,1
    db $11,$11,$4f,1                                          
    db 0

; ----- ----- ----- ----- -----
;
;   27/06/23

Movimiento 

; Nota: Previamente, la rutina [DRAW], ha iniciado la entidad, (Puntero_mov) ya apunta a su cadena de movimiento correspondiente.

    ld hl,(Puntero_mov)
    ld a,(hl)
    and a                                                       
    call z, Inicializa_Puntero_indice_mov                       ; Hemos terminado de ejecutar todas las cadenas de movimiento. 

    ld a,(Ctrl_2)
    bit 2,a
    jr nz, Desplazamiento_iniciado


; HL contiene (Puntero_mov) y este se encuentra en el 1er byte de la cadena de movimiento, (Byte1) ..... % (Vel_up),(Vel_down).

Inicia_desplazamiento.

    call Ajusta_velocidad_desplazamiento

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

    call Aplica_desplazamiento

    ld hl,Repetimos_desplazamiento
    dec (hl)
    ret nz

; Hemos terminado de ejecutar el desplazamiento y sus ($0-$f repeticiones).
; Hay que volver a ejecutar este desplazamiento ???.

    ld a,(Cola_de_desplazamiento)
    and a
    call z,Incrementa_Puntero_indice_mov                       ; Fin de la cadena de movimiento ???.

    cp $ff
    jr z,Reinicia_el_movimiento                                ; Bucle infinito del desplazamiento?.

    cp 1
    call z,Siguiente_desplazamiento                            ; Pasamos al siguiente desplazamiento de movimiento?.
    
    dec a
    ld (Cola_de_desplazamiento),a                               
    
    ld a,(Repetimos_desplazamiento_backup)                      ; Cuando (Cola_de_desplazamiento) actúa como contador del_
    ld (Repetimos_desplazamiento),a                             ; _ desplazamiento y este no ha llegado a "0", decrementamos_
;                                                               ; _ el contador y RESTAURAMOS (Repetimos_desplazamiento).
    ret

; !!!!!!!!!!!!!!!! Voy por aquí.



Reinicia_el_movimiento 

    call Inicia_Puntero_mov

    xor a
    ld (Incrementa_puntero),a

    ld hl,Ctrl_2
    res 2,(hl)

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

; ---------- --------- --------- ---------- ----------
;
;   2/07/23
;
;   Inicializa_Puntero_indice_mov

Inicializa_Puntero_indice_mov jr $


; ---------- --------- --------- ---------- ----------
;
;   02/07/23
;
;   Siguiente_desplazamiento

Siguiente_desplazamiento 

;   Situamos (Puntero_mov) en el siguiente desplazamiento del movimiento.

    ld hl,(Puntero_mov)
    inc hl
    inc hl
    ld (Puntero_mov),hl

;   Indicamos que hay que iniciar un nuevo desplazamiento.

    ld hl,Ctrl_2
    res 2,(hl)

    ret