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

;   (Album_de_lineas_SP) se sitúa inicialmente al comienzo del Album_de_lineas.
;   DE contiene Puntero_objeto.
;   IX contiene el Puntero de impresión.

Guarda_foto_registros 

    ld (Stack),sp                                 ; Guardo SP en (Stack).
    ld sp,Puntero_de_impresion+2                  ; Almacenamos el (Puntero_de_impresion) actual de la entidad.
    push ix                                       ; Utilizaremos este dato para generar las coordenadas_X que ocupa la entidad y compararlas_

    ld hl,(Album_de_lineas_SP)

    ld a,5
    add l
    ld l,a

    ld sp,hl
    ld (Album_de_lineas_SP),hl

    ld hl,0
;                                                 ; _ con las coordenadas_X de Amadeus.
;    ld sp,Guarda_foto_registros                   ; Sitúo el Stack Pointer en la dirección actual -1

;    push hl                                       ; HL contiene la dirección de la rutina de impresión.

;    push ix                                       ; IX contiene el puntero de impresión.
;    push iy                                       ; IY contiene (Puntero_objeto).

; Disparo o entidad?

    ld a,(Ctrl_1)
    bit 0,a
    jr z,2F

    ld hl,(Album_de_lineas_disparos_SP)
    jr 4F

; No es disparo. Entidad/Amadeus ????

2 ld a,(Ctrl_0)
    bit 6,a
    jr z,7F

; Guardamos foto de Amadeus.

    ld hl,(End_Snapshot_Amadeus)
    jr 4F

;Vamos a generar los scanlines de una entidad.

4 jr $ 

7 
    jr $

    push ix
    dec sp
    adc hl,sp
    push de
    ld sp,(Stack)

    push hl

;   Llegados a este punto: seguimos teniendo el Puntero_de_impresión en IX y Puntero_objeto en DE.











; Disparo o entidad ?

    ld a,(Ctrl_1)
    bit 0,a
    jr z,5F
    
    ld (Album_de_lineas_disparos_SP),hl
    jr 6F

; Entidad o Amadeus ?

5 ld a,(Ctrl_0)
    bit 6,a
    jr z,8F

    ld (End_Snapshot_Amadeus),hl    
    ld sp,(Stack)
    ret

8 ld (Album_de_lineas_SP),hl
6 ld sp,(Stack)

    ret

; -----------------------------------------------------------------------------
;
;   21/11/23

Limpia_y_reinicia_Album_de_lineas

;   Limpia Album_de_lineas.
    
    ld hl,(Album_de_lineas_SP)
    ld a,l
    and a
    ret z   ;   Salimos si el álbum está vacío.

    ld b,a
    inc b

1 ld (hl),0
    dec l
    djnz 1B

;   Reinicializa (Album_de_lineas_SP).

    ld hl,Album_de_lineas
    ld (Album_de_lineas_SP),hl

    ret