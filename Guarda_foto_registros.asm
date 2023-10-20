; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	4/9/23
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

; En 1er lugar guardaremos las variables de borrado del siguiente cuadro.

    ld sp,Variables_de_borrado+6

    push hl
    push ix
    push iy

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

; Aquí tengo que copiar (Stack_snapshot) en la dirección hacia donde apunta (Puntero_de_End_Snapshot).

    ld e,l
    ld d,h                                        ; DE contiene la dirección donde terminan los datos de este álbum.

    ld hl,(Puntero_de_End_Snapshot)               ; Guardamos la dirección de `fin de álbum', en la dirección que_
    ld (hl),e                                     ; _ contiene (Puntero_de_End_Snapshot). Esta dirección la utilizará la_
    inc hl                                        ; _ rutina [Gestiona_albumes_de_fotos] para copiar los datos de un_
    ld (hl),d                                     ; _ álbum a otro.

    ret

; ------------------------------------------------
;
;   19/10/23
;
;   La rutina estará situada justo después de:
;   Almacen_de_parametros_DRAW equ $72ac ; ($72ac - $72eb) ; 61 bytes.

;   Limpia Album_de_fotos después de imprimir pantalla y desplaza el buffer una posición.
;   Si el buffer estaba lleno, dejará libre Album_de_fotos_3.   

    org $72ec 

Gestiona_albumes_de_fotos 

; En 1er lugar consultamos el bit_4 de (Semaforo).
; Nos indica si existe algún album vacío.

    ld a,(Semaforo)
    bit 4,a
    jr z,7F

    res 4,a
    ld (Semaforo),a

; Album_de_fots_2 o Album_de_fotos_1 está vacío.
; Album_de_fotos_2 ???

    bit 7,a                         ; bit_7 ="1". Indica que Album_de_fotos_2 está vacío.
    jr z,8F                         ; Hay que "ordenar los álbumes". Volcamos Album_de_fotos_3 a Album_de_fotos_2.

    res 7,a
    set 5,a                         ; El bit_5 indica que el álbum ha sido reestructurado. 
    res 3,a
    res 2,a                         ; Cuando salgamos de la rutina la disposición de los álbumes será: x-x-0-0.

    ld (Semaforo),a

    call Album3_a_Album2
    call Actualiza_punteros_de_albumes

    jr 7F


; Album_de_fotos_1 está vacío.

8 jr $

; #############################################################3

;   En 1er lugar limpiamos el FRAME pintado.
;   Vaciamos Album_de_fotos.

;   Album_de_fotos. Contiene datos ???

7 ld hl,Album_de_fotos+1
    ld a,(hl)
    and a
    jr z,3F                     ; Album_de_fotos está vacío. NO HAY QUE LIMPIARLO.

;   Hemos impreso Album_de_fotos. Limpiamos el álbum y actualizamos (End_Snapshot).

    ld hl,(End_Snapshot)
    ld bc,Album_de_fotos
    ld de,Album_de_fotos+1
    xor a
    ld (bc),a                   ; "0" en el 1er byte de origen.                  

    call Limpia_album

    ld hl,0
    ld (End_Snapshot),hl        ; Limpia (End_Snapshot).

; ----- ----- ----- -----

;   Album_de_fotos está vacío y (End_Snapshot)="0".
;   Album_de_fotos_1. Contiene un frame completo ???

3 ld a,(Semaforo)
    bit 1,a
    jr nz,4F

;   Album_de_fotos_1 no está completo.     

    ld hl,Semaforo
    set 4,(hl)                  ; Indica a la rutina [Gestiona_entidades] que no tenemos que modificar (Puntero_indice_album_de_fotos) ni_
    res 1,(hl)
    ret                         ; _ (Puntero_indice_End_Snapshot). Hay que completar el álbum. 

;   Album_de_fotos_1 contiene un Frame completo. Contiene datos ???

4 ld hl,Album_de_fotos_1+1
    ld a,(hl)
    and a
    jr z,1F                     ; Album_de_fotos y Album_de_fotos_1 están vacíos. Saltamos a analizar Album_de_fotos_2.

; ----- ----- ----- -----
; ----- ----- ----- -----

;   Album_de_fotos_1 Contiene un frame completo que hay que volcar en Album_de_fotos.
;   Actualiza (End_Snapshot).

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

;   Album_de_fotos_2. Contiene Frame completo ???

1 ld a,(Semaforo)
    bit 2,a
    jr nz,5F

;   Album_de_fotos_2 no está completo.     

    ld hl,Semaforo
    set 4,(hl)                  ; Indica a la rutina [Gestiona_entidades] que no tenemos que modificar (Puntero_indice_album_de_fotos) ni_
    res 2,(hl)

;   Album_de_fotos_2 contiene un FRAME completo. Datos ???.

5 ld hl,Album_de_fotos_2+1
    ld a,(hl)
    and a
    jr z,2F                     ; Album_de_fotos_2 y Album_de_fotos_1 están vacíos. Saltamos a analizar Album_de_fotos_3.

; ----- ----- ----- -----
; ----- ----- ----- -----
; ----- ----- ----- -----

;   Album_de_fotos_2 contiene un frame completo.
;   Volcamos los datos del Album_de_fotos_2 a Album_de_fotos_1.

    ld hl,(End_Snapshot_2)      ; Final, (origen).
    ld bc,Album_de_fotos_2      ; Origen.
    ld de,Album_de_fotos_1      ; Destino.

    call Limpia_album

;   Actualizamos (End_Snapshot_1):

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

;   Album_de_fotos_2 está vacío y (End_Snapshot_2)="0".
;   Album_de_fotos_3. Contiene un frame completo ???

2 ld a,(Semaforo)
    bit 3,a
    jr nz,6F

;   Album_de_fotos_3 no está completo.     

;   Ha sido reestructurado ???

    ld a,(Semaforo)
    bit 5,a


;! debugggggggggg

    jr nz,$



    ret nz

    ld hl,Semaforo
    set 4,(hl)                  ; Indica a la rutina [Gestiona_entidades] que no tenemos que modificar (Puntero_indice_album_de_fotos) ni_
    set 7,(hl)                  ; _ (Puntero_indice_End_Snapshot). Hay que completar el álbum. 
    ret                         

;   Album_de_fotos_3 contiene un FRAME completo. Datos ???

6 ld hl,Album_de_fotos_3+1
    ld a,(hl)
    and a
    ret z                       ; Album_de_fotos_3 y Album_de_fotos_2 están vacíos. RET.
               
; ----- ----- ----- -----
; ----- ----- ----- -----
; ----- ----- ----- -----

;   Volcamos los datos del Album_de_fotos_3 a Album_de_fotos_2.

Album3_a_Album2 ld hl,(End_Snapshot_3)      ; Final, (origen).
    ld bc,Album_de_fotos_3      ; Origen.
    ld de,Album_de_fotos_2      ; Destino.

    call Limpia_album

;   Actualizamos (End_Snapshot_2):

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

;   Hemos pasado los datos de Album_de_fotos_3 a Album_de_fotos_2. 
;   Actualiza (End_Snapshot_3) y (Semaforo).
 
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
    push de                     ; Guardo DESTINO.
    push bc                     ; Guardo ORIGEN.
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
;
;   13/10/23

Actualiza_semaforo

; Está activo el bit "Album_de_fotos" ???

    ld a,(Semaforo)
    bit 0,a
    jr nz,1F
    set 0,a                     ; Album_de_fotos COMPLETO.
    jr 2F
1 bit 1,a
    jr nz,3F
    set 1,a                      ; Album_de_fotos_1 COMPLETO.
    jr 2F
3 bit 2,a
    ret nz
    set 2,a                      ; Album_de_fotos_2 COMPLETO.
2 ld (Semaforo),a 
    ret 

; --------------------------------------------------------------------------------------------
;
;   20/10/23

Actualiza_punteros_de_albumes

   ld hl,(Puntero_indice_album_de_fotos)
   dec hl
   dec hl
   ld (Puntero_indice_album_de_fotos),hl
    
   ld hl,(Puntero_indice_End_Snapshot)
   dec hl
   dec hl
   ld (Puntero_indice_End_Snapshot),hl
   call Extrae_address
   ld (Puntero_de_End_Snapshot),hl             

   call Extrae_address
   ld (Stack_snapshot),hl
   
   ret

