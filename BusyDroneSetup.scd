// Busy Drone setup, definitions and window -------------------
(
// notes -----------------------------------------------
// ~zang = ( send: (33..55), sound: (103..125) ); // ws sound: (67..89)
// ~tegenzang = ( send: (59..78), sound: (60..79) );
// ~accomp = ( send: (18..29), sound: (55..66) );
// ~bassen = ( send: (3..14), sound: (43..54) );
// ~percussie = ( send: [79,81], sound: ["GROTE TROM (+BEKKEN BIJ FORTE)", "HOUTBLOK (KLEINE TROM BIJ FORTE)"] );

// version to send to IAC to test
// ~bd.noteOn = { |evt, chan = 0, note = 64, veloc = 64|
// 	evt.m.noteOn( 15, note, veloc );
// };

~bd.noteOn = { |evt, chan = 0, note = 64, veloc = 64|
	//[ \busy, chan, note, veloc ].postln;
	switch( chan,
		0, { // bas, acc, zang 43-89
			//[ \busy, chan, note, veloc ].postln;
			case { note.inclusivelyBetween( 43, 54 ) } { // bas; 3-14
				evt.m.noteOn( 0, note - 40, veloc );
			} { note.inclusivelyBetween( 55, 66 ) } { // acc; 18-29
				evt.m.noteOn( 0, note - 37, veloc );
			} { note.inclusivelyBetween( 67, 89 )  } { // zang; 33-55
				evt.m.noteOn( 0, note - 34, veloc );
			} {
				"busy note % (%, ch% ) out of range\n".postf( note, note.midiname, chan );
				evt.m;
			};
		},
		1, { // tegenzang 60-79
			if ( note.inclusivelyBetween( 60, 79 ) ) { // tegenzang; 59-78
				evt.m.noteOn( 0, note - 1, veloc );
			} {
				"busy note % (%, ch% ) out of range\n".postf( note, note.midiname, chan );
				evt.m
			};
		},
		2, { // perc
			switch( note,
				64, { evt.hitPerc( 'grote_trom', (veloc > 0) ) },
				65, { evt.hitPerc( 'houtblok1', (veloc > 0) ) },
				66, { evt.hitPerc( 'houtblok2', (veloc > 0) ) },
				{
					"note % (%, ch% ) out of range\n".postf( note, note.midiname, chan );
					evt.m;
				}
			);
		}
	);
};

~bd.noteOff = { |evt, chan = 0, note = 64, veloc = 64|
	evt.noteOn( chan, note, 0 );
};

~bd.nameLib = OEM( // all names with original numberings (midi note number is this number - 1)
	\unda_maris, 3,
	\flute_harmonique, 16,
	\baxofoon, 17,
	\carillion, 18,
	\viool1, 31,
	\viool2, 32,
	\tremolo, 33,
	\celeste, 57,
	\cello, 58,
	\bariton, 59,
	\forte, 81,
	\xylofoon, 83,
	\fluit, 85,
	\cello_grave, 86,
	\bourdon, 87,
	\piston, 88,
	\piccolo, 90,
);

~bd.percLib = OEM(
	\grote_trom, 80,
	\houtblok1, 82,
	\houtblok2, 84,
);

~bd.whichLib = ( // which name belongs to which section
	\zang: #[ viool1, viool2, unda_maris, piston, carillion, flute_harmonique, xylofoon, piccolo, tremolo],
	\tegenzang: #[ bourdon, fluit, celeste, bariton, baxofoon, cello, cello_grave ],
	\bassen: #[ forte ],
);

~bd.modeSet = Set(); // registers that are on go in here

~bd.percSet = Set();

~bd.hitPerc = { |evt, which = \grote_trom, mode = true|
	if( evt.percSet.includes( which ) != mode ) {
		evt.m.noteOn( 0, evt.percLib[ which ] - 1, mode.binaryValue * 127 );
		if( mode ) {
			evt.percSet.add( which );
		} {
			evt.percSet.remove( which );
		};
		evt.changed( \percSet );
	};
};

// ---- don't need this I think
// ~bd.setRegister = { |evt, which = \viool1, mode = true, close = true|
// 	mode = mode.booleanValue;
// 	if( evt.nameLib.keys.includes( which ) ) {
// 		if( mode == 1 ) {
// 			if( evt.modeSet.includes( which ).not ) {
// 				evt.modeSet.add( which );
// 				evt.changed( \modeSet );
// 				evt.m.noteOn( 0, evt.nameLib[ which ] - 1, 127 );
// 				// { 0.1.wait; evt.m.noteOn( 0, evt.nameLib[ which ] - 1, 0 ); }.fork;
// 			};
// 		} {
// 			if( evt.modeSet.includes( which ) ) {
// 				evt.modeSet.remove( which );
// 				evt.changed( \modeSet );
// 				evt.m.noteOn( 0, evt.nameLib[ which ] - 1, 0 );
// 			};
// 			if( close ) {
// 				evt.closeRegisters;
// 			};
// 		};
// 	} {
// 		"unknown register; %\n".postf( which );
// 	}
// };

// alternative, simpeler solution? this raises problems if you change the registers fast
// ~bd.startRegisterControl = { |evt|
// 	evt.registerCtrl = (SimpleController( ~bd )
// 		.put( \modeSet, {
// 			var currentSet = evt.modeSet.copy;
// 			Task({
// 				1.do {
// 					evt.m.noteOn(0, 0, 127); // afsluiter aan
// 					currentSet.as(Array).do({ |which|
// 						evt.m.noteOn( 0, evt.nameLib[ which ] - 1, 127 ); // turn on stops that shoud stay
// 					});
// 					0.1.wait;
// 					evt.m.noteOn(0, 0, 0); // afsluiter uit
// 					0.1.wait;
// 					currentSet.as(Array).do({ |which|
// 						evt.m.noteOn( 0, evt.nameLib[ which ] - 1, 0 );
// 					});
// 					0.1.wait;
// 				}
// 			}).play;
// 		})
// 	);
// };
// ~bd.startRegisterControl();
//
// ~bd.stopRegisterControl = {
// 	~bd.registerList([]); // all registers off
// 	~bd.registerCtrl.remove;
// 	~bd.registerCtrl = nil;
// 	~bd.m.noteOn(0, 0, 0); // make sure afsluiter is down;
// };

~bd.startRegisterLoop = { |evt, force = false|
	if( force ) { evt.registerLoop.stop; };
	if( evt.registerLoop.isPlaying.not ) {
		evt.registerCondition = evt.registerCondition ?? { Condition(false) };
		evt.registerCtrl = SimpleController( evt )
		.put( \modeSet, {
			evt.registerCondition.test = true;
			evt.registerCondition.signal;
		});
		evt.registerCondition.test = false;
		evt.registerLoop = {
			var currentSet;
			currentSet = evt.modeSet.copy;
			loop {
				evt.registerCondition.wait;
				if( evt.modeSet != currentSet ) {
					currentSet = evt.modeSet.copy;
					evt.registerCondition.test = false;
					// "changed".postln;
					evt.m.noteOn(0, 0, 127); // afsluiter aan
					currentSet.as(Array).do({ |which|
						evt.m.noteOn( 0, evt.nameLib[ which ] - 1, 127 ); // turn on stops that should stay
					});
					0.1.wait;
					evt.m.noteOn(0, 0, 0); // afsluiter uit
					0.1.wait;
					currentSet.as(Array).do({ |which|
						evt.m.noteOn( 0, evt.nameLib[ which ] - 1, 0 );
					});
					0.1.wait;
					// "notes sent".postln;
				} {
					evt.registerCondition.test = false;
					// "no change".postln;
				};
			};
		}.fork;
	};
};

~bd.startRegisterLoop( true );

~bd.endRegisterLoop = { |evt|
	evt.registerLoop.stop;
	evt.registerLoop = nil;
	evt.registerCtrl.remove;
	evt.registerCtrl = nil;
	evt.m.noteOn(0, 0, 0); // make sure afsluiter is down;
};

~bd.registerList = { |evt, list|
	evt.modeSet = list.as( Set );
};

~bd.registerListAdd = { |evt, item|
	if( item.notNil ) {
		evt.modeSet.add( item );
		evt.changed( \modeSet );
	};
};

~bd.registerListRemove = { |evt, item|
	if( item.notNil ) {
		evt.modeSet.remove( item );
		evt.changed( \modeSet );
	};
};

~bd.makeWindow = { |evt|
	var w, setValues, setPercValues, ctrl;
	if( evt.w.notNil && { evt.w.isClosed.not }) {
		evt.w.close;
	};
	evt.w = w = Window( "The Busy Drone", Rect(1200, 70, 180, 634) ).alwaysOnTop_(true).front;
	evt.w.addFlowLayout;
	evt.c1 = CompositeView( evt.w, 174 @ 620 ).background_( Color.white.alpha_( 1 ) );
	evt.c1.addFlowLayout;
	evt.views = ();
	// evt.font = Font("Avenir",14);
	evt.font = Font.default;

	StaticText( evt.c1, 166 @ 18 ).string_( "zang" ).align_( \center ).font_(evt.font)
	.background_( Color.green(1,0.2) );
	evt.whichLib[ \zang ].do({ |item|
		evt.views[ item ] = SmoothButton( evt.c1, 166 @ 18 )
			.radius_(2).border_(1).canFocus_(false).font_(evt.font)
			.states_( [ [item.asString, Color.black, Color.white], [item.asString, Color.black, Color.green] ] )
			.action_({ |bt|
				switch( bt.value,
					1, { evt.registerListAdd( item ) },
					0, { evt.registerListRemove( item ) }
				);
			});
	});

	StaticText( evt.c1, 166 @ 18 ).string_( "tegenzang" ).align_( \center ).font_(evt.font)
		.background_( Color.green(1,0.2) );
	evt.whichLib[ \tegenzang ].do({ |item|
		evt.views[ item ] = SmoothButton( evt.c1, 166 @ 18 )
			.radius_(2).border_(1).canFocus_(false).font_(evt.font)
			.states_( [ [item.asString, Color.black, Color.white], [item.asString, Color.black, Color.green] ] )
			.action_({ |bt|
				switch( bt.value,
					1, { evt.registerListAdd( item ) },
					0, { evt.registerListRemove( item ) }
				);
			});
	});

	StaticText( evt.c1, 166 @ 18 ).string_( "bassen" ).align_( \center ).font_(evt.font)
		.background_( Color.green(1,0.2) );
	evt.whichLib[ \bassen ].do({ |item|
		evt.views[ item ] = SmoothButton( evt.c1, 166 @ 18 )
			.radius_(2).border_(1).canFocus_(false).font_(evt.font)
			.states_( [ [item.asString, Color.black, Color.white], [item.asString, Color.black, Color.green] ] )
			.action_({ |bt|
				switch( bt.value,
					1, { evt.registerListAdd( item ) },
					0, { evt.registerListRemove( item ) }
				);
			});
	});

	evt.percViews = ();

	StaticText( evt.c1, 166 @ 18 ).string_( "percussie" ).align_( \center ).font_(evt.font)
		.background_( Color.green(1,0.2) );
	~bd.percLib.keys.do({ |item|
		evt.percViews[ item ] = SmoothButton( evt.c1, 166 @ 18 )
			.radius_(2).border_(1).canFocus_(false).font_(evt.font)
			.states_( [ [item.asString, Color.black, Color.white], [item.asString, Color.black, Color.green] ] )
			.action_({ |bt|
				switch( bt.value,
					1, { evt.hitPerc( item, true ) },
					0, { evt.hitPerc( item, false ) }
				);
			});
	});

	// StaticText( evt.c1, 166 @ 18 ).string_( "" ).align_( \center )
	// .background_( Color.white );
	// StaticText( evt.c1, 166 @ 18 ).string_( "" ).align_( \center )
	// .background_( Color.green(1,0.2) );
	// evt.allRegsOn = SmoothButton( evt.c1, 166 @ 18 )
	// .radius_(2).border_(1).canFocus_(false).font_(evt.font)
	// .states_( [ ["alle registers aan", Color.black, Color.white], ["alle registers aan", Color.black, Color.green] ] )
	// .action_({ |bt|
	// 	~bd.registerList(~bd.nameLib.keys);
	// 	{ evt.allRegsOn.value = 0 }.defer(0.2);
	// });
	// evt.allRegsOff = SmoothButton( evt.c1, 166 @ 18 )
	// .radius_(2).border_(1).canFocus_(false).font_(evt.font)
	// .states_( [ ["alle registers uit", Color.black, Color.white], ["alle registers uit", Color.black, Color.green] ] )
	// .action_({ |bt|
	// 	~bd.registerList([]);
	// 	{ evt.allRegsOff.value = 0 }.defer(0.2);
	// });

	setValues = {
		evt.views.keysValuesDo({ |key, vw|
			vw.value = evt.modeSet.includes( key ).binaryValue;
		});
	};
	setPercValues = {
		evt.percViews.keysValuesDo({ |key, vw|
			vw.value = evt.percSet.includes( key ).binaryValue;
		});
	};
	ctrl = SimpleController( ~bd )
		.put( \percSet, { setPercValues.() })
		.put( \modeSet, { setValues.() });

	w.onClose_( { ctrl.remove } );
};

~bd.makeWindow;

);
