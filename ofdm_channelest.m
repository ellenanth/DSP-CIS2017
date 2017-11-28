% Exercise session 5: channel estimaition and equalization
%% variables

N = 512;
N_q = 6;
L_Tx = 100; % L_Tx * N = #frames in ofdm-packet containing trainblock
fs = 16000

%impulse response
IRest = matfile('IRest.mat');
h = IRest.h;

%% generate trainblock
L_tb = N/2-1;
L_seq = N_q*L_tb;
seq = randi([0,1], 1, L_seq);
trainblock = qam_mod(seq, N_q);

%% transmit ofdm-packet with L_Tx trainblocks
seq_100 = zeros(1, L_Tx*L_seq);
for i = 1:L_Tx
    start_bit = (i-1)*L_seq+1;
    end_bit = start_bit + L_seq - 1;
    seq_100(1, start_bit:end_bit) = seq;
end
Tx = ofdm_mod(seq_100,N,N_q,ceil(L_tb/10));
Tx = transpose(Tx);
synchronization_pulse = [1 ; zeros(fs*2,1)];
[simin, nbsecs, fs] = initparams(Tx, fs);
sim('recplay');
out = simout.signals.values;
Rx = alignIO(out,synchronization_pulse);
%Rx = fftfilt(h, Tx);

%% demodulate Rx and estimate frequency response H
%[seq_demod, H_est] = ofdm_demod(Rx, N, N_q, ceil(L_tb/10), L_seq*L_Tx, [], trainblock);
H_est = fft(h);

%% plot expected result
figure(1);

subplot(211);
plot(h);
xlabel('samples');
title('impulse response in time domain');

y = abs(fft(h));
y = circshift(y, length(y)/2);
x = [(-pi) : (2*pi/length(y)) : (pi - 2*pi/length(y))];
subplot(212);
plot( x,y );
xlabel('frequency');
title('frequency response');

%% plot estimation
figure(2);

y = abs(H_est);
y = circshift(y, length(y)/2);
x = [(-pi) : (2*pi/length(y)) : (pi - 2*pi/length(y))];
subplot(212);
plot( x,y );
xlabel('frequency');
title('frequency response');

subplot(211);
plot( ifft(H_est) );
xlabel('samples');
title('impulse response in time domain');

%% calculate ber

%ber = ber(seq_100, seq_demod);
%disp ("BER equals " + ber);