// MIDI setup -----------------------------------------------
(
~bd = ~bd ? EM(); // functions in an EM always have the environment as first argument

~bd.realOrgan = { |evt, device, name|
	if( MIDIClient.destinations.size == 0 ) {
		MIDIClient.init;
	};
	evt.m = nil;
	evt.m = MIDIOut(0,
		MIDIClient.destinations.detect({ |item|
			var test1 = true, test2 = true;
			if( device.notNil ) {
				test1 = item.device.find( device ).notNil;
			};
			if( name.notNil ) {
				test2 = item.name.find( name ).notNil;
			};
			test1 && test2;
		}) !? _.uid ?? { "device % / % not found\n".postf( device, name ); 0 };
	).latency_(0.0);
};

)
