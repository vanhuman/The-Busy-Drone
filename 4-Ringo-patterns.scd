(
TempoClock.default.tempo = 1.1;

// 67..89
~zangP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([67,72, Prand([76,77],1),\rest],  inf),
	// \legato, 0.8,
	// \dur, 6,
	\legato, Pwhite(1.1,1.3, inf),
	\dur, 5,
	// \dur, Pwhite(8.2,8.4, inf)
);

// 67..89
~tzangP = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~bd,
	\midinote, Pseq([67,72, Prand([76,77],1),\rest],  inf),
	// \legato, 0.8,
	// \dur, 6,
	\legato, Pwhite(1.1,1.3, inf),
	\dur, 5,
	// \dur, Pwhite(8.2,8.4, inf)
);

~percussionP = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([64], inf),
	\legato, 0.5,
	\dur, 10
);

~percussionP2 = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([66], inf),
	\legato, 0.5,
	\dur, 5
);

// ( // 67..89
// ~zangS2.stop;
// ~zangP2 = Pbind(
// 	\type,\midi,
// 	\chan,0,
// 	\midiout, ~bd,
// 	\midinote, Pseq( [
// 		Pseq([\rest],2),
// 		Pseq([[67,68,69,70]], 5),
// 		Pseq([\rest],1),
// 	], inf),
// 	\legato, 0.5,
// 	\dur, 0.25 * 1.25
// );
// ~zangS2 = ~zangP2.play;
// );
// ~zangS2.stop;
//
// ( // 60..79
// ~tzangS.stop;
// ~tzangP = Pbind(
// 	\type,\midi,
// 	\chan,1,
// 	\midiout, ~bd,
// 	\midinote, Pseq([67,72, Prand([76,77,\rest],1)],  inf),
// 	\legato, 1.2,
// 	\dur, Pwhite(8.2,8.4, inf)
// );
// ~tzangS = ~tzangP.play;
// );
// ~tzangS.stop;

)