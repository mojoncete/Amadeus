; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	9/8/23
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

    di

7 ld (Stack),sp                                 ; Guardo SP en (Stack).
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

; Aquí tengo que copiar (Stack_snapshot) en la dirección hacia donde apunta (Puntero_de_End_Snapshot).

    ld e,l
    ld d,h                                        ; DE contiene la dirección donde terminan los datos de este álbum.

    ld hl,(Puntero_de_End_Snapshot)               ; Guardamos la dirección de `fin de álbum', en la dirección que_
    ld (hl),e                                     ; _ contiene (Puntero_de_End_Snapshot). Esta dirección la utilizará la_
    inc hl                                        ; _ rutina [Gestiona_albumes_de_fotos] para copiar los datos de un_
    ld (hl),d                                     ; _ álbum a otro.

    ei

    ret

; ------------------------------------------------
;
;   3/08/23
;
;   La rutina estará situada justo después de:
;   Album_de_fotos_disparos_3 equ $7396	; (7396h - 7418h).
;
;   Limpia Album_de_fotos después de imprimir pantalla y desplaza el buffer una posición.
;   Si el buffer estaba lleno, dejará libre Album_de_fotos_3.   

    org $7419 

Gestiona_albumes_de_fotos 

;   En 1er lugar limpiamos el FRAME pintado.
;   Vaciamos Album_de_fotos.

;   Album_de_fotos. Contiene datos ???

    ld hl,Album_de_fotos+1
    ld a,(hl)
    and a
    jr z,3F                     ; Album_de_fotos está vacío. NO HAY QUE LIMPIARLO.

    ld hl,(End_Snapshot)
    ld bc,Album_de_fotos
    ld de,Album_de_fotos+1
    xor a
    ld (bc),a                   ; "0" en el 1er byte de origen.                  

    call Limpia_album

    ld hl,0
    ld (End_Snapshot),hl        ; Limpia (End_Snapshot).

; ----- ----- ----- -----

;   Album_de_fotos_1. Contiene datos ???

3 ld hl,Album_de_fotos_1+1
    ld a,(hl)
    and a
    jr z,1F                     ; Album_de_fotos y Album_de_fotos_1 están vacíos. Hay que volcar la_
;                               ; _ información del album2 al album1.

; ----- ----- ----- -----
;   Volcamos los datos del Album_de_fotos_1 a Album_de_fotos.

    ld hl,(End_Snapshot_1)      ; Final, (origen).
    ld bc,Album_de_fotos_1      ; Origen.
    ld de,Album_de_fotos        ; Destino.

    call Limpia_album

;   Calculamos (End_Snapshot)

    and a
    adc hl,bc
    ld (End_Snapshot),hl

;   Limpiamos Album_de_fotos_1.

    ld hl,(End_Snapshot_1)
    ld bc,Album_de_fotos_1
    ld de,Album_de_fotos_1+1
    xor a
    ld (bc),a                       

    call Limpia_album

    ld hl,0
    ld (End_Snapshot_1),hl        ; Limpia (End_Snapshot_1).

; ----- ----- ----- -----

;   Album_de_fotos_2. Contiene datos ???

1 ld hl,Album_de_fotos_2+1
    ld a,(hl)
    and a
    jr z,2F                     ; Album_de_fotos_2 y Album_de_fotos_1 están vacíos. Hay que volcar la_
;                               ; _ información del album3 al album2.
; ----- ----- ----- -----
;   Volcamos los datos del Album_de_fotos_2 a Album_de_fotos_1.

    ld hl,(End_Snapshot_2)      ; Final, (origen).
    ld bc,Album_de_fotos_2      ; Origen.
    ld de,Album_de_fotos_1      ; Destino.

    call Limpia_album

;   Calculamos (End_Snapshot_1):

    and a
    adc hl,bc
    ld (End_Snapshot_1),hl

;   Limpiamos Album_de_fotos_2.

    ld hl,(End_Snapshot_2)
    ld bc,Album_de_fotos_2
    ld de,Album_de_fotos_2+1
    xor a
    ld (bc),a                       

    call Limpia_album

    ld hl,0
    ld (End_Snapshot_2),hl        ; Limpia (End_Snapshot_2).

; ----- ----- ----- -----

;   Album_de_fotos_3. Contiene datos ???

2 ld hl,Album_de_fotos_3+1
    ld a,(hl)
    and a
    ret z                       ; Album_de_fotos_3 y Album_de_fotos_2 están vacíos. RET.
               
; ----- ----- ----- -----
;   Volcamos los datos del Album_de_fotos_3 a Album_de_fotos_2.

    ld hl,(End_Snapshot_3)      ; Final, (origen).
    ld bc,Album_de_fotos_3      ; Origen.
    ld de,Album_de_fotos_2      ; Destino.

    call Limpia_album

;   Calculamos (End_Snapshot_2):

    and a
    adc hl,bc
    ld (End_Snapshot_2),hl

;   Limpiamos Album_de_fotos_3.

    ld hl,(End_Snapshot_3)
    ld bc,Album_de_fotos_3
    ld de,Album_de_fotos_3+1
    xor a
    ld (bc),a                       

    call Limpia_album

    ld hl,0
    ld (End_Snapshot_3),hl        ; Limpia (End_Snapshot_3).
    ret

; ----------------------------------------------------
;
;   10/8/23
;
;   Limpia o transfiere el contenido de un album_de_fotos o disparos a otro álbum.
;
;   INPUTS: HL ..... Contiene el nº de bytes a borrar.
;           BC ..... Dirección de inicio del álbum.
;           DE ..... Dirección de inicio del álbum. +1

;    ld hl,(End_Snapshot)
;    ld bc,Album_de_fotos
;    ld de,Album_de_fotos+1

;   MODIFICA: A,HL,BC y DE.

Limpia_album 
    push de            ; Guardo DESTINO.
    push bc            ; Guardo ORIGEN.
    sbc hl,bc
    ld c,l
    ld b,h
    pop hl
    push bc
    ldir
    pop bc                      ; Esta cantidad la utilizaré para calcular (End_Snapshot_X), _
    pop hl                      ; _ al salir de la rutina, (cuando estamos pasando datos de un álbum_
    ret                         ; _ a otro). 
;                               

; -----------------------------------------------





