/*
 *	Trying to make KickAssembler output a valid .sid file.
 *	======================================================
 *		St0fF/NPL^tOM'25
 */
.enum { SID_unknown, SID_6581, SID_8580, SID_BOTH }
.enum { video_unknown, PAL, NTSC, video_both }
// This macro is not yet finished, but working for my files at hand.
// I actually do not understand the idea of requesting multiple different chips,
// so I only provide one SID chip selector.
.macro createPSIDsingle( title, author, reldate, sid2, sid3, load, init, play, segment, sidtype, video_std ) {
	// Replace bad title characters by underscores
	.const badC = @" :;,./\\|()[]{}<>«»\"'`!?+=*"
	.var lastU = false
	.var fn = ""
	.for ( var i=0; i < title.size(); i++ ) {
		.var j=0;
		.while ( j < badC.size() && badC.charAt( j ) != title.charAt( i ) ) .eval j++
		.if ( j < badC.size() ) {
			.if ( !lastU ) {
				.eval lastU = true
				.eval fn += "_"
			}
		} else {
			.eval fn += title.charAt( i )
			.eval lastU = false
		}
	}
	.if ( lastU ) .eval fn = fn.substring( 0, fn.size() - 1 )
	// Filename part derived from title.
	.if ( sid2 == 0 )		.eval fn += "_PSID.sid"
	else .if ( sid3 == 0 )	.eval fn += "_2SID.sid"
	else 					.eval fn += "_3SID.sid"
	// Filename finalized ( I hope ... ) tell KickAssembler to produce output!
	.segment PSID_file [outBin=fn]
	// Create PSid header
	.dword flipEndian4( $50534944 )			// 	PSID
	.word flipEndian2( sid2 > 0 ? sid3 > 0 ? 4 : 3 : 2 )// Version selector
	.word flipEndian2( $7c )				// 	dataOffset, version 2+
	.word flipEndian2( load ), flipEndian2( init ), flipEndian2( play )
	.word flipEndian2( 1 ),flipEndian2( 0 )	// 	Single Song.
	.dword 0								//	VBlank
	.encoding "ascii"
	makePSIDtx( title )
	makePSIDtx( author )
	makePSIDtx( reldate )
	// create Flags:	starting with "built-in player", v2/3/4, and adding timing info:
	.var flg = %10 | ( video_std << 2 )
	.eval flg = flg | ( sidtype << 4 )
	.if ( sid2 > 0 ) .eval flg = flg | ( sidtype << 6 )
	.if ( sid3 > 0 ) .eval flg = flg | ( sidtype << 8 )
	.word flipEndian2( flg )	// flags
	.byte 0,0			// relocStartPage, relocPages
	.byte ( sid2 >> 4 ) & $ff, ( sid3 >> 4 ) & $ff
	.segmentout [segments=segment]
}
.function flipEndian4( x ) {
	.return ((x & $ff000000) >> 24) | ((x & $ff0000) >> 8) | ((x & $ff00) << 8) | ((x & $ff) << 24)
}
.function flipEndian2( x ) {
	.return ((x & $ff) << 8) | (( x & $ff00 ) >> 8)
}
.macro makePSIDtx( txt ) {
	.var sl = txt.size()
	.var lst = List()
	.for ( var i=0 ; i < sl; i++ ) .eval lst.add( txt.charAt( i ) )
	.for ( ; sl < 32; sl++ ) .eval lst.add( 0 )
	.fill lst.size(), lst.get( i )
}