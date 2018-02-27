(
TempoClock.default.tempo = 1.1;

// 43..54
~bassenP = Pbind(
	\type,\midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Pseq([43, 44, 46, 48], inf),
	\legato, 1,
	\dur, 0.2
);

~percussionP = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([64], inf),
	\legato, 0.5,
	\dur, 0.4
);

~percussion2P = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([66], inf),
	\legato, 0.5,
	\dur, 0.4
);

// 60..79
~tzangP = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~bd,
	\midinote, Pseq([67],  inf),
	\legato, 0.2,
	\dur, Pseq([0.05,0.05,0.05,0.1,0.1,0.05], inf)
);

// 67..89
~zangP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([85,86], inf),
	\legato, 0.5,
	\dur, Pseq([0.05,0.05,0.05,0.1,0.1,0.05], inf)
);

// 67..89
~zang2P = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([89], inf),
	\legato, 0.2,
	\dur, 0.2
);
)