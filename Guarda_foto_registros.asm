; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	3/1/23
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


    org $7fa0

;   (Stack_snapshot) se sitúa inicialmente en (Album_de_fotos)=$7000.
;   Almacenaremos los datos/registros necesarios de la siguiente manera:
;
;   $7000 / 01 ..... Puntero objeto.
;   $7002 / 03 ..... Puntero de impresion.
;   $7004 / 05 ..... Rutina de impresión.

Guarda_foto_registros ld (Stack),sp               ; Guardo SP en (Stack).
    ld sp,Guarda_foto_registros - 1               ; Sitúo el Stack Pointer en la dirección actual -1

    push hl                                       ; HL contiene la dirección de la rutina de impresión.
    push ix                                       ; IX contiene el puntero de impresión.
    push iy                                       ; IY contiene (Puntero_objeto).

    ld hl,(Stack_snapshot)                        ; Album_de_fotos contiene la imagen de los registros implicados en el_
    ld b,3                                        ; _correcto funcionamiento de las distintas rutinas de impresión.

1 pop de
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl                                        ; Volvemos a tener al puntero SP en la posición inicial, (Snapshot)-1.
    djnz 1B    

    ld (Stack_snapshot),hl
    ld sp,(Stack)

3 ret                                             ; Antes de salir de la rutina recuperamos SP y actualizamos,(o no), (Stack_snapshot).


