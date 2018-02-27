

b = Buffer.alloc(s,3*44100,2);

b.read("/Users/Robert/---data---/Audio/projecten-a/Voor de Jacht/Doc/Reh_tot.wav");
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Audio/156009__hdvideoguy__m1carbine-02b.wav");
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Audio/156009__hdvideoguy__m1carbine-02c.wav");
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Audio/52357__trip2000__gun-shot.aif");
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Audio/187677__qubodup__m16-rifle-shots.wav");
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Audio/Jachthoorn/huehnerduo.wav");
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Jachtmuseum/Cornure Jagdsignale 1-part1.wav")
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Jachtmuseum/Echo Fanfares-part1.wav")
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Jachtmuseum/Endenhout Bassets-part1.wav")
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Jachtmuseum/LPF4697 Trompes de Chasses Didactiques 1A-part1.wav")
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Jachtmuseum/Phonola LP 7015 Die Jagd mit dem Hirschruf A-part1.wav")
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Jachtmuseum/Phonola LP 7015 Die Jagd mit dem Hirschruf A-part2.wav")
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Jachtmuseum/Phonola LP 7015 Die Jagd mit dem Hirschruf B-part1.wav")
b.read(	"/Users/Robert/---data---/Audio/projecten-a/De Jacht/Jachtmuseum/Tierstimmen im Wald-part1.wav")
b.read("/Users/Robert/---data---/Audio/projecten-a/De Jacht/Jachtmuseum/Vogue CLVLX 124-30 Fanfares et Venerie A-part1.wav")

b.free;
b = Buffer.read(s,"/Users/Robert/---data---/Audio/projecten-a/De Jacht/Audio/Soundsnap/Shotgun_Shot_02_Distant_Fienup_002.wav");

(
Dialog.openPanel({
	arg file;
	b.free;
	b = Buffer.read(s,file);
	("Chosen file:"+file).postln;
	~clock = TempoClock().permanent_(true);
	~clock.tempo = 1;
});
)


/*
Interessante combis constante stretch (NB pRation is 0-4 for PitchShift and cps for FreqShift
1. FreqShift met arg -10000 of -15000
2. zonder pitchshift of freqshift, hoge (0.01) én lage (0.1) resolutie met wobbly rate
3. verschillende stretch waardes
*/


// constant stretch 1
(
~clock = TempoClock().permanent_(true);
~clock.tempo = 1;

SynthDef(\play,{
	arg rate = 1, gate = 1, start = 0, buf, dir = 1, att = 0.5, rel = 0.5, amp = 1, pRatio = 1;
	var sig;
	sig = PlayBuf.ar(2, buf, rate * dir, loop:0, startPos: start) * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	sig = PitchShift.ar(sig, windowSize: 0.02, pitchRatio: pRatio);
	// sig = FreqShift.ar(sig, pRatio);
	Out.ar(0,amp*sig!2)
}).add;
)
(
~stretch = 1; // stretch factor
// ~pRatio = [0,-1500,-2000,-2500].choose;
~pRatio = 2;
("pRatio:"+~pRatio).postln;
p = Pbind(
	\instrument, \play,
	\buf, b,
	// \dur,  Pwhite(0.1,0.12),
	\dur,  Pwhite(0.05,0.055),
	// \pRatio, Pstep(Pwhite(0.6,1.4),Pwhite(1,2)*Pkey(\dur)),
	\pRatio, ~pRatio,
	\legato, 1,
	// \legato, Pwhite(0.1,0.4),
	\amp, 1,
	\rel, 0.07, \att, 0.05,
	\rate, Pwhite(0.99,1.01), // try with and without this
	\start, Pseries(0,(44100*Pkey(\dur)) / ~stretch,inf),
).play(~clock)
)

p.stop


