% Exercise session 5: channel estimaition and equalization
clear
%% variables
N = 512;
CP = 150;
N_q = 4;
nb_tbs = 100; %number of trainblocks transmitted
fs = 16000;

%impulse response
IRest = matfile('IRest.mat');
h = IRest.h;

%% generate trainblock
L_tb = N/2-1;
L_seq = N_q*L_tb;
seq = randi([0,1], 1, L_seq);
trainblock = qam_mod(seq, N_q);

%% create signal Tx with nb_tbs trainblocks
seq_100 = zeros(1, nb_tbs*L_seq);
for i = 1:nb_tbs
    start_bit = (i-1)*L_seq+1;
    end_bit = start_bit + L_seq - 1;
    seq_100(1, start_bit:end_bit) = seq;
end
Tx = ofdm_mod(seq_100, N, N_q, CP);
Tx = transpose(Tx);

%% send Tx over channel
[simin, nbsecs, fs, sync_pulse] = initparams(Tx, fs);
sim('recplay');
out = simout.signals.values;
% out = fftfilt(h,Tx);

%% reconstruct sent signal
%TODO 1 frame marge nemen op Tx
Rx = alignIO(out, sync_pulse, length(Tx));
Rx = transpose(Rx);
% Rx = out;

%% demodulate Rx and estimate frequency response H
[seq_demod, H_est] = ofdm_demod(Rx, N, N_q, CP, L_seq*nb_tbs, [], trainblock);

%% plot expected result
figure(1);

subplot(211);
plot(h);
xlabel('samples');
title('impulse response in time domain');

y = abs(fft(h));
%y = circshift(y, length(y)/2);
%x = [(-pi) : (2*pi/length(y)) : (pi - 2*pi/length(y))];
subplot(212);
plot( y );
xlabel('frequency');
title('frequency response');

%% plot estimation
figure(2);

y = abs(H_est);
% y = circshift(y, length(y)/2);
% x = [(-pi) : (2*pi/length(y)) : (pi - 2*pi/length(y))];
subplot(212);
plot( y );
xlabel('frequency');
title('frequency response');

subplot(211);
plot( ifft(H_est) );
xlabel('samples');
title('impulse response in time domain');

%% calculate ber

ber = ber(seq_100, seq_demod);
disp ("BER equals " + ber);