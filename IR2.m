%initialize parameters
fs = 16000;
t = [0:1/fs:2];
t = t';

%create signal
sig = sin(400*2*pi*t);
sig = awgn(sig,100); %met witte ruis

%create output
[simin, nbsecs, fs] = initparams(sig, fs);
sim('recplay');
out = simout.signals.values;

% %plot recorded signal
% plot(out);
% 
% %create toeplitz
% simin(1:1000,1); %input
% out(1:80001); %output
% h = zeros(80001,1);
% 
% x_matrix = toeplitz(simin(1000:end,1)',fliplr(simin(1:1000,1)'));

%create system of equations
k = 38000;
K = 8000;
L = 1000;
x_matrix = toeplitz(simin(k:k+K, 1), fliplr(simin(k-L:k,1))');
y = out(k:k+K,1);

%solve system Ax=b
h = x_matrix\y;

%plot inputs and outputs
figure(1);

subplot(211);
plot(h);
%axis([sample_start sample_end -0.01 0.01]);
xlabel('samples');
title('impulse response in time domain');

%calculate and plot magnitude response
subplot(212);
%out_cropped = out(sample_start:sample_end,1);
fourrier = abs(fft(h));
dF = fs/length(h);
f = -fs/2:dF:fs/2-dF;
plot(f,10*log10(fourrier)); %nog delen door length(out)?
xlabel('Frequency (in hertz)');
title('Magnitude Response');

