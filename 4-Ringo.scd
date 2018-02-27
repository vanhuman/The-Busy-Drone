/*
The Busy Drone: Ringo // 4:00
Registers:
	Zang: flute harmonique
	Tegenzang: fluit
	Forte
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
// set registers
~bd.registerList([ \flute_harmonique, \fluit, \forte]);

// load patterns
"4-Ringo-patterns.scd".loadRelative();

// load samples
~level = 0.dbamp;
~output = 2;
~path = "/Users/Robert/---data---/Audio/projecten-a/Automatic/Samples/processed/";
~proc4a.remove; ~proc4a2.remove; ~proc4b.remove; ~proc4b2.remove; ~proc4c.remove;
~proc4c2.remove; ~proc4d.remove; ~proc4e.remove;
~proc4a = DiskPlayer(s, ~path ++ "proc4a-ringo-western-track1.wav", rel: 2, out: ~output, lev: ~level, loop: 1);
~proc4a2 = DiskPlayer(s, ~path ++ "proc4a-ringo-western-track2.wav", rel: 2, out: ~output, lev: ~level);
~proc4b = DiskPlayer(s, ~path ++ "proc4b-ringo-bekken-track1.wav", out: ~output, lev: ~level, loop: 1);
~proc4b2 = DiskPlayer(s, ~path ++ "proc4b2-ringo-bekken-track2.wav", out: ~output, lev: ~level);
~proc4c = DiskPlayer(s, ~path ++ "proc4c-ringo-snare-track1.wav", out: ~output, lev: ~level, loop: 1);
~proc4c2 = DiskPlayer(s, ~path ++ "proc4c2-ringo-snare-track2.wav", out: ~output, lev: ~level);
~proc4d = DiskPlayer(s, ~path ++ "proc4d-ringo-zang-vibrato-track.wav", out: ~output, lev: ~level);
~proc4e = DiskPlayer(s, ~path ++ "proc4e-ringo-zang-pitchup-track.wav", rel: 2, out: ~output, lev: 1.5 * ~level);

// define time task
~interval = 5;
~time = Task.new {
	var time = 0;
	'Clock started'.postln;
	inf.do {
		~interval.wait;
		time = time + ~interval;
		time.asTimeStringHM.postln;
	}
};
)

///////////////////// perform Ringo /////////////////////

(
~time.start(quant: 4);
~proc4a.playTask(quant: 4);
~proc4b.playTask(quant: 4);
~proc4c.playTask(quant: 4);
~percussionS = ~percussionP.play(quant: Quant.new(4, timingOffset: 0.1));
~percussionS2 = ~percussionP2.play(quant: Quant.new(4, timingOffset: 0.1));
)

// after 4 rounds, on the one! ------- 0:35
~zangS = ~zangP.play(quant:4);

(
~zangS.stop;
~percussionS.stop;
~percussionS2.stop;
)
// after 4 rounds, on the one! ------- 1:15
(
~proc4a.stop;
~proc4b.stop;
~proc4c.stop;
~proc4a2.playTask(quant: 4);
~proc4b2.playTask(quant: 4);
~proc4c2.playTask(quant: 4);
~percussionS = ~percussionP.play(quant: Quant.new(4, timingOffset: 0.1));
~percussionS2 = ~percussionP2.play(quant: Quant.new(4, timingOffset: 0.1));
~proc4d.playTask(quant: 4);
~zangS = ~zangP.play(quant:4);
~tzangS = ~tzangP.play(quant:4);
)

// after 4 rounds, on the one! ------- 1:55
~proc4e.playTask(quant: 4);

// after 2x4 rounds, stop tegenzang ------- 3:15
~tzangS.stop;

// after 4 rounds, stop percussie ------- 3:55
(
~percussionS.stop;
~percussionS2.stop;
)

// after 2 rounds, stop zang ------- 4:15
(
~zangS.stop;
~time.stop;
)

// reset
(
~time.stop;
~proc4a.stop;
~proc4a2.stop;
~proc4b.stop;
~proc4b2.stop;
~proc4c.stop;
~proc4c2.stop;
~proc4d.stop;
~proc4e.stop;
~bd.registerList([ ]);
~percussionS.stop;
~percussionS2.stop;
~zangS.stop;
~tzangS.stop;
~proc4a.remove;
~proc4a2.remove;
~proc4b.remove;
~proc4b2.remove;
~proc4c.remove;
~proc4c2.remove;
~proc4d.remove;
~proc4e.remove;
)