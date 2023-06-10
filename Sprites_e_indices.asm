; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	17/02/23
;
;	Sprites e índices.

	org $8000

; Disparo.

Indice_disparo defw Disparo_0
	defw Disparo_f9
	defw Disparo_fb
	defw Disparo_fd

; Disparo (CTRL_DESPLZ)="0".
Disparo_0 DEFB $01,$80,$01,$80,$01,$80,$01,$80
; Disparo (CTRL_DESPLZ)="f9"
Disparo_f9 DEFB $00,$60,$00,$60,$00,$60,$00,$60
; Disparo (CTRL_DESPLZ)="fb" 
Disparo_fb DEFB $18,$00,$18,$00,$18,$00,$18,$00
; Disparo (CTRL_DESPLZ)="fd" 
Disparo_fd DEFB $06,$00,$06,$00,$06,$00,$06,$00

; ----------------------------------------------------------------------------------------

; Badsat_izq. 2x2.

Indice_Badsat_izq defw Badsat_izquierda
	defw Badsat_izq_fe
	defw Badsat_izq_fd
	defw Badsat_izq_fc
	defw Badsat_izq_fb
	defw Badsat_izq_fa
	defw Badsat_izq_f9
	defw Badsat_izq_f8

Badsat_izquierda DEFB $00,$08,$02,$14,$02,$2A,$02,$55
	DEFB	$02,$AA,$02,$54,$7F,$E8,$03,$60
	DEFB	$0A,$E0,$17,$F8,$2B,$E8,$54,$40
	DEFB	$AA,$60,$54,$00,$28,$00,$10,$00 ; Sprite principal a izquierda, (sin desplazar).

Badsat_izq_f8 DEFB $00,$04,$00,$01,$0A,$00,$01,$15
	DEFB	$00,$01,$2A,$80,$01,$55,$00,$01
	DEFB	$2A,$00,$3F,$F4,$00,$01,$B0,$00
	DEFB	$05,$70,$00,$0B,$FC,$00,$15,$F4
	DEFB	$00,$2A,$20,$00,$55,$30,$00,$2A
	DEFB	$00,$00,$14,$00,$00,$08,$00,$00 ; $F8 (7º DESPLZ a izquierda).

Badsat_izq_f9 DEFB $00,$02,$00,$00,$85,$00,$00,$8A
	DEFB	$80,$00,$95,$40,$00,$AA,$80,$00
	DEFB	$95,$00,$1F,$FA,$00,$00,$D8,$00
	DEFB	$02,$B8,$00,$05,$FE,$00,$0A,$FA
	DEFB	$00,$15,$10,$00,$2A,$98,$00,$15
	DEFB	$00,$00,$0A,$00,$00,$04,$00,$00 ; $F9 (6º DESPLZ a izquierda).

Badsat_izq_fa DEFB $00,$01,$00,$00,$42,$80,$00,$45
	DEFB	$40,$00,$4A,$A0,$00,$55,$40,$00
	DEFB	$4A,$80,$0F,$FD,$00,$00,$6C,$00
	DEFB	$01,$5C,$00,$02,$FF,$00,$05,$7D
	DEFB	$00,$0A,$88,$00,$15,$4C,$00,$0A
	DEFB	$80,$00,$05,$00,$00,$02,$00,$00 ; $Fa (5º DESPLZ a izquierda).

Badsat_izq_fb DEFB $00,$00,$80,$00,$21,$40,$00,$22
	DEFB	$A0,$00,$25,$50,$00,$2A,$A0,$00
	DEFB	$25,$40,$07,$FE,$80,$00,$36,$00
	DEFB	$00,$AE,$00,$01,$7F,$80,$02,$BE
	DEFB	$80,$05,$44,$00,$0A,$A6,$00,$05
	DEFB	$40,$00,$02,$80,$00,$01,$00,$00 ; $Fb (4º DESPLZ a izquierda).

Badsat_izq_fc DEFB $00,$00,$40,$00,$10,$A0,$00,$11
	DEFB	$50,$00,$12,$A8,$00,$15,$50,$00
	DEFB	$12,$A0,$03,$FF,$40,$00,$1B,$00
	DEFB	$00,$57,$00,$00,$BF,$C0,$01,$5F
	DEFB	$40,$02,$A2,$00,$05,$53,$00,$02
	DEFB	$A0,$00,$01,$40,$00,$00,$80,$00 ; $Fc (3er DESPLZ a izquierda).

