; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	8/11/22
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

Guarda_foto_registros ld (Stack),sp			                      ; Guardo SP en (Stack).
    ld sp,Guarda_foto_registros - 1               ; Sitúo el Stack Pointer en la dirección actual -1

    push hl
    push bc
    push de
    push ix

    ex af,af
    push af
    ex af,af

    exx
    push bc
    push hl                                        ; Hacemos un SNAPSHOT de los registros.
    exx

    ld hl,(Stack_snapshot)                         ; Album_de_fotos contiene la imagen de los registros implicados en el_
    ld b,7                                         ; _correcto funcionamiento de [Pintorrejeo].

1 pop de
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl                                         ; Volvemos a tener al puntero SP en la posición inicial, (Snapshot)-1.
    djnz 1B    

    ld (Stack_snapshot),hl
    ld sp,(Stack)

3 ret                                             ; Antes de salir de la rutina recuperamos SP y actualizamos,(o no), (Stack_snapshot).


