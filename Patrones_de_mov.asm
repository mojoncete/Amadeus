

;   17/06/23
;
;   Base de datos. PATRONES DE MOVIMIENTO.
;
;   Mov_obj.asm
;
;   Coordenada_X db 0 									    	; Coordenada X del objeto. (En chars.)
;   Coordenada_y db 0 									    	; Coordenada Y del objeto. (En chars.)
;
;   Codificación:
;
;   1er Byte ..... Repetición del movimiento. (0-255) pixeles.
;   2º Byte (Nibble alto) ..... Velocidad del movimiento (% izquierda,derecha,arriba,abajo).
;           (Nibble bajo) ..... Dirección del movimiento (% abajo,arriba,derecha,izquierda).  

;   El "0"; último .db indica que ya hemos terminado de ejecutar todas las cadenas de movimiento.     

Baile_de_BadSat 

; Baja decelerando.    
    db 62,20,%00011000,5,%00001000 ;(2).                                                            

; Codo: bajo y derecha.
    db 1,%00001010,1,%00001000,2,%00001010,1,%00001000,1,%00001010,1,%00001000,2,%00001010
    db 1,%00000010,1,%00001010,2,%00000010,1,%00001010  ;(11).

; Derecha ligeramente ascendente.
    db 2,%00000110,4,%00000010,1,%01000110,4,%01000010,1,%01000110,4,%01000010
    db 1,%01000110,4,%01000010,1,%01000110,4,%01000010,1,%01000110,4,%01000010
    db 1,%01000110,4,%01000010,1,%01000110,4,%01000010,1,%01000110,4,%01000010 
    db 1,%01000110,4,%01000010,1,%01000110,4,%01000010,1,%01000110,4,%01000010
    db 1,%01000110,4,%01000010,1,%01000110,4,%01000010,1,%01000110,4,%01000010
    db 1,%01000110,4,%01000010,1,%01000110,4,%01000010,1,%01000110,4,%01000010
    db 1,%01000110,8,%00000010  ;(38).

; Codo: Derecha y bajo.
    db 1,%00001010,2,%00000010,1,%00001010,1,%00000010,2,%00001010,1,%00001000
    db 1,%00001010,1,%00001000,1,%00001010,1,%00001000,1,%00001010,0    ;(11).




; ----- ----- ----- ----- -----

Indice_mov_Baile_de_BadSat defw Baile_de_BadSat


; ----- ----- ----- ----- -----
;
;   18/06/23

Movimiento 

    ld a,(Contador_db_mov)                                      ; Hemos iniciado la cadena de movimiento ?. Si (Contador_db_mov) aún es "0" hay que inicializarlo._
    and a                                                       ; _Para hacerlo, hemos de fijar antes (Puntero_mov). 
    jr z,1F

    jr Decoder                                                  ; Saltamos a [Decoder] si ya hemos iniciado la cadena.

; Inicializa movimiento, (comienza un movimiento).
; Nota: Previamente, la rutina [DRAW], ha iniciado la entidad, (Puntero_mov) ya apunta a su cadena de movimiento correspondiente.

1 
    ld a,(Incrementa_puntero)                                     ; Vamos a inicializar las variables de movimiento. El contador (Incrementa_puntero) es un byte que inicialmente está a "0"._
    add 2                                                       ; _va incrementando su valor en 2 unidades cada vez que iniciamos una cadena. Se utiliza para ir incrementando (Puntero_mov)_
    ld (Incrementa_puntero),a                                   ; _ por el índice de cadenas de movimiento correspondiente. Su valor se restablecerá a "0" cuando encontremos 
