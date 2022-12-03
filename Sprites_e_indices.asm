; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	3/12/22
;
;	Sprites e índices.

	org $8000

; Badsat_der. 2x2.

Indice_Badsat_der defw Badsat_derecha
	defw Badsat_der_f8
	defw Badsat_der_f9
	defw Badsat_der_fa
	defw Badsat_der_fb
	defw Badsat_der_fc
	defw Badsat_der_fd
	defw Badsat_der_fe

Badsat_derecha DEFB	$00,$08,$02,$14,$02,$2A,$02,$55
	DEFB	$02,$AA,$02,$54,$7F,$E8,$03,$60
	DEFB	$0A,$E0,$17,$F8,$2B,$E8,$54,$40
	DEFB	$AA,$60,$54,$00,$28,$00,$10,$00 ; Sprite principal, (sin desplazar).

Badsat_der_f8 DEFB $00,$04,$00,$01,$0A,$00,$01,$15
	DEFB	$00,$01,$2A,$80,$01,$55,$00,$01
	DEFB	$2A,$00,$3F,$F4,$00,$01,$B0,$00
	DEFB	$05,$70,$00,$0B,$FC,$00,$15,$F4
	DEFB	$00,$2A,$20,$00,$55,$30,$00,$2A
	DEFB	$00,$00,$14,$00,$00,$08,$00,$00 ; $F8 (1er DESPLZ a derecha).

Badsat_der_f9 DEFB $00,$02,$00,$00,$85,$00,$00,$8A
	DEFB	$80,$00,$95,$40,$00,$AA,$80,$00
	DEFB	$95,$00,$1F,$FA,$00,$00,$D8,$00
	DEFB	$02,$B8,$00,$05,$FE,$00,$0A,$FA
	DEFB	$00,$15,$10,$00,$2A,$98,$00,$15
	DEFB	$00,$00,$0A,$00,$00,$04,$00,$00 ; $F9 (2º DESPLZ a derecha).

Badsat_der_fa DEFB $00,$01,$00,$00,$42,$80,$00,$45
	DEFB	$40,$00,$4A,$A0,$00,$55,$40,$00
	DEFB	$4A,$80,$0F,$FD,$00,$00,$6C,$00
	DEFB	$01,$5C,$00,$02,$FF,$00,$05,$7D
	DEFB	$00,$0A,$88,$00,$15,$4C,$00,$0A
	DEFB	$80,$00,$05,$00,$00,$02,$00,$00 ; $Fa (3er DESPLZ a derecha).

Badsat_der_fb DEFB $00,$00,$80,$00,$21,$40,$00,$22
	DEFB	$A0,$00,$25,$50,$00,$2A,$A0,$00
	DEFB	$25,$40,$07,$FE,$80,$00,$36,$00
	DEFB	$00,$AE,$00,$01,$7F,$80,$02,$BE
	DEFB	$80,$05,$44,$00,$0A,$A6,$00,$05
	DEFB	$40,$00,$02,$80,$00,$01,$00,$00 ; $Fb (4º DESPLZ a derecha).

Badsat_der_fc DEFB $00,$00,$40,$00,$10,$A0,$00,$11
	DEFB	$50,$00,$12,$A8,$00,$15,$50,$00
	DEFB	$12,$A0,$03,$FF,$40,$00,$1B,$00
	DEFB	$00,$57,$00,$00,$BF,$C0,$01,$5F
	DEFB	$40,$02,$A2,$00,$05,$53,$00,$02
	DEFB	$A0,$00,$01,$40,$00,$00,$80,$00 ; $Fc (5º DESPLZ a derecha).

Badsat_der_fd DEFB $00,$00,$20,$00,$08,$50,$00,$08
	DEFB	$A8,$00,$09,$54,$00,$0A,$A8,$00
	DEFB	$09,$50,$01,$FF,$A0,$00,$0D,$80
	DEFB	$00,$2B,$80,$00,$5F,$F8,$00,$AF
	DEFB	$80,$01,$51,$00,$02,$A9,$00,$01
	DEFB	$51,$00,$00,$A0,$00,$00,$40,$00 ; $Fd (6º DESPLZ a derecha).

Badsat_der_fe DEFB $00,$00,$10,$00,$04,$28,$00,$04
	DEFB	$54,$00,$04,$AA,$00,$05,$54,$00
	DEFB	$04,$A8,$00,$FF,$D0,$00,$06,$C0
	DEFB	$00,$15,$C0,$00,$2F,$FC,$00,$57
	DEFB	$C0,$00,$A8,$80,$01,$54,$80,$00
	DEFB	$A8,$80,$00,$50,$00,$00,$20,$00 ; $Fe (7º DESPLZ a derecha).

; Amadeus. 2x2.

Indice_Amadeus defw Amadeus
	defw 0	
	defw Amadeus_F9							; [$F9] right - [$FA] left 
	defw 0	
	defw Amadeus_Fb     					; [$FB] right - [$FC] left                     
	defw 0	
	defw Amadeus_Fd							; [$FD] right - [$FE] left 
	defw 0	 								; (Fín de índice).

Amadeus DEFB $01,$80,$23,$C4,$26,$64,$24,$24
	DEFB	$2C,$34,$6D,$B6,$6F,$F6,$67,$E6
	DEFB	$E7,$E7,$F3,$CF,$F7,$EF,$FF,$FF
	DEFB	$FB,$DF,$FB,$DF,$8B,$D1,$71,$8E ; Sprite principal, (sin desplazar).

Amadeus_F9 DEFB	$00,$60,$00,$08,$F1,$00,$09,$99
	DEFB	$00,$09,$09,$00,$0B,$0D,$00,$1B
	DEFB	$6D,$80,$1B,$FD,$80,$19,$F9,$80
	DEFB	$39,$F9,$C0,$3C,$F3,$C0,$3D,$FB
	DEFB	$C0,$3F,$FF,$C0,$3E,$F7,$C0,$3E
	DEFB	$F7,$C0,$22,$F4,$40,$1C,$63,$80 ; $F9 (2º DESPLZ a derecha).

Amadeus_Fb DEFB	$00,$18,$00,$02,$3C,$40,$02,$66
	DEFB	$40,$02,$42,$40,$02,$C3,$40,$06
	DEFB	$DB,$60,$06,$FF,$60,$06,$7E,$60
	DEFB	$0E,$7E,$70,$0F,$3C,$F0,$0F,$7E
	DEFB	$F0,$0F,$FF,$F0,$0F,$BD,$F0,$0F
	DEFB	$BD,$F0,$08,$BD,$10,$07,$18,$E0 ; $Fb (4º DESPLZ a derecha).

Amadeus_Fd DEFB	$00,$06,$00,$00,$8F,$10,$00,$99
	DEFB	$90,$00,$90,$90,$00,$B0,$D0,$01
	DEFB	$B6,$D8,$01,$BF,$D8,$01,$9F,$98
	DEFB	$03,$9F,$9C,$03,$CF,$3C,$03,$DF
	DEFB	$BC,$03,$FF,$FC,$03,$EF,$7C,$03
	DEFB	$EF,$7C,$02,$2F,$44,$01,$C6,$38 ; $Fd (6º DESPLZ a derecha).