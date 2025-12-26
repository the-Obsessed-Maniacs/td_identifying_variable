
.segmentdef Header

#import "player.asm"
#import "generate_sid.asm"
.encoding "ascii"

.const title 	=	"TinyDancer: »identify variable«"
.const author	=	"theObsessedManiacs ^ NPL"
.const reldate	=	"2025-12-24"

.segment PRG_file [outPrg="TinyDancer_identify_variable_2SID.prg"]
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
	player_start:
	dumpPlayerAtStar()
}

.segment MusicPlayer [start=$1000]
dumpPlayerAtStar()
createPSIDsingle( title, author, reldate, $d420, 0, init, init, play, "MusicPlayer", SID_unknown, PAL )
