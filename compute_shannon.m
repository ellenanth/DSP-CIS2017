fs = 16000;
t = [0:1/fs:2];
t = t';
sig = sin(0.001*2*pi*t); %met DC-component, niet geschaald

[simin, nbsecs, fs] = initparams(sig, fs);
sim('recplay');
out = simout.signals.values;

[Pxx_noise,F] = periodogram(out(:,1),[],length(simin(:,1)),fs);
Pxx_noise = 10*log10(Pxx_noise);

sig = sin(440*2*pi*t);

[simin, nbsecs, fs] = initparams(sig, fs);
sim('recplay');
out = simout.signals.values;

[Pxx_signalandnoise,F] = periodogram(out(:,1),[],length(simin(:,1)),fs);
Pxx_signalandnoise = 10*log10(Pxx_signalandnoise);

Pxx = Pxx_signalandnoise - Pxx_noise;

syms k
N = length(out(:,1))/2;
C = fs/(2*N)*symsum(log2(1+(Pxx(k)/Pxx_noise(k)),1,N))