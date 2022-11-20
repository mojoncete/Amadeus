; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	26/9/22
;
;	Sprites e índices.

	org $8000

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Sprites: 
;
;	COLORES: 0 ..... NEGRO
;    		 1 ..... AZUL
; 			 2 ..... ROJO
;			 3 ..... MAGENTA
; 			 4 ..... VERDE
; 			 5 ..... CIAN
;			 6 ..... AMARILLO
; 			 7 ..... BLANCO

; Ladrillito 2x1.
Ladrillito DEFB	$FF,$81,$89,$91,$A1,$81,$81,$FF ; ..... ..... ..... ..... ; Datos.
	DEFB $FF,$81,$85,$89,$91,$A1,$81,$FF

	DEFB	0 		; .....	.....	.....	.....	.....	.....	..... ; Atributos.

; Globo. 3x2.
Globo DEFB	$03,$C0,$0F,$F0,$1F,$F8,$3F,$FC ; ..... ..... ..... ..... ... ; Datos.
	DEFB	$33,$CC,$73,$CE,$73,$CE,$7F,$FE
	DEFB	$7F,$FE,$77,$EE,$33,$CC,$38,$1C
	DEFB	$1F,$F8,$0F,$F0,$03,$C0,$01,$00
	DEFB	$01,$00,$01,$80,$00,$C0,$00,$40
	DEFB	$00,$70,$00,$18,$00,$0E,$00,$03

	DEFB	0 		; .....	.....	.....	.....	.....	.....	..... ; Atributos.

; Submarino. 2x3.
Submarino DEFB $03,$80,$00,$07,$C0,$00,$07,$C0 ; ..... ..... ..... .....  ; Datos.
	DEFB	$00,$07,$C0,$00,$1F,$FE,$00,$3F
	DEFB	$FF,$00,$7D,$FF,$CB,$F8,$FF,$E8
	DEFB	$FD,$FF,$FB,$FF,$FF,$E8,$7F,$FF
	DEFB	$CB,$3F,$FF,$00,$1F,$FE,$00,$00
	DEFB	$00,$00,$00,$00,$00,$00,$00,$00

	DEFB	0		; .....	.....	.....	.....	.....	.....	..... ; Atributos.

; Calamar. 3x2.

Calamar	DEFB $07,$E0,$1F,$F8,$3D,$FC,$73,$FE ; ..... ..... ..... ..... .. ; Datos.
	DEFB	$73,$FE,$FF,$CE,$FF,$CF,$81,$FF
	DEFB	$A0,$7F,$A1,$3F,$F9,$0F,$27,$23
	DEFB	$23,$FE,$22,$20,$32,$30,$13,$10
	DEFB	$11,$20,$11,$30,$13,$10,$1A,$18
	DEFB	$09,$08,$51,$AA,$30,$CC,$00,$00

	DEFB	0		; .....	.....	.....	.....	.....	.....	..... ; Atributos.

; Paraguas. 3x3.
Paraguas DEFB $00,$10,$00,$00,$7C,$00,$01,$DB ; ..... ..... ..... ..... . ; Datos.
	DEFB	$00,$07,$DC,$C0,$0F,$9E,$20,$1F
	DEFB	$1F,$30,$1F,$1F,$10,$3E,$1F,$98
	DEFB	$3E,$1F,$88,$7E,$1F,$8C,$7C,$1F
	DEFB	$84,$7C,$1F,$84,$7C,$1F,$84,$7C
	DEFB	$1F,$84,$7D,$FF,$B4,$4E,$11,$CC
	DEFB	$44,$10,$84,$00,$10,$00,$00,$10
	DEFB	$00,$00,$10,$00,$00,$16,$00,$00
	DEFB	$12,$00,$00,$12,$00,$00,$1E,$00

	DEFB	0		; .....	.....	.....	.....	.....	.....	..... ; Atributos.

; Coracao. 2x2.

Indice_Coracao defw Coracao
	defw Coracao_F8
	defw Coracao_F9
	defw Coracao_Fa
	defw Coracao_Fb
	defw Coracao_Fc
	defw Coracao_Fd
	defw Coracao_Fe

Coracao	DEFB $00,$00,$1E,$78,$3F,$FC,$73,$FE 
	DEFB	$67,$FE,$6F,$FE,$6F,$FE,$7F,$FE
	DEFB	$7F,$FE,$7F,$FE,$3F,$FC,$1F,$F8
	DEFB	$0F,$F0,$07,$E0,$01,$80,$00,$00 ; Sprite principal, (sin desplazar).

