%create input
fs = 16000;
t = [0:1/fs:2];
t = t';
sinewave = sin(440*2*pi*t);

%run simulink model
[simin, nbsecs, fs] = initparams(sinewave, fs);
sim('recplay');
out = simout.signals.values;

%soundsc plays and scales (to avoid clipping) the given input vector
soundsc(out,fs); 