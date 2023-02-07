

;   11/8/22
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
;   % abajo,arriba,derecha,izquierda ..... nº de repeticiones del movimiento.



Izquierda db 2,%00010000,0
Derecha db 2,%00100000,0
Abajo db 2,%10000000,0
Arriba db 2,%01000000,0

Escaloncitos_izquierda_arriba db 3,%00010100,%01000100,0
Escaloncitos_derecha_arriba db 3,%00100100,%01000100,0
Escaloncitos_izquierda_abajo db 3,%00010100,%10000100,0                ; El "0"; último .db indica que ya hemos terminado de ejecutar todas las cadenas de movimiento.
Escaloncitos_derecha_abajo db 3,%00100100,%10000100,0
Onda_senoidal db 44,%01000100,%01100000,%01000010,%01100000,%01000010,%01100000,%01000000,%01100011
    db %00100010,%01100000,%00100101,%10100000,%00100010,%10100011,%10000000,%10100000
    db %10000010,%10100000,%10000010,%10100000,%10000100,%10100000,%10000011,%10100000
    db %10000010,%10100000,%10000010,%10100000,%10000000,%10100011,%00100010,%10100000
    db %00100101,%01100000,%00100010,%01100011,%01000000,%01100000,%01000010,%01100000
    db %01000010,%01100000,%01000100,0

Derecha_e_izquierda db 3,%00100100,%00010100,0
Izquierda_y_derecha db 3,%00010100,%00100100,0

Indice_mov_Izquierda_y_derecha defw Izquierda_y_derecha 
Indice_mov_Derecha_e_izquierda defw Derecha_e_izquierda
Indice_mov_Izquierda defw Izquierda
Indice_mov_Derecha defw Derecha
Indice_mov_Abajo defw Abajo
Indice_mov_Arriba defw Arriba
Indice_mov_Escaloncitos_derecha_arriba defw Escaloncitos_derecha_arriba
Indice_mov_Escaloncitos_derecha_abajo defw Escaloncitos_derecha_abajo
Indice_mov_Escaloncitos_izquierda_arriba defw Escaloncitos_izquierda_arriba
Indice_mov_Escaloncitos_izquierda_abajo defw Escaloncitos_izquierda_abajo
Indice_mov_Onda_senoidal defw Onda_senoidal

Movimiento ld a,(Contador_db_mov)                               ; Hemos iniciado la cadena de movimiento ?. Si (Contador_db_mov) aún es "0" hay que inicializarlo._
    and a                                                       ; _Para hacerlo, hemos de fijar antes (Puntero_mov). 
    jr z,1F
    jr Decoder                                                  ; Saltamos a [Decoder] si ya hemos iniciado la cadena.
1 ld a,(Incrementa_puntero)                                     ; Vamos a inicializar las variables de movimiento. El contador (Incrementa_puntero) es un byte que inicialmente está a "0"._
    add 2                                                       ; _va incrementando su valor en 2 unidades cada vez que iniciamos una cadena. Se utiliza para ir incrementando (Puntero_mov)_
    ld (Incrementa_puntero),a                                   ; _ por el índice de cadenas de movimiento correspondiente. Su valor se restablecerá a "0" cuando encontremos 
;                                                               ; _ el .db0. (Indica que hemos terminado de leer la secuencia de movimiento completa de la entidad).
    ld hl,(Puntero_mov)
    ld a,(hl)
    ld (Contador_db_mov),a                                      ; Contador de bytes de la cadena inicializado. (El 1er byte de cada cadena de mov. indica el nº de bytes de_
    inc hl                                                      ; _movimiento que hemos de ejecutar).
    ld (Puntero_mov),hl                                         ; Situamos (Puntero_mov) en el 1er byte de instrucciones.

Decoder ld a,(Repetimos_db) 
    and a
    jr nz,12F
    ld hl,(Puntero_mov)
    ld a,(hl)
    and a
    jr z, Reinicia_el_movimiento                              ; Hemos terminado de ejecutar todas las cadenas de movimiento. Llamamos a [Fin_de_movimiento].
    and $0f
    ld (Repetimos_db),a                                         ; Si la variable de repetición de .db es "0" hemos de inicializar dicha variable antes de empezar con la decodificación del .db de_                                      
;                                                               ; _movimiento. Este valor lo proporciona el nibble `bajo´ del byte.
12 ld hl,(Puntero_mov)
    bit 7,(hl)
    jr z,2F
    call Mov_down
2 ld hl, (Puntero_mov) 
    bit 6,(hl)
    jr z,3F
    call Mov_up
3 ld hl, (Puntero_mov)
    bit 5,(hl)
    jr z,4F
    call Mov_right
4 ld hl, (Puntero_mov)
    bit 4,(hl) 
    jr z,5F
    call Mov_left

; ---------- --------- --------- ---------- ----------

5 ld a,(Repetimos_db)
    and a
    jr z,6F
    dec a
    ld (Repetimos_db),a
    jr z,6f
11 ret
6 ld hl,Contador_db_mov
    dec (hl)                                                       ; Decrementamos el contador de .db de la cadena, (pués ya hemos ejecutado un byte de la misma).
    ld hl,(Puntero_mov)                                            ; No repetimos el mismo byte. Incrementamos (Puntero_mov) y salimos.
    inc hl                                                         
    ld (Puntero_mov),hl
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

; ---------- --------- --------- ---------- ----------
;
;   11/8/22
;
;   Prepara_Puntero_mov

Prepara_Puntero_mov push hl
    push de
    ld hl,(Puntero_indice_mov)
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld (Puntero_mov),hl
    pop de
    pop hl
    ret
    
; ---------- --------- --------- ---------- ----------
;
;   11/8/22
;
;   Reinicia_el_movimiento

Reinicia_el_movimiento call Prepara_Puntero_mov
    xor a
    ld (Contador_db_mov),a
    ld (Incrementa_puntero),a
    jp Movimiento

; ---------- --------- --------- ---------- ----------









    





  


