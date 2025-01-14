

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
    db $11,$11,$91,253,7,0                  ; Arriba/Derecha. 1rep. --- Repite Mov 12rep. --- Termina movimiento.

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
    db $11,$11,$a1,253,8,0                  ; Arriba/Derecha. 1rep. --- Repite Mov 12rep. --- Termina movimiento.

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









 