; -----------------------------------------------------------------------------
;
;   28/12/24
;

; Scanlines_album equ $8000	;	($8000 - $8118) 						; Inicialmente 280 bytes, $118. 
; Scanlines_album_2 equ $811a	;    ($811a - $8232)
; Amadeus_scanlines_album equ $8234	;	($8234 - $8256) 				; Inicialmente 34 bytes, $22.
; Amadeus_scanlines_album_2 equ $8258	;	($8258 - $827a)

Rutinas_de_pintado 

    ld (Stack),sp
 
    ex de,hl                                          ; HL se encuentra en el álbum de líneas.
;                                                     ; DE se encuentra en los datos del sprite.
    inc l
    inc l

    ld b,(hl)                                         ; B contiene el nº de scanlines a imprimir.

    inc l

    ld sp,hl                                          ; El SP irá extrayendo scanlines en HL.

;   Vamos a imprimir una entidad o Amadeus ??? 

    ld a,l
    cp $34
    jr c,Printing_routines_selector

    pop hl
    jr Pinta_rapido_3Chars                            ; Amadeus SIEMPRE se imprime completo, (3 Chars) y 16 scanlines.

;   ----- ----- ----- ----- -----

Printing_routines_selector

;   Seleccionaremos la rutina adecuada en función del nº de columna en el que nos encontremos.
;   Columnas (2-29) utilizaremos [Print_3Chars], Estas rutinas imiprimen el sprite completo, 3 chars.

; En que columna nos encontramos?

    pop hl                                            ; Dirección de pantalla del 1er scan del sprite

    ld a,l
    and $1f
    cp 30
    jp nc,Desaparece_por_la_derecha

; -----------------------------------------------------------------------------------------------------------------------------

Print_3Chars

;   DE apunta al 1er .db de datos del sprite, (Puntero_objeto).
;   HL contiene la dirección de pantalla donde imprimiremos el 1er scanline del sprite.
;   B contiene el nº de scanlines que vamos a imprimir del sprite.

;   16 scanlines o menos ???

    ld a,b
    cp 16
    jp nz,Pinta_lento_3Chars                           ; Si el sprite no se imprime completo utilizamos la 2ª rutina de pintado.
 
;   Rutinas:

Pinta_rapido_3Chars                                    ;   1520 t/states.

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret

Pinta_lento_3Chars 

1 pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    djnz 1B

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret

; -----------------------------------------------------------------------
; -----------------------------------------------------------------------
; -----------------------------------------------------------------------


Desaparece_por_la_derecha

;   1 o 2 Chars ???

    jp nz,Print_1Char_right                                 ; "NZ" indica Columna "$1f".

Print_2Chars_right

;   DE apunta al 1er .db de datos del sprite, (Puntero_objeto).
;   HL contiene la dirección de pantalla donde imprimiremos el 1er scanline del sprite.
;   B contiene el nº de scanlines que vamos a imprimir del sprite.

;   16 scanlines o menos ???

    ld a,b
    cp 16
    jp nz,Pinta_lento_2Chars_right                         ; Si el sprite no se imprime completo utilizamos la 2ª rutina de pintado.
 
;   Rutinas:

Pinta_rapido_2Chars_right                                  ;   1520 t/states.

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret

Pinta_lento_2Chars_right

2 pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    djnz 2B

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret

; -----------------------------------------------------------------------
; -----------------------------------------------------------------------

Print_1Char_right


;   DE apunta al 1er .db de datos del sprite, (Puntero_objeto).
;   HL contiene la dirección de pantalla donde imprimiremos el 1er scanline del sprite.
;   B contiene el nº de scanlines que vamos a imprimir del sprite.

;   16 scanlines o menos ???

    ld a,b
    cp 16
    jp nz,Pinta_lento_1Char_right                          ; Si el sprite no se imprime completo utilizamos la 2ª rutina de pintado.
 
;   Rutinas:

Pinta_rapido_1Char_right                                  ;   1520 t/states.

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret

Pinta_lento_1Char_right

3 pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    djnz 3B

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret 