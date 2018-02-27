/*
The Busy Drone: 78selected // 2:00
Registers:
Zang: piston
Tegenzang: bourdon
*/

///////////////////// start BusyDrone connection /////////////////////
(
s.waitForBoot {
	~midiDest = ["UltraLite mk3 Hybrid", "MIDI Port"];
	// ~midiDest = ["IAC Driver","IAC Bus 2"];
	"BusyDroneSetup.scd".loadRelative();
	~vol = s.volume; ~vol.gui(nil, Rect((Window.screenBounds.width - 285), 150, 80, 300));
}
)

///////////////////// setup song /////////////////////
(
// activate registers
~bd.registerList([ \piston, \bourdon ]);

// load patterns
"1-78selected-patterns.scd".loadRelative();

// load samples
~level = 0.dbamp;
~output = 2;
~path = "/Users/Robert/---data---/Audio/projecten-a/Automatic/Samples/processed/";
~proc1a.remove; ~proc1b.remove; ~proc1c.remove;
~proc1a = DiskPlayer(s, ~path ++ "proc1a-78selected-tzang-decimate1.wav", loop: 1, out: ~output, lev: 0.5 * ~level);
~proc1b = DiskPlayer(s, ~path ++ "proc1b-78selected-zang-decimate1.wav", loop: 1, out: ~output, lev: 0.5 * ~level);
~proc1c = DiskPlayer(s, ~path ++ "proc1c-78selected-zang-decimate2.wav", loop: 0, out: ~output, lev: 0.25 * ~level);
)

///////////////////// perform 78selected /////////////////////

// start rhythm
(
~percussionS = ~percussionP.play(quant: Quant.new(1, timingOffset: 0.1));
~bassenS = ~bassenP.play(quant: 1);
)
// stop if not in sync
~percussionS.stop;
~bassenS.stop;

// leave rhythm for a while so people get used to it, then:
~accompS = ~accompP.play(quant: 1);

// pretty quickly after that:
~tzangS = ~tzangP.play(quant: 1);

// add zang a couple of times, short but increasingly longer
~zangS = ~zangP.play(quant: 1);
~zangS.stop;
~zangS = ~zangP.play(quant: 1);
~zangS.stop;
~zangS = ~zangP.play(quant: 1);
~zangS.stop;

// then zang solo
(
~zangS.stop;
~tzangS.stop;
~accompS.stop;
{ ~zangS = ~zangP.play(quant: 1) }.defer(0.5);
)

// let it sing for a while, then stop
~zangS.stop;

// rhythm only for a couple of bars, then:
~accompS = ~accompP.play(quant: 1);

// quickly after that:
(
~proc1a.start;
{
	~tzangS = ~tzangP.play(quant: 1);
	~zangS = ~zangP.play(quant: 1);
}.defer(0.5);
)

// stop all at the same time
(
~proc1a.stop; // stop processed version
~zangS.stop;
~tzangS.stop;
~accompS.stop;
{
	~proc1b.start;
}.defer(2);
)
~proc1b.stop; // stop crumbling processed version
(
~percussionS.stop;
~bassenS.stop;
~proc1c.start;
)
// let proc1c finish
~proc1c.stop;

// reset
(
~bd.registerList([ ]);
~percussionS.stop;
~bassenS.stop;
~zangS.stop;
~tzangS.stop;
~accompS.stop;
~proc1a.stop;
~proc1b.stop;
~proc1c.stop;
~proc1a.remove;
~proc1b.remove;
~proc1c.remove;
)