Badsat_izq_fd DEFB $00,$00,$20,$00,$08,$50,$00,$08
	DEFB	$A8,$00,$09,$54,$00,$0A,$A8,$00
	DEFB	$09,$50,$01,$FF,$A0,$00,$0D,$80
	DEFB	$00,$2B,$80,$00,$5F,$F8,$00,$AF
	DEFB	$80,$01,$51,$00,$02,$A9,$00,$01
	DEFB	$51,$00,$00,$A0,$00,$00,$40,$00 ; $Fd (2º DESPLZ a izquierda).

Badsat_izq_fe DEFB $00,$00,$10,$00,$04,$28,$00,$04
	DEFB	$54,$00,$04,$AA,$00,$05,$54,$00
	DEFB	$04,$A8,$00,$FF,$D0,$00,$06,$C0
	DEFB	$00,$15,$C0,$00,$2F,$FC,$00,$57
	DEFB	$C0,$00,$A8,$80,$01,$54,$80,$00
	DEFB	$A8,$80,$00,$50,$00,$00,$20,$00 ; $Fe (1er DESPLZ a izquierda).


Indice_Badsat_der defw Badsat_derecha
	defw Badsat_der_f8
	defw Badsat_der_f9
	defw Badsat_der_fa
	defw Badsat_der_fb
	defw Badsat_der_fc
	defw Badsat_der_fd
	defw Badsat_der_fe

Badsat_derecha DEFB	$10,$00,$28,$40,$54,$40,$AA,$40
	DEFB	$55,$40,$2A,$40,$17,$FE,$06,$C0
	DEFB	$07,$50,$1F,$E8,$17,$D4,$02,$2A
	DEFB	$06,$55,$00,$2A,$00,$14,$00,$08 ; Sprite principal a derecha, (sin desplazar).

Badsat_der_f8 DEFB $08,$00,$00,$14,$20,$00,$2A,$20
	DEFB	$00,$55,$20,$00,$2A,$A0,$00,$15
	DEFB	$20,$00,$0B,$FF,$00,$03,$60,$00
	DEFB	$03,$A8,$00,$0F,$F4,$00,$0B,$EA
	DEFB	$00,$01,$15,$00,$03,$2A,$80,$00
	DEFB	$15,$00,$00,$0A,$00,$00,$04,$00 ; $F8 (1er DESPLZ a derecha).

Badsat_der_f9 DEFB $04,$00,$00,$0A,$10,$00,$15,$10
	DEFB	$00,$2A,$90,$00,$15,$50,$00,$0A
	DEFB	$90,$00,$05,$FF,$80,$01,$B0,$00
	DEFB	$01,$D4,$00,$07,$FA,$00,$05,$F5
	DEFB	$00,$00,$8A,$80,$01,$95,$40,$00
	DEFB	$0A,$80,$00,$05,$00,$00,$02,$00 ; $F9 (2º DESPLZ a derecha).

Badsat_der_fa DEFB $02,$00,$00,$05,$08,$00,$0A,$88
	DEFB	$00,$15,$48,$00,$0A,$A8,$00,$05
	DEFB	$48,$00,$02,$FF,$C0,$00,$D8,$00
	DEFB	$00,$EA,$00,$03,$FD,$00,$02,$FA
	DEFB	$80,$00,$45,$40,$00,$CA,$A0,$00
	DEFB	$05,$40,$00,$02,$80,$00,$01,$00 ; $Fa (3er DESPLZ a derecha).

Badsat_der_fb DEFB $01,$00,$00,$02,$84,$00,$05,$44
	DEFB	$00,$0A,$A4,$00,$05,$54,$00,$02
	DEFB	$A4,$00,$01,$7F,$E0,$00,$6C,$00
	DEFB	$00,$75,$00,$01,$FE,$80,$01,$7D
	DEFB	$40,$00,$22,$A0,$00,$65,$50,$00
	DEFB	$02,$A0,$00,$01,$40,$00,$00,$80 ; $Fb (4º DESPLZ a derecha).

Badsat_der_fc DEFB $00,$80,$00,$01,$42,$00,$02,$A2
	DEFB	$00,$05,$52,$00,$02,$AA,$00,$01
	DEFB	$52,$00,$00,$BF,$F0,$00,$36,$00
	DEFB	$00,$3A,$80,$00,$FF,$40,$00,$BE
	DEFB	$A0,$00,$11,$50,$00,$32,$A8,$00
	DEFB	$01,$50,$00,$00,$A0,$00,$00,$40 ; $Fc (5º DESPLZ a derecha).

