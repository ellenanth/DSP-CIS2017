N = 512;
N_q = 3;
L = 256;
impulse_length = N/2-1;
SNR = 15;
fs = 16000;

%% generate trainblock
L_tb = N/2-1;
L_seq = N_q*L_tb;
seq = randi([0,1], 1, L_seq);
trainblock = qam_mod(seq, N_q);

%% estimate channels
% create a dummy ofdmStream
dummy_ofdmStream = ofdm_mod([1], N, N_q, L, [], trainblock, 5);
empty_ofdmStream = ones(1, length(dummy_ofdmStream)) * 0.001;

% test left loudspeaker
% send dummy ofdmStream over channel
[simin, nbsecs, fs, sync_pulse] = ...
    initparams_stereo(dummy_ofdmStream, empty_ofdmStream, fs);
sim('recplay');
out = simout.signals.values;
% reconstruct sent signal
dummy_Rx = alignIO(out, sync_pulse, length(dummy_ofdmStream));
dummy_Rx = transpose(dummy_Rx);
[~, channel_est_mtx_left] = ofdm_demod(dummy_Rx, N, N_q, L, 1, ...
                                            [], trainblock, 5, 1);
H1 = channel_est_mtx_left(:,1);

% test right loudspeaker
% send dummy ofdmStream over channel
[simin, nbsecs, fs, sync_pulse] = ...
    initparams_stereo(empty_ofdmStream, dummy_ofdmStream, fs);
sim('recplay');
out = simout.signals.values;
% reconstruct sent signal
dummy_Rx = alignIO(out, sync_pulse, length(dummy_ofdmStream));
dummy_Rx = transpose(dummy_Rx);
[~, channel_est_mtx_right] = ofdm_demod(dummy_Rx, N, N_q, L, 1, ...
                                            [], trainblock, 5, 1);
H2 = channel_est_mtx_right(:,1);

%% create sequence
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
                            imagetobitstream('image.bmp');  

%% modulate
%impulse response to transfer function (without DC)
% H1 = fft(h1,N);
H1 = [H1(2:N/2,1)];
% H2 = fft(h2,N);
H2 = [H2(2:N/2,1)];

%calculate a and b
a = conj(H1)./ (sqrt(H1.*conj(H1)+H2.*conj(H2)));
b = conj(H2)./ (sqrt(H1.*conj(H1)+H2.*conj(H2)));
% a = ones(N/2-1,1);
% b = zeros(N/2-1,1);

%modulate
%TODO flag voor visualize_on of of
[ofdm_seq_a, ofdm_seq_b] = ofdm_mod_stereo(bitStream,a,b,N, N_q,L, []);

%% transmit over channel
% Rx = fftfilt(h1, ofdm_seq_a,N) + fftfilt(h2, ofdm_seq_b,N);
% Rx = awgn(Rx, SNR);

[simin, nbsecs, fs, sync_pulse] = initparams_stereo(ofdm_seq_a, ofdm_seq_b, fs);
sim('recplay');
out = simout.signals.values;
% reconstruct sent signal
Rx = alignIO(out, sync_pulse, length(ofdm_seq_a));
Rx = transpose(Rx);

%% demod
num = (sqrt(H1 .* conj(H1) + H2 .* conj(H2)));
% num = (sqrt(H2 .* conj(H2)));
% num = H2;
seq_demod = ofdm_demod_stereo(Rx, N, N_q, L, length(bitStream), ...
                            [], num);
                        
%% calculate BER
BER_calc = ber(bitStream', seq_demod);
disp("BER is " + BER_calc);

%% plot H1 and H2
figure(1);
subplot(121);
plot(20*log(abs(H1)));
title("transfer function left [dB]")

subplot(122);
plot(20*log(abs(H2)));
title("transfer function right [dB]")

                        
