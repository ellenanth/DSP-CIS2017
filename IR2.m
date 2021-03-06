%% parameters
%initialize parameters
fs = 16000;

IR_size;
temp = matfile('IRest.mat');
L = temp.N_IR;

t = [0:1/fs:2];
t = t';

%create signal
sig = awgn(0*t,100); %WGN-signal

%% simulink
%create output
[simin, nbsecs, fs] = initparams(sig, fs);
sim('recplay');
out = simout.signals.values;

%% synchronization
%shift 'out' to the left to cancel out channel latency
[Y, I] = max(out);
limit_value = 1/20 * Y;

%start looking for the start of the signal at the sample when
%we started transmitting and scan to the right
i = 2 * fs;
while (out(i,1) < limit_value)
    i = i + 1;
end
sample_start = i;

shift = sample_start - 2*fs;
% shift = shift - 10; %take some margin

out = out(shift:length(out), 1);
simin = simin(1:(length(simin)-shift), 1);
%% create system of equations
k = 38000;
K = 8000;
%L = 1000;
x_matrix = toeplitz(simin(k:k+K, 1), fliplr(simin(k-L:k,1))');
y = out(k:k+K,1);

%% solve system Ax=b
h = x_matrix\y;

%% save h
save('IRest.mat','h');

%% plot inputs and outputs
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