Coracao_F8 DEFB	$00,$00,$00,$0F,$3C,$00,$1F,$FE
	DEFB	$00,$39,$FF,$00,$33,$FF,$00,$37
	DEFB	$FF,$00,$37,$FF,$00,$3F,$FF,$00
	DEFB	$3F,$FF,$00,$3F,$FF,$00,$1F,$FE
	DEFB	$00,$0F,$FC,$00,$07,$F8,$00,$03
	DEFB	$F0,$00,$00,$C0,$00,$00,$00,$00 ; $F8 (1er DESPLZ a derecha).

Coracao_F9	DEFB $00,$00,$00,$07,$9E,$00,$0F,$FF
	DEFB	$00,$1C,$FF,$80,$19,$FF,$80,$1B
	DEFB	$FF,$80,$1B,$FF,$80,$1F,$FF,$80
	DEFB	$1F,$FF,$80,$1F,$FF,$80,$0F,$FF
	DEFB	$00,$07,$FE,$00,$03,$FC,$00,$01
	DEFB	$F8,$00,$00,$60,$00,$00,$00,$00 ; $F9 (2º DESPLZ a derecha).

Coracao_Fa	DEFB $00,$00,$00,$03,$CF,$00,$07,$FF
	DEFB	$80,$0E,$7F,$C0,$0C,$FF,$C0,$0D
	DEFB	$FF,$C0,$0D,$FF,$C0,$0F,$FF,$C0
	DEFB	$0F,$FF,$C0,$0F,$FF,$C0,$07,$FF
	DEFB	$80,$03,$FF,$00,$01,$FE,$00,$00
	DEFB	$FC,$00,$00,$30,$00,$00,$00,$00 ; $Fa (3er DESPLZ a derecha).

Coracao_Fb 	DEFB $00,$00,$00,$01,$E7,$80,$03,$FF
	DEFB	$C0,$07,$3F,$E0,$06,$7F,$E0,$06
	DEFB	$FF,$E0,$06,$FF,$E0,$07,$FF,$E0
	DEFB	$07,$FF,$E0,$07,$FF,$E0,$03,$FF
	DEFB	$C0,$01,$FF,$80,$00,$FF,$00,$00
	DEFB	$7E,$00,$00,$18,$00,$00,$00,$00 ; $Fb (4º DESPLZ a derecha).

Coracao_Fc DEFB $00,$00,$00,$00,$F3,$C0,$01,$FF
	DEFB	$E0,$03,$9F,$F0,$03,$3F,$F0,$03
	DEFB	$7F,$F0,$03,$7F,$F0,$03,$FF,$F0
	DEFB	$03,$FF,$F0,$03,$FF,$F0,$01,$FF
	DEFB	$E0,$00,$FF,$C0,$00,$7F,$80,$00
	DEFB	$3F,$00,$00,$0C,$00,$00,$00,$00 ; $Fc (5º DESPLZ a derecha).

Coracao_Fd	DEFB $00,$00,$00,$00,$79,$E0,$00,$FF
	DEFB	$F0,$01,$CF,$F8,$01,$9F,$F8,$01
	DEFB	$BF,$F8,$01,$BF,$F8,$01,$FF,$F8
	DEFB	$01,$FF,$F8,$01,$FF,$F8,$00,$FF
	DEFB	$F0,$00,$7F,$E0,$00,$3F,$C0,$00
	DEFB	$1F,$80,$00,$06,$00,$00,$00,$00 ; $Fd (6º DESPLZ a derecha).

Coracao_Fe DEFB $00,$00,$00,$00,$3C,$F0,$00,$7F
	DEFB	$F8,$00,$E7,$FC,$00,$CF,$FC,$00
	DEFB	$DF,$FC,$00,$DF,$FC,$00,$FF,$FC
	DEFB	$00,$FF,$FC,$00,$FF,$FC,$00,$7F
	DEFB	$F8,$00,$3F,$F0,$00,$1F,$E0,$00
	DEFB	$0F,$C0,$00,$03,$00,$00,$00,$00 ; $Fe (7º DESPLZ a derecha).

	DEFB	0		; .....	.....	.....	.....	.....	.....	..... ; Atributos.		

; Amadeus. 3x3.

