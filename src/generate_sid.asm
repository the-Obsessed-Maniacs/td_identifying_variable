/*
 *	Trying to make KickAssembler output a valid .sid file.
 *	======================================================
 *	-> 2 SIDs, Addresses $D400, $D420
 *	-> new/old egal.
 */

.macro PSID_header( loadAddr, initAddr, playAdr, sid2, sid3 ) {
	.dword flipEndian4( $50534944 )	// PSID
	.word flipEndian2( 3 )				// Version 4
	.word flipEndian2( $7c )			// dataOffset, version 2+
	.word flipEndian2( loadAddr ), flipEndian2( initAddr ), flipEndian2( playAdr )
	.word flipEndian2( 1 ),flipEndian2( 1 )
	.dword 0
	.encoding "ascii"
	.text "TinyDancer: »identify variable« "	//
	.text "St0fF / theObsessedManiacs ^ NPL"	//
	.text "2025-12-24                      "	//
	.word flipEndian2( %0000000110 )	// flags
	.byte 0,0			// relocStartPage, relocPages
	.byte sid2, sid3
}
.function flipEndian4( x ) {
	.return ((x & $ff000000) >> 24) | ((x & $ff0000) >> 8) | ((x & $ff00) << 8) | ((x & $ff) << 24)
}
.function flipEndian2( x ) {
	.return ((x & $ff) << 8) | (( x & $ff00 ) >> 8)
}