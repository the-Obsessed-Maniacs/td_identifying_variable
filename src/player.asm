/**
 *	Tiny Dancer: "identifying variable"
 *	===================================
 *	A dual-SID contribution by St0fF / the0bsessedManiacs & Neoplasia
 *	after an idea by Prince / the0bsessedManiacs
 *
 *	Made especcially for the "Yogi's & Flex' Melodic 2SID Compo 2025"
 *	as a Christmas Present to the C64 scene after like 17.5 years of
 *	abstinence from competitions.
 *
 *	Maybe this becomes the base of a new 4k demo multiSID-Tracker? Who knows?
 */
 		.var tickCount = 5

		.label leis = $58
		.label cnt = $59
		.label dpos = $5a
		.label addr = $5b
		.var smp = $b08b
		.var loop = $40

.segment MusicPlayer [start=$1000]
init:				jmp initialize_both_chips
.memblock "tinyDancer_Speichertanz_2SID"
play:				dec cnt
					bpl fertsch
tick:				lda #tickCount
					sta cnt
					lda leis
					bne stumm
					ldx #$41
					ldy dpos
					lda (addr),y
					and #$f0
					asl
					beq silhi
					bcs h2
					sta $d401
					stx $d404
					bne silhi
		h2:			sta $d421
					stx $d424
		silhi:		lda (addr),y
					and #$0f
					lsr
					beq silba
					bcs l2
					sta $d401+7
					stx $d404+7
					bne silba
		l2:			sta $d421+7
					stx $d424+7
		silba:
.memblock "tinyDancer_Beatdiktatur_2SID"
		drums:		tya
					and #3
					tax
					lda srt,x
					sta $d406+14
					sta $d426+14
					lda frt,x
					sta $d401+14
					sta $d421+14
					lda #$81
					sta $d404+14
					sta $d424+14
					lda #$40
					sta leis
					iny
					cpy #loop
					bcc !+
					ldy #0
				!:	sty dpos
					rts
.memblock "tinyDancer_Regelpausen"
	stumm:			sta $d404
					sta $d404+7
					sta $d424
					sta $d424+7
					asl
					sta $d404+14
					sta $d424+14
					asl
					sta leis
	fertsch:		rts
.memblock "tinyDancer_BrauchichzumSpielen"
initialize_both_chips:
					ldy #$20
				!:	lda #$8
					sta $d403,y		//Pulse: 	50%
					sta $d403+7,y
					lsr
					sta $d405,y		//ATTACK:	0
					sta $d405+7,y	//DECAY:	4
					lda #$85
					sta $d406,y		//SUSTAIN:	8
					lda #$8a
					sta $d406+7,y	//RELEASE:	7
					lda #15			// volle Pulle
					sta $d418,y
					tya
					beq !+
					ldy #0
					beq !-
				!:	sta leis
					sta dpos
					sta cnt
			rst:	lda #<smp	//noten?
					sta addr
					lda #>smp
					sta addr+1
					rts
.memblock "tinyDancer_BumsdatendiewirleiderdochfuerdenSIDbrauchn"
srt:		.byte $fa,$66,$89,$66
frt:		.byte $02,$f8,$24,$f8
