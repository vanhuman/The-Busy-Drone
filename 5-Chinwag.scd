/*
The Busy Drone: Chinwag // 3:00
Registers:
Zang: viool2, carillion
Tegenzang: bourdon, fluit
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
// activate registers
~bd.registerList([ ]);

// load patterns
"5-Chinwag-patterns.scd".loadRelative();

// load samples
~level = 0.dbamp;
~output = 2;
~path = "/Users/Robert/---data---/Audio/projecten-a/Automatic/Samples/processed/";
~proc5a.remove; ~proc5b.remove; ~proc5c.remove; ~proc5d.remove; ~proc5e.remove; ~proc5f.remove; ~proc5g.remove;
~proc5a = DiskPlayer(s, ~path ++ "proc5a-chinwag-zang-no-register-zone8-p3pup.wav", loop: 0, out: ~output, lev: 0.3 * ~level);
~proc5b = DiskPlayer(s, ~path ++ "proc5b-chinwag-zang-zone3-pup.wav", loop: 0, rel: 1, out: ~output, lev: 0.8 * ~level);
~proc5c = DiskPlayer(s, ~path ++ "proc5c-chinwag-zang-zone8-p6pdownflex.wav", loop: 0, out: ~output, lev: 0.8 * ~level);
~proc5d = DiskPlayer(s, ~path ++ "proc5d-chinwag-tzang-zone8-p5upflex.wav", loop: 0, out: ~output, lev: 0.8 * ~level);
~proc5e = DiskPlayer(s, ~path ++ "proc5e-chinwag-bassen-zone8-p4pdown.wav", loop: 1, out: ~output, lev: 0.4 * ~level);
~proc5f = DiskPlayer(s, ~path ++ "proc5f-chinwag-zang-zone3-pup.wav", loop: 1, out: ~output, lev: 0.8 * ~level);
~proc5g = DiskPlayer(s, ~path ++ "proc5g-chinwag-bassen-zone8-p4pdown-freeze.wav", rel: 5, out: ~output, lev: 0.8 * ~level);
)

///////////////////// perform Chinwag /////////////////////

// no register
TempoClock.default.tempo = 1.0;
~zangS = ~zangP.play(quant: 1);

~bd.registerListAdd( \viool2 );
~bd.registerListRemove( \viool2 );

~bd.registerListAdd( \viool2 );
~bd.registerListRemove( \viool2 );

~proc5a.start;

// zang register on/off a couple of times
~bd.registerListAdd( \viool2 );

~proc5b.start;

~proc5a.stop;

~proc5c.start;

// no register
~proc5b.stop;
~tzangS = ~tzangP.play(quant: 1);
~proc5c.set(\lev,0.4);

// tzang register on/off a couple of times
~bd.registerListAdd( \bourdon );
~proc5c.start;
~proc5c.set(\lev,0.8);
~bd.registerListRemove( \bourdon );
(
~bd.registerListAdd( \bourdon );
~proc5d.start;
)
(
~zangS.stop;
~proc5c.stop;
)

// add bassen
(
~bd.registerListRemove( \bourdon );
~bd.registerListAdd( \fluit );
~bassenS = ~bassenP.play(quant: 1);
)
~proc5e.start;
~proc5d.stop;

// forte
~proc5d.start;
(
~proc5e.set(\lev,2);
~bd.registerListAdd( \forte );
)

~bd.registerListRemove( \forte );
~proc5e.set(\lev,1);
~bd.registerListAdd( \forte );
~proc5e.set(\lev,2);

// remove forte
(
~proc5d.stop;
~bd.registerListRemove( \forte );
~proc5f.start;
)

// add zang
~zangS = ~zangP.play(quant: 1);

~proc5e.start;
~proc5e.set(\lev,4);

// drop tempo
(
TempoClock.default.tempo = 0.05;
~proc5e.stop;
~proc5f.stop;
~proc5g.start;
)


// reset tempo full force
(
~proc5e.start;
~proc5e.set(\lev,3);
~proc5f.start;
TempoClock.default.tempo = 1;
~bd.registerListAdd( \carillion );
~zangS2 = ~zangP2.play(quant: 1);
)

(
~tzangS.stop;
{ ~bassenS.stop }.defer(1);
{ ~zangS2.stop }.defer(2.5);
~proc5b.start;
~proc5g.stop;
)

~proc5f.stop;

~proc5b.stop;

// speed up and crumble zang
TempoClock.default.tempo = 1.5;
TempoClock.default.tempo = 2.0;
TempoClock.default.tempo = 2.5;
~bd.registerListRemove( \viool2 );
~zangS.stop;

// reset
(
~bd.registerList([ ]);
~bassenS.stop;
~zangS.stop;
~zangS2.stop;
~tzangS.stop;
~proc5a.stop;
~proc5b.stop;
~proc5c.stop;
~proc5d.stop;
~proc5e.stop;
~proc5f.stop;
~proc5g.stop;
~proc5a.remove;
~proc5b.remove;
~proc5c.remove;
~proc5d.remove;
~proc5e.remove;
~proc5f.remove;
~proc5g.remove;
)