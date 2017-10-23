fs = 16000;
t = [0:1/fs:2];
t = t';
sig = sin(400*2*pi*t); ;
%sig = awgn(sig,100); %met witte ruis
[simin, nbsecs, fs] = initparams(sig, fs);
sim('recplay');
out = simout.signals.values;
plot(out);

simin(1:1000,1) %input
out(1:80001) %output
h = zeros(80001,1);

x_matrix = toeplitz(simin(1000:end,1)',fliplr(simin(1:1000,1)'));