Badsat_der_fd DEFB $00,$40,$00,$00,$A1,$00,$01,$51
	DEFB	$00,$02,$A9,$00,$01,$55,$00,$00
	DEFB	$A9,$00,$00,$5F,$F8,$00,$1B,$00
	DEFB	$00,$1D,$40,$01,$FF,$A0,$00,$1F
	DEFB	$50,$00,$08,$A8,$00,$09,$54,$00
	DEFB	$08,$A8,$00,$00,$50,$00,$00,$20 ; $Fd (6º DESPLZ a derecha).

Badsat_der_fe DEFB $00,$20,$00,$00,$50,$80,$00,$A8
	DEFB	$80,$01,$54,$80,$00,$AA,$80,$00
	DEFB	$54,$80,$00,$2F,$FC,$00,$0D,$80
	DEFB	$00,$0E,$A0,$00,$FF,$D0,$00,$0F
	DEFB	$A8,$00,$04,$54,$00,$04,$AA,$00
	DEFB	$04,$54,$00,$00,$28,$00,$00,$10 ; $Fe (7º DESPLZ a derecha).

; ----------------------------------------------------------------------------------------

; Amadeus. 2x2.

Indice_Amadeus_der defw Amadeus
	defw 0	
	defw Amadeus_F9							; [$F9] right - [$FA] left 
	defw 0	
	defw Amadeus_Fb     					; [$FB] right - [$FC] left                     
	defw 0	
	defw Amadeus_Fd							; [$FD] right - [$FE] left 
	defw 0	 								; (Fín de índice).

Indice_Amadeus_izq defw Amadeus
	defw 0	
	defw Amadeus_Fd							; [$F9] right - [$FA] left 
	defw 0	
	defw Amadeus_Fb     					; [$FB] right - [$FC] left                     
	defw 0	
	defw Amadeus_F9							; [$FD] right - [$FE] left 
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

; ----------------------------------------------------------------------------------------

Indice_Explosion_2x3 defw Explosion_2x3_1
	defw Explosion_2x3_2
	defw Explosion_2x3_3

Explosion_2x3_1 DEFB $00,$10,$00,$08,$10,$00,$04,$38
	DEFB	$40,$03,$7D,$80,$02,$E6,$80,$01
	DEFB	$B7,$00,$01,$7F,$00,$03,$DD,$80
	DEFB	$0F,$FF,$E0,$03,$3B,$80,$01,$9D
	DEFB	$00,$01,$F6,$00,$02,$FD,$80,$03
	DEFB	$00,$40,$04,$00,$00,$08,$00,$00

Explosion_2x3_2 DEFB $08,$00,$00,$05,$38,$10,$03,$BC
	DEFB	$20,$06,$00,$C0,$04,$06,$C0,$00
	DEFB	$37,$00,$00,$7F,$00,$03,$DD,$80
	DEFB	$03,$FE,$00,$03,$3A,$70,$01,$9C
	DEFB	$60,$01,$F6,$40,$04,$F8,$80,$06
	DEFB	$00,$00,$08,$00,$00,$00,$00,$00

Explosion_2x3_3 DEFB $03,$18,$10,$04,$00,$20,$08,$00
	DEFB	$40,$00,$00,$C0,$00,$06,$00,$00
	DEFB	$15,$00,$08,$1E,$00,$00,$14,$30
	DEFB	$08,$66,$00,$00,$38,$00,$01,$08
	DEFB	$00,$01,$80,$00,$00,$80,$00,$04
	DEFB	$03,$20,$06,$00,$10,$08,$00,$20

; ------------------------------------------

Indice_Explosion_2x2 defw Explosion_2x2_1
	defw Explosion_2x2_2
	defw Explosion_2x2_3

Explosion_2x2_1 DEFB $01,$00,$81,$00,$43,$84,$37,$D8
	DEFB	$2E,$68,$1B,$70,$17,$F0,$3D,$D8
	DEFB	$FF,$FE,$33,$B8,$19,$D0,$1F,$60
	DEFB	$2F,$D8,$30,$04,$40,$00,$80,$00


Explosion_2x2_2	DEFB $80,$00,$53,$81,$3B,$C2,$60,$0C
	DEFB	$40,$6C,$03,$70,$07,$F0,$3D,$D8
	DEFB	$3F,$E0,$33,$A7,$19,$C6,$1F,$64
	DEFB	$4F,$88,$60,$00,$80,$00,$00,$00

Explosion_2x2_3	DEFB $31,$81,$40,$02,$88,$04,$10,$0C
	DEFB	$20,$60,$01,$50,$81,$E0,$01,$43
	DEFB	$86,$60,$03,$80,$10,$80,$18,$00
	DEFB	$08,$00,$40,$32,$60,$01,$80,$02

