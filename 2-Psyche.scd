/*
The Busy Drone: Psyche

Registers:
Zang: piston
Tegenzang: celeste & bariton

spelen met lucht uit/aan?
electronische bewerking zang aan het eind
*/

~bassenS = ~bassenP.play(quant: 1);

~percussionS = ~percussionP.play(quant: Quant.new(1, timingOffset: 0.1));

~accompS = ~accompP.play(quant: 1);
~tzangS = ~tzangP.play(quant: 1);
~percussion2S = ~percussion2P.play(quant: Quant.new(1, timingOffset: 0.0));

~tzangS.stop;
~percussion2S.stop;
~zangS = ~zangP.play(quant: 1);
~zangS.stop;

~tzangS = ~tzangP.play(quant: 1);
~zangS = ~zangP.play(quant: 1);
~percussion2S = ~percussion2P.play(quant: Quant.new(1, timingOffset: 0.0));

~accompS.stop;
~percussion2S.stop;
~tzangS.stop;
~bassenS.stop;
~percussionS.stop;
~zangS.stop;


// patterns -------------------------------------------------
(
TempoClock.default.tempo = 1;

// 43..54
~bassenP = Pbind(
	\type,\midi,
	\chan, 0,
	\midiout, ~bd,
	\midinote, Pseq([43, 49], inf),
	\legato, 1,
	\dur, Pseq([1,1,1,0.5], inf )
);

~percussionP = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([64], inf),
	\legato, 0.5,
	\dur, 2
);

~percussion2P = Pbind(
	\type,\midi,
	\chan,2,
	\midiout, ~bd,
	\midinote, Pseq([66], inf),
	\legato, 0.75,
	\dur, 2
);

// 55..66
~accompP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([55,56,\rest,58,\rest,59,58], inf),
	\legato, 1,
	\dur, 0.5
);

// 60..79
~tzangP = Pbind(
	\type,\midi,
	\chan,1,
	\midiout, ~bd,
	\midinote, Pseq([67,73,\rest,74,\rest,73],  inf),
	\legato, 1,
	\dur, Pseq([2,2,0.5,0.5,0.5,0.5], inf)
);

// 67..89
~zangP = Pbind(
	\type,\midi,
	\chan,0,
	\midiout, ~bd,
	\midinote, Pseq([79,80,82,86,85], inf),
	\legato, 0.5,
	\dur, 0.125
);
)