fs = 16000;
t = [0:1/fs:2];
t = t';

%define input signal
impulse = zeros(length(t),1);
impulse(1,1) = 500;
%impulse(length(t), 1) = 500;

%make output
[simin, nbsecs, fs] = initparams(impulse, fs);
sim('recplay');
out = simout.signals.values;
%soundsc(out,fs);

%plot played and recorded signal
figure(1);

subplot(411);
plot(simin);
xlabel('samples');
title('input signal in time domain');

subplot(412);
plot(out);
xlabel('samples');
title('impulse response in time domain');

sample_start = 32000;
sample_end = 37000;

subplot(413);
plot(out);
axis([sample_start sample_end -0.1 0.1]);
xlabel('samples');
title('impulse response in time domain');

%calculate and plot magnitude response
subplot(414);
out_cropped = out(sample_start:sample_end,1);
fourrier = abs(fft(out_cropped));
dF = fs/length(out_cropped);
f = -fs/2:dF:fs/2-dF;
plot(f,10*log10(fourrier)); %nog delen door length(out)?
xlabel('Frequency (in hertz)');
title('Magnitude Response');