fs = 16000;
t = [0:1/fs:2];
t = t';
sinewave = sin(440*2*pi*t);
[simin, nbsecs, fs] = initparams(sinewave, fs);
sim('recplay');
out = simout.signals.values;
soundsc(out,fs);