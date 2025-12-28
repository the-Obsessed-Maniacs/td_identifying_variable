
#undef DOUBLE
#undef PSID

#if DOUBLE
	#import "player.asm"
#else
	#import "player_single.asm"
#endif
#if PSID
	#import "generate_sid.asm"
#endif
.encoding "ascii"

.const title 	=	"TinyDancer: »identify variable«"
.const author	=	"theObsessedManiacs ^ NPL"
.const reldate	=	"2025-12-24"

#if DOUBLE
	.segment PRG_file [outPrg="TinyDancer_identify_variable_2SID.prg"]
#else
	.segment PRG_file [outPrg="TinyDancer_identify_variable.prg"]
#endif
{
	BasicUpstart2( run )
	run:				jsr player_start
	frame:				bit $d011
						bmi frame
					!:	bit $d011
						bpl !-
						dec $d020
						jsr player_start+3
						inc $d020
						jmp frame
						*=$1000
	player_start:
	dumpPlayerAtStar()
}
#if PSID
	.segment MusicPlayer [start=$1000]
		dumpPlayerAtStar()
	#if DOUBLE
		createPSIDsingle( title, author, reldate, $d420, 0, init, init, play, "MusicPlayer", SID_unknown, PAL )
	#else
		createPSIDsingle( title, author, reldate, 0, 0, init, init, play, "MusicPlayer", SID_unknown, PAL )
	#endif
#endif