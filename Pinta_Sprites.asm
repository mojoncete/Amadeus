; -----------------------------------------------------------------------------
;
;   11/03/24
;

    org $9119

Pinta_Sprites 

;    ld hl,(Scanlines_album_SP)
;    call Extrae_address

;    inc h
;    dec h
;    ret z                              ; Salimos si hemos terminado de pintar o el album de líneas está vacío.

    ld (Stack),sp
 
    ex de,hl                            ; HL se encuentra en el álbum de líneas.
;                                       ; DE se encuentra en los datos del sprite.
    inc l
    inc l

    ld b,(hl)                           ; B contiene el nº de scanlines a imprimir.

    inc l
    ld sp,hl                            ; El SP irá extrayendo scanlines en HL.

;   Seleccionamos rutina de impresión:

    ld a,16
    cp b
    jp nz,Pinta_lento                   ; Si el sprite no se imprime completo utilizamos la 2ª rutina de pintado.
 
;   Rutinas:

Pinta_rapido    ;   1520 t/states.

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

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
    inc de

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret

Pinta_lento 

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
    inc de

    djnz 1B

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret