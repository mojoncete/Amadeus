; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	12/12/23
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

    org $80bf

;   (Scanlines_album_SP) se sitúa inicialmente al comienzo del Scanlines_album.
;   DE contiene Puntero_objeto.
;   IX contiene el Puntero de impresión.

Genera_datos_de_impresion 

    ld (Stack),sp                                 ; Guardo SP en (Stack).
    ld sp,Puntero_de_impresion+2                  ; Almacenamos el (Puntero_de_impresion) actual de la entidad.
    push ix                                       ; Utilizaremos este dato para generar las coordenadas_X que ocupa la entidad y compararlas_

    ld hl,(Scanlines_album_SP)

    ld a,5
    add l
    ld l,a

    ld sp,hl
    ld (Scanlines_album_SP),hl

    ld hl,0

    push ix
    dec sp
    adc hl,sp
    push de

; Recuperamos SP.

    ld sp,(Stack)

    push hl
    pop af
    ex af,af'                                      ; AF´ almacena la casilla donde vamos a almacenar el nº de scanlines que vamos a generar a continuación. 
    
; Tenemos el encabezado listo.
; Preparamos registros para generar los scanlines.

    push ix
    pop hl                                         ; 1er scanline en HL.


    ld de,(Scanlines_album_SP)

;   Llegados a este punto: seguimos teniendo el Puntero_de_impresión en IX y Puntero_objeto en DE.

    








; Disparo o entidad ?

    ld a,(Ctrl_1)
    bit 0,a
    jr z,5F
    
;    ld (Scanlines_album_disparos_SP),hl
    jr 6F

; Entidad o Amadeus ?

5 ld a,(Ctrl_0)
    bit 6,a
    jr z,8F

;    ld (End_Snapshot_Amadeus),hl    
;    ld sp,(Stack)
    ret

8 ld (Scanlines_album_SP),hl
6 ld sp,(Stack)

    ret

; -----------------------------------------------------------------------------
;
;   21/11/23

Limpia_y_reinicia_Scanlines_album

;   Limpia Scanlines_album.
    
    ld hl,(Scanlines_album_SP)
    ld a,l
    and a
    ret z   ;   Salimos si el álbum está vacío.

    ld b,a
    inc b

1 ld (hl),0
    dec l
    djnz 1B

;   Reinicializa (Scanlines_album_SP).

    ld hl,Scanlines_album
    ld (Scanlines_album_SP),hl

    ret