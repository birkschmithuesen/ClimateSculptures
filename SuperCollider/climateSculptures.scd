
s.meter;

(
////////////////////////////////
// INITIALIZE STUFF
////////////////////////////////

// initialize the OSC Bridge to TD
~oscbridge = OSCBridge.new("127.0.0.1", 10000);

// intializing the OSC Bridge from TD
n = NetAddr("127.0.0.1", nil); //local machine


////////////////////////////////
// CREATE OSC DEFs
////////////////////////////////

// test def
OSCdef.new(\values, {
	arg msg;
	msg[1].postln;
	// CHOOSE Synth: x, y, z:
	x.set(\t_gate, msg[1]);
},
'year',
n
);


////////////////////////////////
// CREATE SYNTHs
////////////////////////////////

x = {
	arg t_gate=0;
	var freq = 3000, rq= 0.002, amp = 0.2, reverb_mix = 0.3, reverb_size = 0.5, env, sig, env_vis;
	env = EnvGen.ar(Env.new([0,1,1,0], [0.01,0.01, 0.02], [1,-1,-1]), t_gate, doneAction: 0);
	env_vis = EnvGen.ar(Env.new([0,1,0], [0.1, 0], [1,-1,-1]), t_gate, doneAction: 0);
	~oscbridge.sendSignal("/test", env_vis);
	sig = SinOsc.ar(freq * {ExpRand(0.98, 1.02)}!20) * env * amp;
	//sig = Pan2.ar(sig);
	sig = FreeVerb.ar(sig, reverb_mix, reverb_size);
}.play;



)

