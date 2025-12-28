/**
 *	Prince's principle - or what you can find in Wikipedia.de:
 *
 *	Die Fähigkeit des Menschen, als Musik intendierte Schallereignisse von anderen akustischen
 *	Reizen unterscheiden zu können, gehört zu den komplexesten Leistungen des menschlichen Gehirns.
 *	So können Abfolgen unterschiedlicher Einzeltöne, die sich durch zeitliche Gestaltungsmittel,
 *	wie Rhythmus, Metrum und Tempo zu horizontalen Tonkonstellationen zusammenschließen, als
 *	Melodie wahrgenommen werden, während aus vokaler und instrumentaler Mehrstimmigkeit vertikale
 *	Zusammenklänge aus unterschiedlichen Tonhöhen erwachsen.
 *
 */
#importonce

 		.var tickCount = 5				// Music Speed - ~150BPM
		.var smp = $b08b				// Music Data Source
		.var loop = $80					// Length of data source to consume before wrap

		.label leis = $58				// 2nd ticking stage - switch between on/off
		.label cnt = $59				// 1st ticking stage - frame ticker
		.label dpos = $5a				// 3rd ticking stage - data position
		.label addr = $5b				// data_ptr

.macro dumpPlayerAtStar() {
.memblock "tinyDancer_InitEntryPoint"
@init:				jmp initializeSID
.memblock "tinyDancer_Speichertanz"
@play:				dec cnt				// tick base stage
					bpl fertig			// no level tick.

	tick:			lda #tickCount		// Re-init base stage
					sta cnt
					lda leis			// check 2nd stage
					bne stumm			// odd 2nd ticks: release gates
					ldx #$41			// prepare CTRL
					ldy dpos
					lda (addr),y		// read data
					and #$f0			// mask trebles
					asl
					beq silenthi		// 0 == no sound
					sta $d401			// write freq.
					stx $d404			// write wave + gate as prepared
	silenthi:		lda (addr),y		// same again for bass
					and #$0f			// ... just the other way around
					lsr
					beq silentbass
					sta $d401+7
					stx $d404+7
	silentbass:
.memblock "tinyDancer_Beatdiktatur"
		drums:		tya					// still dpos in Y
					and #3				// there are only 3 beat steps
					tax					// read beat data from tables
					lda srt,x			// Drums have different SR
					sta $d406+14
					lda frt,x			// and different base frequencies
					sta $d401+14
					lda #$81			// all noise
					sta $d404+14
					lda #$40			// indicator: next is odd 2nd stage
					sta leis
					iny					// advance data sequence
					cpy #loop
					bcc !+
					ldy #0
				!:	sty dpos
					rts
.memblock "tinyDancer_Regelpausen"
	stumm:			sta $d404			// odd 2nd stage counts:
					sta $d404+7			// -> stop voices!
					asl
					sta $d404+14		// -> stop drums
					asl
					sta leis			// -> next is even 2nd stage tick
	fertig:			rts
.memblock "tinyDancer_Initialisierung"
initializeSID:
				!:	lda #$8
					sta $d403		//Pulse: 	50%
					sta $d403+7
					lsr
					sta $d405		//HiNotes: 0485
					sta $d405+7		//LoNotes: 048a
					lda #$85
					sta $d406
					lda #$8a
					sta $d406+7
					lda #15			// volle Pulle
					sta $d418
					and #0
					sta leis
					sta dpos
					sta cnt
			rst:	lda #<smp	//noten?
					sta addr
					lda #>smp
					sta addr+1
					rts
.memblock "tinyDancer_PercussionData"
srt:		.byte $fa,$66,$89,$66
frt:		.byte $02,$f8,$24,$f8
}