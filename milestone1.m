%initialize parameters
fs = 16000;
t = [0:1/fs:2];
t = t';
dftsize = 512;
sample_start = 36000;
sample_end = 40000;
impulse = zeros(length(t),1);
impulse(1,1) = 500;

%create signal
sig = sin(400*2*pi*t);
sig = awgn(sig,100); %met witte ruis

%create output of sine input
[simin, nbsecs, fs] = initparams(sig, fs);
sim('recplay');
out = simout.signals.values;

%draw spectogram
[S_sig,F_sig,T_sig,P_sig] = spectrogram(simin(:,1) , dftsize, dftsize/2, dftsize, fs,'yaxis');
[S_out,F_out,T_out,P_out] = spectrogram(out(:,1) , dftsize, dftsize/2, dftsize, fs,'yaxis');

figure(1)
subplot(211)
surf(T_sig,F_sig,10*log10(P_sig),'edgecolor','none'); 
axis tight;
view(0,90); 
set(gca,'clim',[-80 -30]); 
xlabel('Time (Seconds)'); 
ylabel('Frequnency (Hz)');
title('input signal');

subplot(212)
surf(T_out,F_out,10*log10(P_out),'edgecolor','none'); 
axis tight;
view(0,90); 
set(gca,'clim',[-80 -30]); 
xlabel('Time (Seconds)'); 
ylabel('Frequnency (Hz)');
title('recorded signal');

%draw PSD
figure(2)
subplot(211)
[Pxx,F] = periodogram(simin(:,1),[],length(simin(:,1)),fs);
plot(F,10*log10(Pxx))
xlabel('Frequnency (Hz)'); 
ylabel('PSD');
title('input signal');

subplot(212)
[Pxx,F] = periodogram(out(:,1),[],length(out(:,1)),fs);
plot(F,10*log10(Pxx))
xlabel('Frequnency (Hz)'); 
ylabel('PSD');
title('recorded signal');

%create system of equations
k = 38000;
K = 8000;
L = 1000;
x_matrix = toeplitz(simin(k:k+K, 1), fliplr(simin(k-L:k,1))');
y = out(k:k+K,1);

%solve system Ax=b
h = x_matrix\y;

%plot inputs and outputs
figure(3);

subplot(211);
plot(h);
%axis([sample_start sample_end -0.01 0.01]);
xlabel('samples');
title('impulse response (IR2) in time domain');

%calculate and plot magnitude response
subplot(212);
%out_cropped = out(sample_start:sample_end,1);
fourrier = abs(fft(h));
dF = fs/length(h);
f = -fs/2:dF:fs/2-dF;
plot(f,10*log10(fourrier)); %nog delen door length(out)?
xlabel('Frequency (in hertz)');
title('Magnitude Response');

%make output of impulse
[simin, nbsecs, fs] = initparams(impulse, fs);
sim('recplay');
out = simout.signals.values;

figure(4);
subplot(211);
plot(out);
axis([sample_start sample_end -0.01 0.01]);
xlabel('samples');
title('impulse response (IR1) in time domain');

%calculate and plot magnitude response
subplot(212);
out_cropped = out(sample_start:sample_end,1);
fourrier = abs(fft(out_cropped));
dF = fs/length(out_cropped);
f = -fs/2:dF:fs/2-dF;
plot(f,10*log10(fourrier)); %nog delen door length(out)?
xlabel('Frequency (in hertz)');
title('Magnitude Response');

sig = awgn(sig,100);