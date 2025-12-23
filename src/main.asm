
.segmentdef Header

#import "generate_sid.asm"
#import "player.asm"

.segment PSID_file [outBin="tinydancer-identifying_variable.sid"]
PSID_header( $1000, $1000, $1003, $42, 0 )
.segmentout [segments="MusicPlayer"]