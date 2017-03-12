
// start/stop original ws version
~bd.startRegisterLoop( ); // use to startup, and after cmd-.
~bd.endRegisterLoop( ); // use to end (registers won't work after this)

// start/stop simplified version
~bd.startRegisterControl();
~bd.stopRegisterControl();


// register setting
~bd.registerList([]); // all registers off

~bd.registerList(~bd.nameLib.keys.collect({ arg item; item.asSymbol })); // all registers on

~bd.registerList([ \viool2, \cello_grave ]); // turn on viool2 and cello_grave exclusively

~bd.registerListAdd( \viool1 ); // turn viool1 on individually

~bd.registerListRemove( \viool1 ); // turn viool1 off individually

~bd.modeSet; // returns current registers in Set


// gui
~bd.w.front; // show window
~bd.makeWindow; // make window (in case it was closed)


/*
notes -----------------------------------------------

~bd acts as if it is a MIDIOut object, and listens to noteOn and noteOff messages. Internally the notes are re-routed to a convenient range. Bas, acc and zang are sequentially on channel 0, tegenzang on channel 1 and the three percussion notes on channel 2. If a note is out of range a message will be displayed.

MIDI channel 0:
bassen = ( busy drone (3..14), midi (43..54) )
accomp = ( busy drone (18..29), midi (55..66) )
zang = ( busy drone (33..55), midi (103..125) ) // ws version: (67..89)

MIDI channel 1:
tegenzang = ( busy drone (59..78), midi (60..79) )

MIDI channel 2: (between brackets the alternative when FORTE is active in bassen)
~percussie = ( busy drone [79,81,83], midi [64,65,66] ["GROTE TROM (+BEKKEN)", "HOUTBLOK (KLEINE TROM)", "HOUTBLOK2 (KLEINE TROM)"] )

registers -----------------------------------------------

~regZang = (
	busy drone [30,31,2,87,17,15,82,89,32],
	register ["VIOOL I (P) 8'", "VIOOL II (F) 8'", "UNDA MARIS 16'", "PISTON 16'", "CARILLON 8'", "FLÛTE HARMONIQUE 8'", "XYLOFOON 8'", "PICCOLO", "TREMOLO"]
);
~regTegenzang = (
	busy drone [86,84,56,58,16,57,85],
	register ["BOURDON 8'", "FLUIT 8'", "CÉLESTE 8'", "BARITON 16'", "BAXOFOON 16'", "CELLO 16'", "CELLO GRAVE 32'"]
);
~regAccomp = (); // one register that is always on
~regBassen = ( busy drone 80, register "FORTE" );
~percussie = ( busy drone [79,81,83], register ["GROTE TROM (+BEKKEN)", "HOUTBLOK (KLEINE TROM)", "HOUTBLOK2 (KLEINE TROM)"] )(between brackets the alternative when FORTE is active in bassen)
~afsluiter = ( busy drone 0, register "AFSLUITER" );

*/

~bd.noteOn( 0, 45 ); // test single note
~bd.noteOff( 0, 45 );

(
// bas, acc, zang (midi ch 0) sweep
a = Pbind(
	\type, \midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Pseq( (43..89), 1 ),
	\legato, 0.9,
	\dur, 0.5
).play;
)
a.stop

(
// bas
a = Pbind(
	\type, \midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Pseq( (43..54), 1 ),
	\legato, 0.6,
	\dur, 7
).play;
)

(
// acc
a = Pbind(
	\type, \midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Pseq( (55..66), 1 ),
	\legato, 0.6,
	\dur, 7
).play;
)

(
// zang
a = Pbind(
	\type, \midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Pseq( (67..89), 1 ),
	\legato, 0.6,
	\dur, 7
).play;
)
a.stop

(
// tegenzang (midi ch 1)
a = Pbind(
	\type, \midi,
	\chan, 1,
	\midiout, ~bd,
	\midinote, Pseq( (60..79), 1 ),
	\legato, 0.6,
	\dur, 7
).play;
)

(
// percussie (midi ch 2)
a = Pbind(
	\type, \midi,
	\chan, 2,
	\midiout, ~bd,
	\midinote, Pseq( (64..66), 1 ),
	\legato, 1,
	\dur, 0.2
).play;
)

// percussie alternative (also from GUI)
~bd.hitPerc( 'grote_trom', true );
~bd.hitPerc( 'grote_trom', false );



