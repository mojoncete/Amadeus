; Pinta indicadores de FILAS. ------------------------------------------------------

Pinta_FILAS ld hl,$4010
;	ld b,9
;2 push hl
;	push bc
	ld b,$bf
1 ld (hl),%10000000
	call NextScan
	djnz 1B
;	pop bc 
;	pop hl
;	inc l 
;	djnz 2B

	ld b,3
    ld hl,$4700
3 call Bucle_1
    djnz 3B
    ret

Bucle_1 push bc 
        push hl
        pop de
        inc de
        ld bc,255
        ld (hl),255
        ldir
        inc hl
        ld a,7
        add a,h
        ld h,a
        pop bc
        ret