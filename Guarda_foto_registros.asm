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

;   (Stack_snapshot) se sitúa inicialmente en (Album_de_fotos)=$7000.
;   Almacenaremos los datos/registros necesarios de la siguiente manera:
;
;   $7000 / 01 ..... Puntero objeto.
;   $7002 / 03 ..... Puntero de impresion.
;   $7004 / 05 ..... Rutina de impresión.

Guarda_foto_registros 

    ld (Stack),sp                                 ; Guardo SP en (Stack).

    ld sp,Puntero_de_impresion+2                  ; Almacenamos el (Puntero_de_impresion) actual de la entidad.
    push ix                                       ; Utilizaremos este dato para generar las coordenadas_X que ocupa la entidad y compararlas_
;                                                 ; _ con las coordenadas_X de Amadeus.
    ld sp,Guarda_foto_registros                   ; Sitúo el Stack Pointer en la dirección actual -1

    push hl                                       ; HL contiene la dirección de la rutina de impresión.
    push ix                                       ; IX contiene el puntero de impresión.
    push iy                                       ; IY contiene (Puntero_objeto).

; Disparo o entidad?

    ld a,(Ctrl_1)
    bit 0,a
    jr z,2F

    ld hl,(Stack_snapshot_disparos)
    jr 4F

; No es disparo. Entidad/Amadeus ????

2 ld a,(Ctrl_0)
    bit 6,a
    jr z,7F

; Guardamos foto de Amadeus.

    ld hl,(End_Snapshot_Amadeus)
    jr 4F

7 ld hl,(Stack_snapshot)                          ; Album_de_fotos contiene la imagen de los registros implicados en el_

4 ld b,3                                          ; _correcto funcionamiento de las distintas rutinas de impresión.

1 pop de
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl                                        ; Volvemos a tener al puntero SP en la posición inicial, (Snapshot)-1.
    djnz 1B    

; Disparo o entidad ?

    ld a,(Ctrl_1)
    bit 0,a
    jr z,5F
    
    ld (Stack_snapshot_disparos),hl
    jr 6F

; Entidad o Amadeus ?

5 ld a,(Ctrl_0)
    bit 6,a
    jr z,8F

    ld (End_Snapshot_Amadeus),hl    
    ld sp,(Stack)
    ret

8 ld (Stack_snapshot),hl
6 ld sp,(Stack)

    ret

; -----------------------------------------------------------------------------
;
;   21/11/23

Limpia_y_reinicia_Stack_Snapshot 

;   Limpia Album_de_fotos.
    
    ld hl,(Stack_snapshot)
    ld a,l
    and a
    ret z   ;   Salimos si el álbum está vacío.

    ld b,a
    inc b

1 ld (hl),0
    dec l
    djnz 1B

;   Reinicializa (Stack_snapshot).

    ld hl,Album_de_fotos
    ld (Stack_snapshot),hl

    ret