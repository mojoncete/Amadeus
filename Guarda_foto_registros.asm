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

    ret

; ------------------------------------------------
;
;   31/07/23
;
Gestiona_albumes_de_fotos 

; Desplazamos álbumes.

; (Album_de_fotos_1) --- (Album_de_fotos).

;   El álbum_1 contiene datos?

    ld hl,Album_de_fotos_1+1
    ld a,(hl)
    and a
    jr z,1F

;   El álbum_1 contiene datos. Volcamos los datos a Album_de_fotos.

    call Album_1_a_Album_de_fotos
    jr 2F

; El álbum_1 está vacío. 
; Album_de_fotos contiene datos?

1 ld hl,Album_de_fotos+1
    ld a,(hl)
    and a
    jr z,2F

; Limpiamos Album_de_fotos.

    ld hl,Album_de_fotos
    ld (hl),0
    ld de,Album_de_fotos+1
    ld bc,$83
    ldir    
    ld hl,Album_de_fotos
    ld (Stack_snapshot),hl

; (Album_de_fotos_2) --- (Album_de_fotos_1).

;   El álbum_2 contiene datos?

2 ld hl,Album_de_fotos_2+1
    ld a,(hl)
    and a
    jr z,3F

;   El álbum_1 contiene datos. Volcamos los datos a Album_de_fotos.

    call Album_2_a_Album_1
    jr 4F

; El álbum_2 está vacío. 
; álbum_1 contiene datos?

3 ld hl,Album_de_fotos_1+1
    ld a,(hl)
    and a
    jr z,4F

; Limpiamos Album_de_fotos_1.

    ld hl,Album_de_fotos_1
    ld (hl),0
    ld de,Album_de_fotos_1+1
    ld bc,$83
    ldir    
    ld hl,Album_de_fotos_1
    ld (Stack_snapshot_1),hl

; (Album_de_fotos_3) --- (Album_de_fotos_2).

;   El álbum_3 contiene datos?

4 ld hl,Album_de_fotos_3+1
    ld a,(hl)
    and a
    jr z,5F

;   El álbum_1 contiene datos. Volcamos los datos a Album_de_fotos.

    call Album_3_a_Album_2
    jr 6F

; El álbum_3 está vacío. 
; álbum_2 contiene datos?

5 ld hl,Album_de_fotos_2+1
    ld a,(hl)
    and a
    jr z,6F

; Limpiamos Album_de_fotos_2.

    ld hl,Album_de_fotos_2
    ld (hl),0
    ld de,Album_de_fotos_2+1
    ld bc,$83
    ldir    
    ld hl,Album_de_fotos_2
    ld (Stack_snapshot_2),hl

6 ret

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

Trasbase_1a0 ld hl,(Stack_snapshot_1)
    ld bc,Album_de_fotos_1
    call Trasbase_de_datos
    ret 

; ----------------------------------------------

; (Album_de_fotos_2) está vacío. Pasamos los datos de (Album_de_fotos_3) a (Album_de_fotos_2) y_ 
; _ limpiamos (Album_de_fotos_3).
; Para ambas cosas ejecutaremos la rutina [Trasbase_de_datos].

;   Datos de álbum_3 a álbum_2.

Album_3_a_Album_2 ld de,Album_de_fotos_2
    call Trasbase_3a2
    
;   Actualizamos (Stack_snapshot_2).   

    ex de,hl
    ld (Stack_snapshot_2),hl

;   Limpiamos álbum_3 y actualizamos (Stack_snapshot_3).

    xor a
    ld (Album_de_fotos_3),a
    ld de,Album_de_fotos_3+1
    call Trasbase_3a2

    ld hl,Album_de_fotos_3
    ld (Stack_snapshot_3),hl
    ret

Album_2_a_Album_1 ld de,Album_de_fotos_1
    call Trasbase_2a1

;   Actualizamos (Stack_snapshot_1).   

    ex de,hl
    ld (Stack_snapshot_1),hl

;   Limpiamos álbum_2 y actualizamos (Stack_snapshot_2).

    xor a
    ld (Album_de_fotos_2),a
    ld de,Album_de_fotos_2+1
    call Trasbase_2a1

    ld hl,Album_de_fotos_2
    ld (Stack_snapshot_2),hl
    ret

Album_1_a_Album_de_fotos ld de,Album_de_fotos
    call Trasbase_1a0

;   Actualizamos (Stack_snapshot).   

    ex de,hl
    ld (Stack_snapshot),hl

 ;   Limpiamos álbum_1 y actualizamos (Stack_snapshot_1).

    xor a
    ld (Album_de_fotos_1),a
    ld de,Album_de_fotos_1+1
    call Trasbase_1a0

    ld hl,Album_de_fotos_1
    ld (Stack_snapshot_1),hl
    ret