;                                                               ; _ el .db0. (Indica que hemos terminado de leer la secuencia de movimiento completa de la entidad).
    ld hl,(Puntero_mov)
    ld a,(hl)
    ld (Contador_db_mov),a                                      ; Contador de bytes de la cadena inicializado. (El 1er byte de cada cadena de mov. indica el nº de bytes que_
    and a                                                       ; _ tiene la cadena.

    jr z,$

;    jr z, Reinicia_el_movimiento                              ; Hemos terminado de ejecutar todas las cadenas de movimiento. 

; HL contiene (Puntero_mov) y este se encuentra en el 1er byte de la cadena de movimiento, (Contador_db_mov).

    inc hl
    call Prepara_siguiente_mov


Decoder  

; Velocidad del movimiento.

; Guardo el perfil de velocidad de la entidad en una cajita y lo modifico hasta que termine este movimiento.

    call Velocidad_del_movimiento 
    call Aplica_movimiento

; ---------- --------- --------- ---------- ----------

5 ld a,(Repetimos_db)
    and a
    jr z,6F
    dec a
    ld (Repetimos_db),a
    jr z,6f

11 ret

; Pasamos al sigiente .db de la cadena de movimiento.

6 inc hl
    ld (Puntero_mov),hl

    ld hl,Ctrl_2
    res 2,(hl)
    call Restaura_velocidad

    ld hl,Contador_db_mov
    dec (hl)  
    ret z 

    ld hl,(Puntero_mov)
    call Prepara_siguiente_mov

    jr 11B

7 ld hl,(Puntero_indice_mov)                                       ; PASAMOS A LA CADENA SIGUIENTE !!!!!!
    ld a,(Incrementa_puntero)
    ld b,a
8 inc hl
    djnz 8B                                                        ; Indice_patrones_coracao +2, +4, +6, etc...
    ld e,(hl) 
    inc hl
    ld d,(hl)
    ex de,hl
    ld (Puntero_mov),hl                                            ; (Puntero_mov) situado el el 1er .db de la siguiente cadena de movimiento.                                   
    jr 11B

Reinicia_el_movimiento 

    call Prepara_Puntero_mov
    xor a
    ld (Contador_db_mov),a
    ld (Incrementa_puntero),a
    jp Movimiento

Prepara_siguiente_mov ld a,(hl)
    ld (Repetimos_db),a
    inc hl
    ld (Puntero_mov),hl
    ret

; ---------- --------- --------- ---------- ----------
;
;   19/6/23
;
;   Restaura los perfiles de velocidad a x1

Restaura_velocidad ld a,1
    ld b,4
    ld hl,Vel_left
1 ld (hl),a
    inc hl
    djnz 1B
    ret

; ---------- --------- --------- ---------- ----------
;
;   11/8/22
;
;   Prepara_Puntero_mov

Prepara_Puntero_mov ld hl,(Puntero_indice_mov)
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld (Puntero_mov),hl
    ret
    
; ---------- --------- --------- ---------- ----------
;
;   18/06/23
;

Velocidad_del_movimiento 

; Salimos de la rutina si ya hemos guardado anteriormente el perfil de velocidad.
; Salimos porue ya se inició este movimiento de la cadena.

    ld a,(Ctrl_2)
    bit 2,a
    ret nz

    ld ix,Vel_left
    ld hl, (Puntero_mov) 

    ld a,(hl)
    and $f0
    jr z,3F                                 ; RET si no vamos a modifical la velocidad.

    bit 7,(hl)                              
    call nz,X2_vel                          ; Vel_left
    inc ix
    bit 6,(hl)                              
    call nz,X2_vel                          ; Vel_right
    inc ix
    bit 5,(hl)
    call nz,X2_vel                          ; Vel_up
    inc ix
    bit 4,(hl)
    call nz,X2_vel                          ; Vel_down
    
3 ld hl,Ctrl_2
    set 2,(hl)
    ret

; ---------- --------- --------- ---------- ----------
;
;   18/06/23
;
;   Duplica la velocidad.

X2_vel ld a,2
    ld (ix),a
    ret

; ---------- --------- --------- ---------- ----------
;
;   18/06/23
;
;   Aplica_movimiento.
    
Aplica_movimiento ld hl, (Puntero_mov) 
    bit 3,(hl)
    jr z,1F
    call Mov_down
1 ld hl, (Puntero_mov) 
    bit 2,(hl)
    jr z,2F
    call Mov_up
2 ld hl, (Puntero_mov)
    bit 1,(hl)
    jr z,3F
    call Mov_right
3 ld hl, (Puntero_mov)
    bit 0,(hl) 
    jr z,4F
    call Mov_left
4 ret




  


