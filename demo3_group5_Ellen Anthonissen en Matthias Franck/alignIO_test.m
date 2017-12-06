%% variables
fs = 16000;
N = 512;
N_q = 6;
Lt = 5;
Ld = 7;
L = ceil(N/2);

%% generate trainblock
L_tb = N/2-1;
L_seq = N_q*L_tb;
seq = randi([0,1], 1, L_seq);
trainblock = qam_mod(seq, N_q);

%% create transmitted signal
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
                            imagetobitstream('image.bmp');
ofdmStream = ofdm_mod(bitStream', N, N_q, L, ...
                            [], trainblock, Lt, Ld)  ;
L_signal = length(ofdmStream);                        
[simin, nbsecs, fs, sync_pulse] = initparams(ofdmStream, fs);
                        
subplot(311);
plot(simin(:,1));
title('sent signal');

%% send over channel (introduce delay)
sim('recplay');
out = simout.signals.values;
% out = circshift(simin(:,1), 6000); %to test, create a delay of 50 samples
% out = [out; zeros(112,1)];

subplot(312);
plot(out);
title('received signal');

%% align output based on synchronization pulse
Rx = alignIO(out,sync_pulse, L_signal);
Rx = transpose(Rx);

subplot(313);
plot(Rx);
title('reconstructed signal');

%% BER
% dit is gewoon om eens te testen, niet zo logisch allemaal
ber_align = abs(mean(ofdmStream - Rx));
disp("mean of difference equals " + ber_align);
figure(2)
delta = ofdmStream - Rx;
subplot(211);
plot(ofdmStream);
subplot(212);
plot(Rx);