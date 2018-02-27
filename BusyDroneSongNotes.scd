// fake Busy Drone
(
~lisa = nil; ~sk = nil;
"../Lapis/InOut.scd".loadRelative();
)
"../Lapis/SynthKeysArray.scd".loadRelative();

(
// set MIDI destination - specify MIDI out device to Busy Drone
// ~midiDest = ["IAC Driver","IAC Bus 2"];
~midiDest = ["UltraLite mk3 Hybrid", "MIDI Port"];

// start BusyDrone connection
"BusyDroneSetup.scd".loadRelative();
)

// start/stop register control (automatically started with the window, needed after command-.)
~bd.startRegisterLoop( ); // use to startup, and after cmd-.
~bd.endRegisterLoop( ); // use to end (registers won't work after this)

/*

zorg ervoor dat alle lagen op elk moment te stoppen en herstarten zijn
zorg ervoor dat de server herstart kan worden / loadRelative daarvoor!

Songs:
1 - 5 - 4 - 3

*/






/*
Issues:
1. Eén noot ALLEEN stopt vanzelf na 5-6 sec. Als er andere noten tegelijk spelen gebeurt dit niet.

Ideeën:

1. registers wisselen terwijl noten klinken moet onderdeel zijn van het stuk, het haperen
2. drone stuk met beat van bassdrum, weinig wisselen van registers, want is een ding, maar sampling subtiel pitchshiften
3. pulse stuk, meer testen ivm performance
4. registers vals als meer noten aangeblazen? testen

Nieuwe Ideeën:
1. Axelrod stuk (The Divine Image) / pulse 7/8, psychedelisch maar atonaal
2. tonale versie van 1.
3. drone met af en toe drum
4. met veel noten raakt de lucht snel op, bassen hebben voorrang qua luchttoevoer
5. motor aan/uit (mechaniek blijft wel werken)

------------------------------------------------------------

MIDI channel 0:
bassen = ( busy drone (3..14), midi (43..54) )
accomp = ( busy drone (18..29), midi (55..66) )
zang = ( busy drone (33..55), midi (103..125) ) // ws version: (67..89)

MIDI channel 1:
tegenzang = ( busy drone (59..78), midi (60..79) )

MIDI channel 2: (between brackets the alternative when FORTE is active in bassen)
~percussie = ( busy drone [79,81,83], midi [64,65,66] ["GROTE TROM (+BEKKEN)", "HOUTBLOK (KLEINE TROM)", "HOUTBLOK2 (KLEINE TROM)"] )

*/

// Dronsel (drone) ----------------------------------------------- // cancel

TempoClock.default.tempo = 1;

(
~percussionS.stop;
~percussionP = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([64], inf),
	\legato, Pseq([0.4,0.8],inf),
	\legato, 0.5,
	\dur, 4
);
~percussionS = ~percussionP.play(quant: 1);
)
~percussionS.stop

( // 60..79
~tzangS.stop;
~tzangP = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~bd,
	\midinote, Pwrand([60,66,\rest], [0.4,0.4,0.2],  inf),
	\legato, 1,
	\dur, Pwhite(4,6, inf)
);
~tzangS = ~tzangP.play
)
~tzangS.stop

( // 67..89
~zangS.stop;
~zangP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pwrand([71,78,\rest], [0.4,0.4,0.2], inf),
	\legato, 1,
	\dur, Pwhite(5,7, inf)
);
~zangS = ~zangP.play
)
~zangS.stop

( // 55..66
~accompS.stop;
~accompP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pwrand([60,66,\rest], [0.4,0.4,0.2], inf),
	\legato, 1,
	\dur, Pwhite(5,7, inf)
);
~accompS = ~accompP.play
)
~accompS.stop

( // 43..54
~bassenS.stop;
~bassenP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pwrand([[44,49],[43,47],[45,48]],[0.05,0.45,0.5], inf),
	\legato, 1,
	\dur, Pwhite(5,8, inf)
);
~bassenS = ~bassenP.play
)
~bassenS.stop

~percussionS = ~percussionP.play(quant: 1);
~bassenS = ~bassenP.play(quant: 1)
~accompS = ~accompP.play(quant: 1)
~tzangS = ~tzangP.play(quant: 1)
~zangS = ~zangP.play(quant: 1)
~zangS.stop;
~tzangS.stop;
~accompS.stop;
~bassenS.stop;
~percussionS.stop





///////////////// jazz ////////////////// --- backup


( // 55..66
~accompS2.stop;
~accompP2 = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pwrand([
		Pseq([
			Pshuf([56,58,59,61,\rest],1),
			Pseq([\rest],1)
		], 1),
		Pseq([
			Pshuf([54,56,57,59,\rest],1),
			Pshuf([54,56,57,59,\rest],1),
			Pseq([\rest],1)
		], 1)
	], [0.9,0.1], inf),
	\legato, Pwhite(1.1,1.5),
	\dur, Pseq([
		Prand([
			Pseq([0.2,0.2,0.2,0.2,0.2],1),
			Pseq([0.2,0.4,0.2,0.2,0.2],1),
			Pseq([0.2,0.2,0.4,0.2,0.2],1),
			Pseq([0.2,0.2,0.2,0.4,0.2],1),
			Pseq([0.4,0.2,0.4,0.2,0.2],1),
		],1),
		Pwrand([0.4,0.6,1.2], [0.5,0.4,0.1], 1)
	], inf)
);
~accompS2 = ~accompP2.play(quant: 1)
)
~accompS2.stop

(
~percussionS.stop;
~percussionP = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([64], inf),
	\legato, 0.5,
	\dur, Pshuf([0.6, 0.6, 1.2, 0.4, 0.4], inf)
);
~percussionS = ~percussionP.play(quant: Quant.new(1, timingOffset: 0.1));
)
~percussionS.stop