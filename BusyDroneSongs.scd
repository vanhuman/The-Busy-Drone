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

// Setup -----------------------------------------------

(
// load MIDI function
"### Initialize MIDI".postln;
"BusyDroneMIDI.scd".loadRelative();
// ~bd.realOrgan("UltraLite mk3 Hybrid", "MIDI Port");
~bd.realOrgan("IAC Driver", "IAC Bus 1");
"### Done initializing MIDI".postln;
)

// start window
"BusyDroneSetup.scd".loadRelative();

// start/stop register control (automatically started with the window, needed after command-.)
~bd.startRegisterLoop( ); // use to startup, and after cmd-.
~bd.endRegisterLoop( ); // use to end (registers won't work after this)

TempoClock.default.tempo = 1;


// Songs -----------------------------------------------

// 7/8 pulse -----------------------------------------------

~percussionS = ~percussionP.play(quant: Quant.new(1, timingOffset: 0.1));
~bassenS = ~bassenP.play(quant: 1);

~percussionS.stop;
~bassenS.stop

( // 43..54
~bassenS.stop;
~bassenP = Pbind(
	\type,\midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Pseq([43, 49, 44, 47], inf),
	\legato, 1,
	\dur, Prand( [ Pseq([0.4,0.4,0.4,0.2],3),
		Prand( [Pseq([0.4,0.4,0.2,0.4],1), Pseq([0.4,0.2,0.4,0.4],1)], 2)
	], inf ) // 7/8 met accentverwisseling
);
~bassenS = ~bassenP.play(quant: 1);
)
~bassenS.stop

( // 64..66
~percussionS.stop;
~percussionP = Pbind(
	\type,\midi,
	\chan, 2,
	\midiout, ~bd,
	\midinote, Pseq([64], inf),
	\legato, Pseq([0.4/1.4,0.8/1.4],inf),
	\dur, 1.4
);
~percussionS = ~percussionP.play(quant: Quant.new(1, timingOffset: 0.05));
)
~percussionS.stop

( // 60..79
~tzangS.stop;
~tzangP = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~bd,
	\midinote, Pseq([Pwrand([68,70],[0.9,0.1]), Prand([69,70],1)], inf),
	\legato, 1,
	\dur, 2
);
~tzangS = ~tzangP.play(quant: 1)
)
~tzangS.stop

( // 55..66
~accompS.stop;
~accompP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([Pwrand([55,56],[0.9,0.1]), Pwrand([66,\rest],[0.3,0.7]) ], inf),
	\legato, 0.3,
	\dur, Prand([0.4,0.6], inf)
);
~accompS = ~accompP.play(quant: 1)
)
~accompS.stop

( // 67..89
~zangS.stop;
~zangP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Prand((67..89), inf),
	\legato, 1,
	\dur, Pwrand([0.51, 0.1], [0.3,0.7], inf)
);
~zangS = ~zangP.play(quant: 1)
)
~zangS.stop



// drone -----------------------------------------------

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


// trippy -----------------------------------------------


( // 43..54
~bassenS.stop;
~bassenP = Pbind(
	\type,\midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Pseq([43, 49], inf),
	\legato, 1,
	\dur, Pseq([1,1,1,0.5], inf )
);
~bassenS = ~bassenP.play(quant: 1);
 )
~bassenS.stop

(
~percussionS.stop;
~percussionP = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([64], inf),
	\legato, 0.5,
	\dur, 2
);
~percussionS = ~percussionP.play(quant: Quant.new(1, timingOffset: 0.1));
)
~percussionS.stop

~bassenS = ~bassenP.play(quant: 1);
~percussionS = ~percussionP.play(quant: Quant.new(1, timingOffset: 0.1));

( // 55..66
~accompS.stop;
~accompP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([55,56,\rest,58,\rest,59,58], inf),
	\legato, 1,
	\dur, 0.5
);
~accompS = ~accompP.play(quant: 1)
)
~accompS.stop

(
~percussion2S.stop;
~percussion2P = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([66], inf),
	\legato, 0.75,
	\dur, 2
);
~percussion2S = ~percussion2P.play(quant: Quant.new(1, timingOffset: 0.0));
)
~percussion2S.stop

( // 60..79
~tzangS.stop;
~tzangP = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~bd,
	\midinote, Pseq([67,73,\rest,74,\rest,73],  inf),
	\legato, 1,
	\dur, Pseq([2,2,0.5,0.5,0.5,0.5], inf)
);
~tzangS = ~tzangP.play(quant: 1)
)
~tzangS.stop

( // 67..89
~zangS.stop;
~zangP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([79,80,82,86,85], inf),
	\legato, 0.5,
	\dur, 0.125
);
~zangS = ~zangP.play(quant: 1)
)
~zangS.stop


// gabber -----------------------------------------------

( // 43..54
~bassenS.stop;
~bassenP = Pbind(
	\type,\midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Pseq([43, 44, 46, 48], inf),
	\legato, 1,
	\dur, 0.2
);
~bassenS = ~bassenP.play(quant: 1);
 )
~bassenS.stop

(
~percussionS.stop;
~percussionP = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([64], inf),
	\legato, 0.5,
	\dur, 0.4
);
~percussionS = ~percussionP.play(quant: Quant.new(1, timingOffset: 0.1));
)
~percussionS.stop

~bassenS = ~bassenP.play(quant: 1);
~percussionS = ~percussionP.play(quant: Quant.new(1, timingOffset: 0.1));

(
~percussion2S.stop;
~percussion2P = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([66], inf),
	\legato, 0.5,
	\dur, 0.4
);
~percussion2S = ~percussion2P.play(quant: Quant.new(1, timingOffset: 0.0));
)
~percussion2S.stop

( // 60..79
~tzangS.stop;
~tzangP = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~bd,
	\midinote, Pseq([67],  inf),
	\legato, 0.2,
	\dur, Pseq([0.05,0.05,0.05,0.1,0.1,0.05], inf)
);
~tzangS = ~tzangP.play(quant: 1)
)
~tzangS.stop

( // 67..89
~zangS.stop;
~zangP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([85,86], inf),
	\legato, 0.5,
	\dur, Pseq([0.05,0.05,0.05,0.1,0.1,0.05], inf)
);
~zangS = ~zangP.play(quant: 1)
)
~zangS.stop

( // 67..89
~zang2S.stop;
~zang2P = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([89], inf),
	\legato, 0.2,
	\dur, 0.2
);
~zang2S = ~zang2P.play(quant: 1)
)
~zang2S.stop