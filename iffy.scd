s.boot;

x={SinOsc.ar}.play;

x.free;

(
y={
	var freq,amp,sig;
	freq=LFNoise0.kr(8).range(200,1000);
	amp=LFNoise1.kr(16).range(0.2,1);
	sig=SinOsc.ar(freq)*amp;
}.play;
)

y.free;

SynthDef(
	\iffySynth,
	{
		arg env,sig,out,freq=440,amp=0.2,a=0.1,r=1,pan=0;
		env=EnvGen.kr(Env.perc(a,r,amp),doneAction:2);
		sig=SinOsc.ar(freq,0,env);
		sig=Pan2.ar(sig,pan);
		Out.ar(out,sig)
	}
).add;

z = Synth(\iffySynth,[\a,1,\r,1]);

Tdef(
	\iffyTask,
	{
		var delta;
		loop {
			delta = 2;
			Synth(\iffySynth,[\a,0.1,\r,0.5]);
			delta.yield;
		}
	}
)

Tdef(\iffyTask).play;

~timer=TempoClock(111/60);

Tdef(
	\otherTask,
	{
		var delta;
		loop {
			delta = 2;
			Synth(\iffySynth,[\a,0.1,\r,0.5,\pan,-1]);
			delta.yield;
		}
	}
).clock_(~timer).quant_(4)

Tdef(\otherTask).play;

Tdef(
	\thirdTask,
	{
		var delta;
		loop {
			delta = 3;
			Synth(\iffySynth,[\freq,220,\a,0.1,\r,0.5,\pan,1]);
			delta.yield;
		}
	}
).clock_(~timer).quant_(4)

Tdef(\thirdTask).play;

~timer.tempo_(200/60);

3.do(
	{
		arg i;
		Tdef(
			i.asSymbol,
			{
				var delta;
				loop {
					delta = 2+i;
					Synth(\iffySynth,[\freq,220*(i+1),\a,0.1,\r,0.5,\pan,rrand(-1,1)]);
					delta.yield;
				}
			}
		).clock_(~timer).quant_(4);
		Tdef(i.asSymbol).play
	}
)

3.do({arg i; Tdef(i.asSymbol).stop});

~notes=PatternProxy(Pseq([880,440,220,440,660],inf)).asStream;
~durs=PatternProxy(Pseq([1,4,1,2],inf)).asStream;
~pans=PatternProxy(Pseq([-1,1],inf)).asStream;

Tdef(
	\seqTask,
		{
		var delta;
		loop {
			delta = ~durs.next;
			Synth(\iffySynth,[\freq,~notes.next,\a,0.1,\r,0.5,\pan,~pans.next]);
			delta.yield;
		}
	}
).clock_(~timer).quant_(4)

Tdef(\seqTask).play;

3.do(
	{
		arg i;
		Tdef(
			i.asSymbol,
			{
				var delta;
				loop {
					delta = ~durs.next;
					Synth(\iffySynth,[\freq,~notes.next,\a,0.1,\r,0.5,\pan,~pans.next]);
					delta.yield;
				}
			}
		).clock_(~timer).quant_(4);
		Tdef(i.asSymbol).play
	}
)

3.do({arg i; Tdef(i.asSymbol).stop});

SynthDef(
	\0,
	{
		arg env,sig,out,freq=440,amp=0.2,a=0.1,r=1,pan=0,pw=0.5;
		env=EnvGen.kr(Env.perc(a,r,amp),doneAction:2);
		sig=Pulse.ar(freq,pw,env);
		sig=Pan2.ar(sig,pan);
		Out.ar(out,sig)
	}
).add;

SynthDef(
	\1,
	{
		arg env,sig,out,freq=440,amp=0.2,a=0.1,r=1,pan=0;
		env=EnvGen.kr(Env.perc(a,r,amp),doneAction:2);
		sig=LFTri.ar(freq,0,env);
		sig=Pan2.ar(sig,pan);
		Out.ar(out,sig)
	}
).add;

SynthDef(
	\2,
	{
		arg env,sig,out,freq=440,amp=0.2,a=0.1,r=1,pan=0;
		env=EnvGen.kr(Env.perc(a,r,amp),doneAction:2);
		sig=LFSaw.ar(freq,0,env);
		sig=Pan2.ar(sig,pan);
		Out.ar(out,sig)
	}
).add;

SynthDef(
	\3,
	{
		arg env,sig,out,freq=440,amp=0.2,a=0.1,r=1,pan=0;
		env=EnvGen.kr(Env.perc(a,r,amp),doneAction:2);
		sig=SinOsc.ar(freq,0,env);
		sig=Pan2.ar(sig,pan);
		Out.ar(out,sig)
	}
).add;

3.do(
	{
		arg i;
		Tdef(
			i.asSymbol,
			{
				var delta;
				loop {
					delta = ~durs.next;
					Synth(i.asSymbol,[\freq,~notes.next,\a,0.1,\r,0.5,\pan,~pans.next]);
					delta.yield;
				}
			}
		).clock_(~timer).quant_(4);
		Tdef(i.asSymbol).play
	}
)

3.do({arg i; Tdef(i.asSymbol).stop});