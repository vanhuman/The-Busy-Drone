(
TempoClock.default.tempo = 1;

// 60..79 bourdon / flute
~tzangP = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~bd,
	\midinote, Pseq([69],  inf),
	\legato, 0.2,
	\dur, Pseq([0.05,0.05,0.05,0.1,0.1,0.05], inf)
);

// 67..89 viool2
~zangP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Prand([89,82,84,\rest], inf),
	\legato, 0.1,
	\dur, Prand([
		Pseq([0.05,0.02,0.05,0.1,0.08,0.05], 1),
		Pseq([0.05,0.05,0.1,0.1,0.05], 1),
		Pseq([0.02,0.06,0.1,0.1,0.05], 1),
		Pseq([0.05,0.05,0.11,0.07], 1),
		Pseq([0.05,0.15,0.1,0.05], 1)
	], inf)
);

// 67..89 viool2
~zangP2 = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Prand([89], inf),
	\legato, 0.1,
	\dur, Prand([
		Pseq([0.05,0.02,0.05,0.1,0.08,0.05], 1),
		Pseq([0.05,0.05,0.1,0.1,0.05], 1),
		Pseq([0.02,0.06,0.1,0.1,0.05], 1),
		Pseq([0.05,0.05,0.11,0.07], 1),
		Pseq([0.05,0.15,0.1,0.05], 1)
	], inf)
);

// 43..54
~bassenP = Pbind(
	\type,\midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Prand([47, 54, 46, 43, \rest], inf),
	\legato, 0.5,
	\dur, Prand([
		Pseq([0.05,0.02,0.05,0.1,0.08,0.05], 1),
		Pseq([0.05,0.05,0.1,0.1,0.05], 1),
		Pseq([0.02,0.06,0.1,0.1,0.05], 1),
		Pseq([0.05,0.05,0.11,0.07], 1),
		Pseq([0.05,0.15,0.1,0.05], 1)
	], inf)
);

~percussionP2 = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Prand([64,65,66], inf),
	\legato, 0.5,
	\dur, Prand([
		Pseq([0.5,0.2,0.5,0.1,0.08,0.5], 1),
		Pseq([0.5,0.5,0.1,0.1,0.09], 1),
		Pseq([0.2,0.6,0.18,0.2,0.08], 1),
		Pseq([0.5,0.9,0.11,0.7], 1),
		Pseq([0.5,0.15,1.6,0.05], 1)
	], inf)
);
)