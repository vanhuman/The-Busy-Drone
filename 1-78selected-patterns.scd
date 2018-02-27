(
TempoClock.default.tempo = 1;

// 43..54
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

// 64..66
~percussionP = Pbind(
	\type,\midi,
	\chan, 2,
	\midiout, ~bd,
	\midinote, Pseq([64], inf),
	\legato, Pseq([0.4/1.4,0.8/1.4],inf),
	\dur, 1.4
);

// 60..79
~tzangP = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~bd,
	\midinote, Pseq([Pwrand([68,70],[0.9,0.1]), Prand([69,70],1)], inf),
	\legato, 1,
	\dur, 2
);

// 55..66
~accompP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([Pwrand([55,56],[0.9,0.1]), Pwrand([66,\rest],[0.3,0.7]) ], inf),
	\legato, 0.3,
	\dur, Prand([0.4,0.6], inf)
);

// 67..89
~zangP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Prand((67..89), inf),
	\legato, 1,
	\dur, Pwrand([0.51, 0.1], [0.3,0.7], inf)
);
)