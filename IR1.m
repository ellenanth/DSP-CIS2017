fs = 16000;
t = [0:1/fs:0.1];
t = t';

%define input signal
impulse = zeros(length(t),1);
impulse(1,1) = 1;

%make output
[simin, nbsecs, fs] = initparams(impulse, fs);
sim('recplay');
out = simout.signals.values;
%soundsc(out,fs);
%plot
subplot(211);
plot(out);
xlabel('samples');
title('impulse response in time domain');

subplot(212);
fourrier = abs(fft(out));
dF = fs/length(out);
f = -fs/2:dF:fs/2-dF;
plot(f,10*log10(fourrier)); %nog delen door length(out)?
xlabel('Frequency (in hertz)');
title('Magnitude Response');

%TODO: ruis tot vlak voor en een stuk na puls wegknippen om 
% een betere kanaalschatting te krijgen

