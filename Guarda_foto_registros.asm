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

Guarda_foto_registros 

;    call Selecciona_punteros

    ld (Stack),sp                                 ; Guardo SP en (Stack).
    ld sp,Guarda_foto_registros                   ; Sitúo el Stack Pointer en la dirección actual -1

    push hl                                       ; HL contiene la dirección de la rutina de impresión.
    push ix                                       ; IX contiene el puntero de impresión.
    push iy                                       ; IY contiene (Puntero_objeto).

    ld a,(Ctrl_1)
    bit 0,a
    jr z,2F

    ld hl,(Stack_snapshot_disparos)

    jr 4F

2 ld hl,(Stack_snapshot)                          ; Album_de_fotos contiene la imagen de los registros implicados en el_
4 ld b,3                                          ; _correcto funcionamiento de las distintas rutinas de impresión.

1 pop de
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl                                        ; Volvemos a tener al puntero SP en la posición inicial, (Snapshot)-1.
    djnz 1B    

    bit 0,a
    jr z,5F

    ld (Stack_snapshot_disparos),hl
    jr 6F

5 ld (Stack_snapshot),hl
6 ld sp,(Stack)
;    call Actualiza_punteros                         ; Antes de salir de la rutina recuperamos SP y actualizamos,(o no), (Stack_snapshot).
    ret

; ------------------------------------------------
;
;   28/07/23
;
;   Seleccionamos el primer Album_de_fotos y disparos si (Resorte)="1".   
;   Seleccionamos el segundo Album_de_fotos y disparos si (Resorte)="0".

;Selecciona_punteros 

;     push ix
;     push iy

;     ld a,(Resorte)
;     and a
;     jr z,1F

; 1er Album.
;     ld ix,(Stack_snapshot_1)
;     ld iy,(Stack_snapshot_disparos_1)
;     ld (Stack_snapshot),ix
;     ld (Stack_snapshot_disparos),iy
;     jr 2F

; 2º Album.
; 1 ld ix,(Stack_snapshot_2)
;     ld iy,(Stack_snapshot_disparos_2)
;     ld (Stack_snapshot),ix
;     ld (Stack_snapshot_disparos),iy

; 2 pop iy
;     pop ix
;     ret

; ------------------------------------------------
;
;   28/07/23
;
;   Actualizamos los punteros del 1er album de fotos y disparos, si (Resorte)="1".   
;   Actualizamos los punteros del 2º album de fotos y disparos, si (Resorte)="0".

;Actualiza_punteros 

;     push ix
;     push iy

;     ld a,(Resorte)
;     and a
;     jr z,1F

; 1er Album.
;     ld ix,(Stack_snapshot)
;     ld iy,(Stack_snapshot_disparos)
;     ld (Stack_snapshot_1),ix
;     ld (Stack_snapshot_disparos_1),iy
;     jr 2F

; 2º Album.
; 1 ld ix,(Stack_snapshot)
;     ld iy,(Stack_snapshot_disparos)
;     ld (Stack_snapshot_2),ix
;     ld (Stack_snapshot_disparos_2),iy

; 2 pop iy
;     pop ix
;     ret