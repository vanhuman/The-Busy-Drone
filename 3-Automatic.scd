/*
The Busy Drone: Automatic // 2:00
Registers:
	Zang: viool1 / carillion
	Tegenzang: bourdon / fluit
*/

///////////////////// start BusyDrone connection /////////////////////
(
s.waitForBoot {
	~midiDest = ["UltraLite mk3 Hybrid", "MIDI Port"];
	"BusyDroneSetup.scd".loadRelative();
}
)

///////////////////// setup song /////////////////////
(
// set registers
~bd.registerList([ \viool1, \carillion, \bourdon ]);

// load patterns
"3-Automatic-patterns.scd".loadRelative();
)

///////////////////// perform Automatic /////////////////////

// start bassen
~bassenS = ~bassenP.play(quant: 1);

// then beat
~percussionS = ~percussionP.play(quant: Quant.new(2, timingOffset: 0.1));

// try a couple of times until timing is good
~percussion2S = ~percussion2P.play(quant: Quant.new(1, timingOffset: 0.0));
~percussion2S.stop;
~percussion2S = ~percussion2P.play(quant: Quant.new(1, timingOffset: 0.0));

~tzangS = ~tzangP.play();

~bd.registerListAdd( \forte );

(
~bd.registerListRemove( \forte );
~percussion2S.stop;
~tzangS.stop;
)

// try a couple of times until the timing is good
~percussion2S = ~percussion2P.play(quant: Quant.new(1, timingOffset: 0.0));
~percussion2S.stop;

~tzangS = ~tzangP.play();

~zangS = ~zangP.play();

~bd.registerListAdd( \forte );

~zang2S = ~zang2P.play(quant: 1)

// stop on 4 afterbeat
(
~zang2S.stop;
~zangS.stop;
~tzangS.stop;
~bassenS.stop;
~percussionS.stop;
~percussion2S.stop;
)

// reset
(
~bd.registerList([ ]);
~percussionS.stop;
~percussionS2.stop;
~bassenS.stop;
~zangS.stop;
~zangS2.stop;
~tzangS.stop;
)