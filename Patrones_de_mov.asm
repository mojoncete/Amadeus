

;   07/07/23
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
;                       % up,down,left,right, Repetición del desplazamiento, (1-15).
;
;                                     %01010011 ..... (Abajo-derecha), 3 veces.
;                                     $53
;
;                       Nota: (Repetimos_desplazamiento) nunca será "0".
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
;											;	"$00" , "0" ..... Hemos finalizado la cadena de movimiento.
;											;				En este caso hemos de incrementar (Puntero_indice_mov)_
;											;				_ y pasar a la siguiente cadena de movimiento del índice.
;
;											;	"$fd" , "1-253" ..... Repetición del MOVIMIENTO. 
;											;						         Nº de veces que vamos a repetir el movimiento completo.
;											;					             En este caso, volveremos a inicializar (Puntero_mov),_	
;							    			;						         _ con (Puntero_indice_mov) y decrementaremos (Cola_de_desplazamiento).
;				
;											;	"$ff"  , "255" ..... Bucle infinito de repetición del último MOVIMIENTO.
;											;				         Nunca vamos a saltar a la siguiente cadena de movimiento del índice,_	
;											;				         _ (si es que la hay). Volvemos a inicializar (Puntero_mov) con (Puntero_indice_mov).	
;
;                                           ;   "$fe" ..... Activamos el bucle principal del patrón de movimiento. La direccíon de memoria_  
;                                           ;               _ del siguiente MOVIMIENTO del índice se almacenará en la variable (Puntero_indice_mov_bucle).                 
;                                           ;               La subrutina [Inicializa_Puntero_indice_mov] inicializará (Puntero_indice_mov) con_ 
;                                           ;               _ esta dirección y no se situará al comienzo del índice del patrón de movimiento.         

; ----- ----- ----- ----- -----

Indice_mov_Baile_de_BadSat defw Bajo_decelerando
    defw F_1
    defw F_2
    defw Codo_abajo_derecha
    defw Derecha_y_subiendo
    defw Derecha_y_subiendo_1
    defw F_3
    defw F_4
    defw Derecha_y_bajando
    defw Derecha_y_bajando_1
    defw Derecha_y_bajando_2
    defw Codo_derecha_abajo
    defw Codo_abajo_izq.
    defw Izquierda_y_subiendo
    defw Izquierda_y_subiendo_1
    defw F_5
    defw F_6
    defw Izquierda_y_bajando
    defw Izquierda_y_bajando_1
    defw Izquierda_y_bajando_2
    defw Codo_izquierda_abajo
    defw 0                                  ; Fin de patrón de movimiento.

Bajo_decelerando db $12,$11,$4f,1           ; Abajo (vel_2). 15rep.        
    db $11,$11,$42,0                        ; Abajo.  2rep. --- Termina movimiento.

F_1 db $11,$11,$41,1                        
    db $11,$11,$01,253,8,0                  ; Abajo - Pausa1. 8rep.
F_2 db $11,$11,$41,1                            
    db $11,$11,$02,253,15,254               ; Abajo - Pausa2. 15rep --- Fija puntero de bucle. (Voy por aquí 23/7/23).

Codo_abajo_derecha db $11,$11,$51,1         ; Abajo/Derecha. 1rep.
    db $11,$11,$43,1                        ; Abajo. 3rep.
    db $11,$11,$52,1                        ; Abajo/Derecha. 2rep.
    db $11,$11,$41,1                        ; Abajo. 1rep.
    db $11,$11,$52,1                        ; Abajo/Derecha. 2rep.
    db $11,$11,$11,1                        ; Derecha. 1rep.s
    db $11,$11,$52,1                        ; Abajo/Derecha. 2rep.
    db $11,$11,$13,1                        ; Derecha. 3rep.
    db $11,$11,$51,1                        ; Abajo/Derecha. 1rep.
    db $11,$12,$12,1                        ; Derecha. 2rep. vel.2
    db $11,$11,$91,1                        ; Arriba/Derecha. 1rep.
    db $11,$12,$12,1                        ; Derecha. 2rep. vel.2
    db $11,$11,$92,0                        ; Arriba/Derecha. 2rep. --- Termina movimiento.

Derecha_y_subiendo db $11,$12,$13,1         ; Derecha. 4rep. vel.2
    db $11,$11,$91,253,6,0                  ; Arriba/Derecha. 1rep. --- Repite Mov 12rep. --- Termina movimiento.

Derecha_y_subiendo_1 db $11,$11,$16,1       ; Derecha. 4rep. vel.2
    db $11,$11,$91,253,2,0                  ; Arriba/Derecha. 1rep. --- Repite Mov 12rep. --- Termina movimiento.

F_3 db $11,$11,$11,1
    db $11,$11,$01,253,4,0
F_4 db $11,$11,$11,1
    db $11,$11,$02,253,8,0

Derecha_y_bajando db $11,$11,$16,1          ; Derecha. 4rep. vel.2
    db $11,$11,$51,253,2,0

Derecha_y_bajando_1 db $11,$12,$13,1        ; Derecha. 4rep. vel.2
    db $11,$11,$51,253,6,0

Derecha_y_bajando_2 db $11,$11,$16,1        ; Derecha. 4rep. vel.2
    db $11,$11,$51,253,6,0

; Medio círculo bajando. Entra de izq. a derecha y sale de derecha a izq.

