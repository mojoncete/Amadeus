;   índices de Rutinas de impresión.

Indice_entidades_completas defw Pinta_Amadeus_2x2
    defw Pinta_Amadeus_3x2

Indice_entidades_incompletas_izquierda defw Pinta_enemigo_2x2_izquierda
    defw Pinta_enemigo_3x2_izquierda_1columna
    defw Pinta_enemigo_3x2_izquierda_2columnas

Indice_entidades_incompletas_derecha defw Pinta_enemigo_2x2_derecha
    defw Pinta_enemigo_3x2_derecha_1columna
    defw Pinta_enemigo_3x2_derecha_2columnas


;   Conjunto de rutinas de impresión de Sprites.
;
;   28/2/24
;
;   Inputs: HL contiene la dirección donde se encuentra el 1er scanline. 
;           B contendrá: el nº de scanlines que vamos a imprimir en pantalla. (ENTIDAD DE 2X2).
;           IY contiene los .db que forman el sprite, (Puntero_objeto).
;       
;   Modifica: AF,HL,BC y DE.

Pinta_Amadeus_2x2 ; 1081 t/states

    exx
    ld (hl),1
    inc l
    exx                     

    push iy
    pop de

    ld (Stack),sp
	ld sp,hl
    ld b,16

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
	inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    ld sp,(Stack)

	ret
    
Pinta_Amadeus_3x2 

    exx
    ld (hl),2
    inc l
    exx                     

    push iy
    pop de

    ld (Stack),sp
    ld sp,hl
    ld b,16

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    pop hl
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e
    inc l
    ld a,(de)
    ld (hl),a
    inc e

    ld sp,(Stack)

    ret

; ---------------------------------------------------

Pinta_enemigo_2x2_izquierda ld (Stack),sp
	ld sp,iy

; >>>

    ld b,16
1 pop de
	ld a,d
	xor (hl)
	ld (hl),a
	inc h     
    ld a,h
    and 7
    jr nz,2F              
    ld a,l             
    add a,$20           
    ld l,a
    jr c,2F            
    ld a,h             
    sub 8              
    ld h,a
    jr 2F
2 ld a,h
    cp $58
    jr z,3F
    djnz 1B
3 ld sp,(Stack)
	ret

Pinta_enemigo_2x2_derecha ld (Stack),sp
	ld sp,iy

; >>>

    ld b,16
1 pop de
	ld a,e
	xor (hl)
	ld (hl),a
	inc h     
    ld a,h
    and 7
    jr nz,2F          
    ld a,l              
    add a,$20           
    ld l,a
    jr c,2F              
    ld a,h             
    sub 8               
    ld h,a
    jr 2F
2 ld a,h
    cp $58
    jr z,3F
    djnz 1B 
3 ld sp,(Stack)
	ret

; ---------------------------------------------------

Pinta_enemigo_3x2_izquierda_2columnas ld (Stack),sp
	ld sp,iy
    ld b,8
1 pop de
	ld a,d
	xor (hl)
	ld (hl),a
	inc hl     
	pop de
	ld a,e
	xor (hl)
	ld (hl),a
	dec hl	
 	inc h
    ld a,h
    and 7
    jr nz,2F             
    ld a,l              
    add a,$20           
    ld l,a
    jr c,2F              
    ld a,h             
    sub 8               
    ld h,a
2 ld a,h
    cp $58
    jr z,4F
    pop de
	ld a,e
	xor (hl)
	ld (hl),a
	inc hl
	ld a,d
	xor (hl)
	ld (hl),a
	dec hl
	inc h
    ld a,h
    and 7
    jr nz,3F             
    ld a,l              
    add a,$20           
    ld l,a
    jr c,3F              
    ld a,h             
    sub 8               
    ld h,a
3 ld a,h
    cp $58
    jr z,4F
    djnz 1B
4 ld sp,(Stack)
	ret

Pinta_enemigo_3x2_izquierda_1columna ld (Stack),sp
	ld sp,iy
    ld b,8
1 pop de
	pop de
	ld a,e
	xor (hl)
	ld (hl),a
 	inc h
    ld a,h
    and 7
    jr nz,2F             
    ld a,l              
    add a,$20           
    ld l,a
    jr c,2F              
    ld a,h             
    sub 8               
    ld h,a
2 ld a,h
    cp $58
    jr z,4F
    pop de
	ld a,d
	xor (hl)
	ld (hl),a
	inc h
    ld a,h
    and 7
    jr nz,3F             
    ld a,l              
    add a,$20           
    ld l,a
    jr c,3F              
    ld a,h             
    sub 8               
    ld h,a
3 ld a,h
    cp $58
    jr z,4F
    djnz 1B
4 ld sp,(Stack)
	ret

Pinta_enemigo_3x2_derecha_2columnas ld (Stack),sp
	ld sp,iy
    ld b,8
1 pop de
	ld a,e
	xor (hl)
	ld (hl),a
	inc hl     
	ld a,d
	xor (hl)
	ld (hl),a
	dec hl	
  	inc h
    ld a,h
    and 7
    jr nz,2F             
    ld a,l              
    add a,$20           
    ld l,a
    jr c,2F              
    ld a,h             
    sub 8               
    ld h,a
2 ld a,h
    cp $58
    jr z,4F
    pop de
	ld a,d
	xor (hl)
	ld (hl),a
	inc hl
    pop de
	ld a,e
	xor (hl)
	ld (hl),a
	dec hl
	inc h
    ld a,h
    and 7
    jr nz,3F             
    ld a,l              
    add a,$20           
    ld l,a
    jr c,3F              
    ld a,h             
    sub 8               
    ld h,a
3 ld a,h
    cp $58
    jr z,4F
    djnz 1B
4 ld sp,(Stack)
	ret

Pinta_enemigo_3x2_derecha_1columna ld (Stack),sp
	ld sp,iy
    ld b,8
1 pop de
	ld a,e
	xor (hl)
	ld (hl),a
 	inc h
    ld a,h
    and 7
    jr nz,2F             
    ld a,l              
    add a,$20           
    ld l,a
    jr c,2F              
    ld a,h             
    sub 8               
    ld h,a
2 ld a,h
    cp $58
    jr z,4F
    pop de
	ld a,d
	xor (hl)
	ld (hl),a
	inc h
    ld a,h
    and 7
    jr nz,3F             
    ld a,l              
    add a,$20           
    ld l,a
    jr c,3F              
    ld a,h             
    sub 8               
    ld h,a
3 ld a,h
    cp $58
    jr z,4F
    pop de
    djnz 1B
4 ld sp,(Stack)
	ret

; ---------------------------------------------------
;
;   27/02/23
;
;   Rutina idéntica a Pinta_Amadeus_2x2, sólo difiere de esta en el nº de scanlines_
;   _ que imprime. No utilizamos [Pinta_Amadeus_2x2] porque cuando el programa está_
;   _ imprimiendo elementos, no discrimina el tipo de Sprite que está pintando. 

Pinta_Disparo ld (Stack),sp
    ld sp,iy
    ld b,3
1 pop de
    ld a,e
    xor (hl)
    ld (hl),a
    inc hl
    ld a,d
    xor (hl)
    ld (hl),a
    dec hl

    inc h     
    ld a,h
    and 7
    jr nz,2F            
    ld a,l              
    add a,$20           
    ld l,a
    jr c,2F              
    ld a,h              
    sub 8              
    ld h,a
2 ld a,h
    cp $58
    jr z,3F

    djnz 1B
3 ld sp,(Stack)
    ret