/*
Interessante combis variable stretch:
1. FreqShift met arg -10000 of -15000

*/
(
~freq = 500;
p = Pbind(
	\instrument, \play,
	\buf, b,
	\dur, 1/~freq,
	\legato, 1,
	\att, 0.1, \rel, 0.1, // vary for more smooth or more agressive
	\amp, 2,
	\n, Pn( Pseries(~freq,2,4.5*~freq) ++ Pseq([10*~freq], 2*~freq) ++ Pseries(10*~freq,-2,4.5*~freq) ++ Pseq([~freq], 2*~freq) ),
	\sign, Pstep(Prand([1], 3),3)++Pstep(Prand([-1,1], inf).trace(prefix: "dir "),Pwhite(2,5).trace(prefix: "stepdur ")) ,
	// \sign, 1,
	// \pRatio, -10000,
	\rate, Pwhite(0.95,1.05), // try with and without this
	\start, Pseries(0,Pkey(\sign)*44100/Pkey(\n),inf),
	\startSec, (Pkey(\start) / 44100).round(0.1)
	).play(~clock)
// ).trace(\startSec, prefix: "b ").play(~clock)
);


(
{
	inf.do {
		51.do { |i| ~clock.tempo = 1 - (i/60); ~clock.tempo.round(0.01).postln; 0.1.wait };
		1.do { 5.wait };
		51.do { |i| ~clock.tempo = 10/60 + (i/60); ~clock.tempo.round(0.01).postln; 0.1.wait };
		1.do { 5.wait }
	}
}.fork
)






(
// play with rnd, overlap + grainSize for taste
~granulator = { |bufnum, rate = 1, freqScale=1, grainSize=0.2, overlaps=4, rnd=0.1|
	Pan2.ar(
		Warp1.ar(
			bufnum.numChannels,
			bufnum,
			LFSaw.kr(BufDur.kr(bufnum).reciprocal * rate,1,0.5,0.5),
			freqScale,
			grainSize,
			-1, overlaps, rnd);
	)
}.play(args: [\bufnum, b]);
)


(
var w,f;

w = Window("warp", Rect(400,400,300,125));
w.view.background_(Color.rand);
f = w.addFlowLayout;

EZSlider(w, 280@20, "rate", [0.1,4],  {|sl| ~granulator.set(\rate, sl.value) }, 1);
EZSlider(w, 280@20, "freqScale", [0.1,4],  {|sl| ~granulator.set(\freqScale, sl.value) }, 1);
EZSlider(w, 280@20, "grainSize", [0.01,1],  {|sl| ~granulator.set(\grainSize, sl.value) }, 0.2);
EZSlider(w, 280@20, "overlaps", [1,8,\lin,1],  {|sl| ~granulator.set(\overlaps, sl.value) }, 4);
EZSlider(w, 280@20, "rnd", \unipolar,  {|sl| ~granulator.set(\rnd, sl.value) }, 0.1);

w.front;
)



FreqShift
WaveLoss
WarpIn, WarpZ


(
b.free;
b = Buffer.alloc(s,5*44100,2);
b.read("/Users/Robert/---data---/Audio/workshop samples/v pr reagan lybia.aif");
// b.read("/Users/Robert/---data---/Audio/projecten-a/Absence/Luchtalarm/Audio/luchalarm-aanzwel.aif");

SynthDef(\warp2, {
	arg buffer, rate = 0.5;
    var pointer = Phasor.ar(0, rate*SampleDur.ir/BufDur.ir(buffer));
    var out = Warp1.ar(2, buffer, pointer, 1, 0.2, -1, 8, 0.5, 4);
    Out.ar(0, out!2);
}).add;
)
x = Synth(\warp2, [\buffer, b,\rate,0.2])
x.free





(
b.free;
b = Buffer.alloc(s,5*44100,2);
b.read("/Users/Robert/---data---/Audio/workshop samples/v pr reagan lybia.aif");

SynthDef(\warp, {
	arg buffer, rate = 0.5;
    var pointer = Phasor.ar(0, rate*SampleDur.ir/BufDur.ir(buffer));
    var out = Warp1.ar(2, buffer, pointer, 1, 0.2, -1, 8, 0.5, 4);
    Out.ar(0, out);
}).add;
)
x = Synth(\warp, [\buffer, b,\rate,1.9])
x.free