Codo_derecha_abajo db $11,$11,$51,1         ; Abajo/Derecha. 1rep.
    db $11,$11,$13,1                        ; Derecha. 3rep.
    db $11,$11,$51,1                        ; Abajo/Derecha. 1rep.
    db $11,$11,$13,1                        ; Derecha. 3rep.
    db $11,$11,$52,1                        ; Abajo/Derecha. 2rep.
    db $11,$11,$11,1                        ; Derecha. 1rep.
    db $11,$11,$52,1                        ; Abajo/Derecha. 2rep.
    db $11,$11,$41,1                        ; Abajo. 1rep.
    db $11,$11,$52,1                        ; Abajo/Derecha. 2rep.
    db $11,$11,$43,1                        ; Abajo. 3rep.        
    db $11,$11,$51,1                        ; Abajo/Derecha. 1rep.
    db $11,$11,$43,0                        ; Abajo. 3rep.

Codo_abajo_izq. db $11,$11,$61,1            ; Abajo/izq. 1rep.
    db $11,$11,$43,1                        ; Abajo. 3rep.
    db $11,$11,$62,1                        ; Abajo/izq. 2rep.
    db $11,$11,$41,1                        ; Abajo. 1rep.
    db $11,$11,$62,1                        ; Abajo/izq. 2rep.
    db $11,$11,$21,1                        ; izq. 1rep.
    db $11,$11,$62,1                        ; Abajo/izq. 2rep.
    db $11,$11,$23,1                        ; izq. 3rep.
    db $11,$11,$61,1                        ; Abajo/izq. 1rep.
    db $11,$21,$22,1                        ; izq. 2rep. vel.2
    db $11,$11,$a1,1                        ; Arriba/izq. 1rep.
    db $11,$21,$22,1                        ; izq. 2rep. vel.2
    db $11,$11,$a2,0                        ; Arriba/izq. 2rep. --- Termina movimiento.

Izquierda_y_subiendo db $11,$21,$23,1       ; Derecha. 4rep. vel.2
    db $11,$11,$a1,253,6,0                  ; Arriba/Derecha. 1rep. --- Repite Mov 12rep. --- Termina movimiento.

Izquierda_y_subiendo_1 db $11,$11,$26,1     ; Derecha. 4rep. vel.2
    db $11,$11,$a1,253,2,0                  ; Arriba/Derecha. 1rep. --- Repite Mov 12rep. --- Termina movimiento.

F_5 db $11,$11,$21,1
    db $11,$11,$01,253,4,0
F_6 db $11,$11,$21,1
    db $11,$11,$02,253,8,0

Izquierda_y_bajando db $11,$11,$26,1          ; Derecha. 4rep. vel.2
    db $11,$11,$61,253,2,0

Izquierda_y_bajando_1 db $11,$21,$23,1        ; Derecha. 4rep. vel.2
    db $11,$11,$61,253,6,0

Izquierda_y_bajando_2 db $11,$11,$26,1        ; Derecha. 4rep. vel.2
    db $11,$11,$61,253,6,0

Codo_izquierda_abajo db $11,$11,$a1,1          ; Arriba/Izq. 1rep.
    db $11,$11,$23,1                           ; Izq. 3rep.
    db $11,$11,$61,1                           ; Abajo/Izq. 1rep.
    db $11,$11,$23,1                           ; Izq. 3rep.
    db $11,$11,$62,1                           ; Abajo/Izq. 2rep.
    db $11,$11,$21,1                           ; Izq. 1rep.
    db $11,$11,$62,1                           ; Abajo/Izq. 2rep.
    db $11,$11,$41,1                           ; Abajo. 1rep.
    db $11,$11,$62,1                           ; Abajo/Izq. 2rep.
    db $11,$11,$43,1                           ; Abajo. 3rep.        
    db $11,$11,$61,1                           ; Abajo/Izq. 1rep.
    db $11,$11,$43,0                           ; Abajo. 3rep.

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

; Si en el último desplazamiento aplicado hemos aplicado reinicio, salimos del movimiento.

    ld a,(Ctrl_3)
    bit 1,a
    ret nz

;    ld a,(Ctrl_2)
;    bit 4,a
;    ret nz                                                      ; Salimos si se ha producido reinicio.

3 ld hl,Repetimos_desplazamiento
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

    ld hl, (Puntero_mov) 

    ld a,(hl)
    and $f0
    ret z                       ; Salimos de la rutina si no hay desplazamiento.

    bit 7,(hl)
    jr z,1F
    call Mov_up
1 ld hl, (Puntero_mov) 
    bit 6,(hl)
    jr z,2F
    call Mov_down

; Se ha aplicado reinicio ???
; Si es así, dejamos de aplicar desplazamiento, (RET).

;    ld a,(Ctrl_3)
;    bit 1,a
;    ret nz

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
;   30/01/24
;
;   Sitúa HL en la dirección donde se encuentra el Contador_general_de_mov_masticados de este (Tipo) de entidad.

Situa_en_contador_general_de_mov_masticados ld a,(Tipo)
    call Calcula_salto_en_BC
    ld hl,Contador_general_de_mov_masticados_Entidad_1
    and a
    adc hl,bc
    ret

; ----------------------------------------------------------------------
;
;   30/01/24
;
;   Transfiere los datos del Contador_general_de_mov_masticados de este (Tipo) de entidad a (Contador_de_mov_masticados).
;   
;   INPUT: HL contiene el contador de 16 bits, (Contador_general_de_mov_masticados de este (Tipo) de entidad).

Transfiere_datos_de_contadores ld c,(hl)
    inc hl
    ld b,(hl)                                                   ; BC contiene los mov_masticados totales de esta entidad.
    ld l,c
    ld h,b
    ld (Contador_de_mov_masticados),hl
    ret

 