Indice_Amadeus defw Amadeus
	defw 0	
	defw Amadeus_F9							; [$F9] right - [$FA] left 
	defw 0	
	defw Amadeus_Fb     					; [$FB] right - [$FC] left                     
	defw 0	
	defw Amadeus_Fd							; [$FD] right - [$FE] left 
	defw 0	 								; (Fín de índice).

Amadeus DEFB $00,$18,$00,$00,$24,$00,$00,$42
	DEFB	$00,$00,$7E,$00,$00,$CF,$00,$04
	DEFB	$BF,$20,$0D,$7F,$B0,$1D,$C3,$B8
	DEFB	$19,$81,$98,$3B,$81,$DC,$3B,$81
	DEFB	$DC,$7A,$C3,$DE,$5A,$FF,$DE,$DB
	DEFB	$7F,$DF,$DD,$3F,$BF,$CD,$BF,$BF
	DEFB	$65,$9F,$BE,$66,$CF,$7E,$3E,$CF
	DEFB	$7C,$3C,$FF,$3C,$19,$7E,$98,$01
	DEFB	$BD,$80,$03,$DB,$C0,$07,$00,$E0 ; Sprite principal, (sin desplazar).

Amadeus_F9 DEFB	$00,$06,$00,$00,$00,$09,$00,$00
	DEFB	$00,$10,$80,$00,$00,$1F,$80,$00
	DEFB	$00,$33,$C0,$00,$01,$2F,$C8,$00
	DEFB	$03,$5F,$EC,$00,$07,$70,$EE,$00
	DEFB	$06,$60,$66,$00,$0E,$E0,$77,$00
	DEFB	$0E,$E0,$77,$00,$1E,$B0,$F7,$80
	DEFB	$16,$BF,$F7,$80,$36,$DF,$F7,$C0
	DEFB	$37,$4F,$EF,$C0,$33,$6F,$EF,$C0
	DEFB	$19,$67,$EF,$80,$19,$B3,$DF,$80
	DEFB	$0F,$B3,$DF,$00,$0F,$3F,$CF,$00
	DEFB	$06,$5F,$A6,$00,$00,$6F,$60,$00
	DEFB	$00,$F6,$F0,$00,$01,$C0,$38,$00 ; $F9 (2º DESPLZ a derecha).

Amadeus_Fb DEFB	$00,$01,$80,$00,$00,$02,$40,$00
	DEFB	$00,$04,$20,$00,$00,$07,$E0,$00
	DEFB	$00,$0C,$F0,$00,$00,$4B,$F2,$00
	DEFB	$00,$D7,$FB,$00,$01,$DC,$3B,$80
	DEFB	$01,$98,$19,$80,$03,$B8,$1D,$C0
	DEFB	$03,$B8,$1D,$C0,$07,$AC,$3D,$E0
	DEFB	$05,$AF,$FD,$E0,$0D,$B7,$FD,$F0
	DEFB	$0D,$D3,$FB,$F0,$0C,$DB,$FB,$F0
	DEFB	$06,$59,$FB,$E0,$06,$6C,$F7,$E0
	DEFB	$03,$EC,$F7,$C0,$03,$CF,$F3,$C0
	DEFB	$01,$97,$E9,$80,$00,$1B,$D8,$00
	DEFB	$00,$3D,$BC,$00,$00,$70,$0E,$00 ; $Fb (4º DESPLZ a derecha).

Amadeus_Fd	DEFB $00,$00,$60,$00,$00,$00,$90,$00
	DEFB	$00,$01,$08,$00,$00,$01,$F8,$00
	DEFB	$00,$03,$3C,$00,$00,$12,$FC,$80
	DEFB	$00,$35,$FE,$C0,$00,$77,$0E,$E0
	DEFB	$00,$66,$06,$60,$00,$EE,$07,$70
	DEFB	$00,$EE,$07,$70,$01,$EB,$0F,$78
	DEFB	$01,$6B,$FF,$78,$03,$6D,$FF,$7C
	DEFB	$03,$74,$FE,$FC,$03,$36,$FE,$FC
	DEFB	$01,$96,$7E,$F8,$01,$9B,$3D,$F8
	DEFB	$00,$FB,$3D,$F0,$00,$F3,$FC,$F0
	DEFB	$00,$65,$FA,$60,$00,$06,$F6,$00
	DEFB	$00,$0F,$6F,$00,$00,$1C,$03,$80 ; $Fa (6º DESPLZ a derecha).

	