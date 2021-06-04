
s.meter;



(


n = NetAddr("127.0.0.1", nil); //local machine




OSCdef.new(\values, {
	arg msg;
	msg[1].postln;
	// CHOOSE Synth: x, y, z:
	y.set(\t_gate, msg[1]);
},
'year',
n
);


x = {
	arg t_gate=0;
	var freq = 3000, rq= 0.002, amp = 15, reverb_mix = 0.3, reverb_size = 0.8, env, sig;
	env = EnvGen.kr(Env.new([0,1,1,0], [0.01,0.005, 0.02], [1,-1,-1]), t_gate, doneAction: 0);
	sig = WhiteNoise.ar(1) * env * amp;
	sig = BPF.ar(sig, freq, rq);
	sig = Pan2.ar(sig);
	sig = FreeVerb.ar(sig, reverb_mix, reverb_size);
}.play;





y = {
	arg t_gate=0;
	var freq = 3000, rq= 0.002, amp = 0.2, reverb_mix = 0.3, reverb_size = 0.5, env, sig;
	env = EnvGen.kr(Env.new([0,1,1,0], [0.01,0.005, 0.02], [1,-1,-1]), t_gate, doneAction: 0);
	sig = SinOsc.ar(freq * {ExpRand(0.98, 1.02)}!20) * env * amp;
	//sig = Pan2.ar(sig);
	sig = FreeVerb.ar(sig, reverb_mix, reverb_size);
}.play;




x.set(\t_gate,1);






SynthDef.new(\iter2, {
	arg freq=3000, dev=1.02, t_gate=0;
	var sig=0, temp, env, reverb_mix = 0.3, reverb_size = 0.5;
	env = EnvGen.kr(Env.new([0,1,1,0], [0.01,0.005, 0.02], [1,-1,-1]), t_gate, doneAction: 0);
	10.do{
		arg count;
		temp = SinOsc.ar(
			freq
			* {Rand(0, 1).range(dev.reciprocal, dev)}!2
		);
		//temp = temp * LFNoise1.kr({Rand(0.1, 2)}!2).exprange(0.01, 1);
		sig = sig + temp;
	};
	sig = sig * 0.05 * env;
	sig = FreeVerb.ar(sig, reverb_mix, reverb_size);
	Out.ar(0, sig);
}).add;



z = Synth(\iter2, [\freq, 2000, \dev, 1.05, \t_gate, 1]);

)

