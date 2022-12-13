;   Conjunto de rutinas de impresión de Sprites.
;
;   12/12/22
;
;   Inputs: HL contiene (Posicion_actual) de la entidad.
;           B contendrá: el nº de scanlines que `podemos´ imprimir en pantalla. (ENTIDAD DE 2X2).
;                        LA MITAD del nº de scanlines que `podemos´imprimir en pantalla. (ENTIDAD DE 3X2).
;           El puntero de pila apuntará a la dirección de mem. que contenga la variable (Puntero_datas).
;       
;   Modifica: DE y HL. 

Pinta_Amadeus_2x2 ld (Stack),sp
	ld sp,Amadeus
1 pop de
	ld (hl),e
	inc hl
	ld (hl),d
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
    jr 2F
2 djnz 1B
	ld sp,(Stack)
	ret

Pinta_Amadeus_3x2 ld (Stack),sp
	ld sp,Amadeus_F9
1 pop de
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	pop de
	ld (hl),e
	dec hl
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
2 ld (hl),d
	pop de
	inc hl
	ld (hl),e
	inc hl
	ld (hl),d
	dec hl
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
3 djnz 1B
	ld sp,(Stack)
	ret

; ---------------------------------------------------

Pinta_enemigo_2x2_izquierda ld (Stack),sp
	ld sp,Badsat_derecha
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
2 djnz 1B
	ld sp,(Stack)
	ret

Pinta_enemigo_2x2_derecha ld (Stack),sp
	ld sp,Badsat_derecha
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
2 djnz 1B
	ld sp,(Stack)
	ret

; ---------------------------------------------------

Pinta_enemigo_3x2_izquierda_2columnas ld (Stack),sp
	ld sp,Badsat_der_f8
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
2 pop de
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
3 djnz 1B
	ld sp,(Stack)
	ret

Pinta_enemigo_3x2_izquierda_1columna ld (Stack),sp
	ld sp,Amadeus_F9
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
2 pop de
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
3 djnz 1B
	ld sp,(Stack)
	ret

Pinta_enemigo_3x2_derecha_2columnas ld (Stack),sp
	ld sp,Amadeus_F9
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
2 pop de
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
3 djnz 1B
	ld sp,(Stack)
	ret

Pinta_enemigo_3x2_derecha_1columna ld (Stack),sp
	ld sp,Amadeus_F9
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
2 pop de
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
3 pop de
    djnz 1B
	ld sp,(Stack)
	ret

; ---------------------------------------------------

Pinta_enemigo_2x2 ld (Stack),sp
	ld sp,Badsat_derecha
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
    jr 2F
2 djnz 1B
	ld sp,(Stack)
	ret

; ---------------------------------------------------

Pinta_enemigo_3x2 ld (Stack),sp
	ld sp,Badsat_der_f8
1 pop de
	ld a,e
	xor (hl)
	ld (hl),a
	inc hl
	ld a,d
	xor (hl)
	ld (hl),a
	inc hl
	pop de
	ld a,e
	xor (hl)
	ld (hl),a
	dec hl
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
2 ld a,d
	xor (hl)
	ld (hl),a
	pop de
	inc hl
	ld a,e
	xor (hl)
	ld (hl),a
	inc hl
	ld a,d
	xor (hl)
	ld (hl),a
	dec hl
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
3 djnz 1B
	ld sp,(Stack)
	ret