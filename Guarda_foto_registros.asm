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

    ld (Stack),sp                                 ; Guardo SP en (Stack).
    ld sp,Guarda_foto_registros                   ; Sitúo el Stack Pointer en la dirección actual -1

    push hl                                       ; HL contiene la dirección de la rutina de impresión.
    push ix                                       ; IX contiene el puntero de impresión.
    push iy                                       ; IY contiene (Puntero_objeto).

    ld a,(Ctrl_1)
    bit 0,a
    jr z,2F

    ld hl,(Stack_snapshot_disparos_3)

    jr 4F

2 ld hl,(Stack_snapshot_3)                        ; Album_de_fotos contiene la imagen de los registros implicados en el_

4 ld b,3                                          ; _correcto funcionamiento de las distintas rutinas de impresión.

1 pop de
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl                                        ; Volvemos a tener al puntero SP en la posición inicial, (Snapshot)-1.
    djnz 1B    

    bit 0,a
    jr z,5F

    ld (Stack_snapshot_disparos_3),hl
    jr 6F

5 ld (Stack_snapshot_3),hl
6 ld sp,(Stack)

;    call Actualiza_punteros                         ; Antes de salir de la rutina recuperamos SP y actualizamos,(o no), (Stack_snapshot).

    ret

; ------------------------------------------------
;
;   31/07/23
;
Gestiona_albumes_de_fotos

; Comprobamos si en el frame anterior hemos escrito en (Album_de_fotos_3).
; Si no es así, salimos, (no ha habido movimiento).

    ld hl,Album_de_fotos_3+1
    ld a,(hl)
    and a

;   Salimos. --- X --- X --- 0

    ret z

; Comprobamos si (Album_de_fotos_2) está vacío.

    ld hl,Album_de_fotos_2+1
    ld a,(hl)
    and a
    jr nz,1F

; (Album_de_fotos_2) está vacío. Pasamos los datos de (Album_de_fotos_3) a (Album_de_fotos_2) y_ 
; _ limpiamos (Album_de_fotos_3).
; Para ambas cosas ejecutaremos la rutina [Trasbase_de_datos].

;   Datos de álbum_3 a álbum_2.

    ld de,Album_de_fotos_2
    call Trasbase_3a2
    
;   Actualizamos (Stack_snapshot_2).   

    ex de,hl
    ld (Stack_snapshot_2),hl

;   Limpiamos álbum_3 y actualizamos (Stack_snapshot_3).

    ld de,Album_de_fotos_3+1
    call Trasbase_3a2

    ld hl,Album_de_fotos_3
    ld (Stack_snapshot_3),hl
 
;   Salimos. --- 0 --- 1 --- 0

    ret

; (Álbumes_2 y 3) contienen datos, ( 0 --- 1 --- 1).
; Pasamos los datos del álbum_2 al 1.

 
;   Datos de álbum_2 a álbum_1.

1 ld de,Album_de_fotos_1
    call Trasbase_2a1

;   Actualizamos (Stack_snapshot_1).   

    ex de,hl
    ld (Stack_snapshot_1),hl

;   Limpiamos álbum_2 y actualizamos (Stack_snapshot_2).

    ld de,Album_de_fotos_2+1
    call Trasbase_2a1

    ld hl,Album_de_fotos_2
    ld (Stack_snapshot_2),hl

;! Tengo 1--0--1. Tengo que pasar los datos del álbum_3 al álbum2. Limpiar el álbum3 y salir. 
 
    ld a,(Contador_de_frames)
    jr $

; ----------------------------------------------
;
;   31/7/23
;
;   Esta rutina sirve tanto para pasar datos de un album a otro, como para limpiarlo.
;
;   Para pasar datos de un album a otro:
;
;       INPUTS: HL contiene (Stack_snapshot_X), siendo X el álbum ORIGEN.
;               BC contendrá la dirección de inicio del álbum ORIGEN. Ej. Album_de_fotos_3.
;               DE contendrá la dirección de inicio del álbum DESTINO. Ej. Album_de_fotos_2.

Trasbase_de_datos push bc
    and a
    sbc hl,bc
    push hl
    pop bc                          ; BC contiene el nº de bytes que ocupan los datos almacenados en el álbum. 
    pop hl
    ldir
    ret

; Paquetitos.

Trasbase_3a2 ld hl,(Stack_snapshot_3)
    ld bc,Album_de_fotos_3
    call Trasbase_de_datos
    ret 

Trasbase_2a1 ld hl,(Stack_snapshot_2)
    ld bc,Album_de_fotos_2
    call Trasbase_de_datos
    ret 

; ----------------------------------------------

