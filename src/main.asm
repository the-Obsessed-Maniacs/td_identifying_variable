
.segmentdef Header

#import "player.asm"
#import "generate_sid.asm"
.encoding "ascii"

.const title 	=	"TinyDancer: »identify variable«"
.const author	=	"St0fF / theObsessedManiacs ^ NPL"
.const reldate	=	"2025-12-24"

createPSIDsingle( title, author, reldate, $d420, 0, init, init, play, "MusicPlayer", SID_unknown, PAL )
