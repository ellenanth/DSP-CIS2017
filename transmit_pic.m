% Exercise session 6: transmitting an image
%% variables
fs = 16000;
N = 512;
N_q = 6;
Lt = 7;
Ld = 15;
L = ceil(N/2);

%% generate trainblock
L_tb = N/2-1;
L_seq = N_q*L_tb;
seq = randi([0,1], 1, L_seq);
trainblock = qam_mod(seq, N_q);

%% generate OFDM stream of image
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
    imagetobitstream('image.bmp');
%qamStream = qam_mod(bitStream, N_q);
ofdmStream = ofdm_mod(bitStream', N, N_q, L, ...
    [], trainblock, Lt, Ld)  ;

%% send ofdmStream over channel
[simin, nbsecs, fs, sync_pulse] = initparams(ofdmStream, fs);
sim('recplay');
out = simout.signals.values;

%% reconstruct sent signal
%TODO 1 frame marge nemen op Tx (!! P is dan niet meer N*(Lt+Ld) !!)
Rx = alignIO(out, sync_pulse, length(ofdmStream));
Rx = transpose(Rx);
% Rx = out;

%% demodulate OFDM stream to bitstream
[seq_demod, channel_est] = ofdm_demod(Rx, N, N_q, L, length(bitStream), ...
                                            [], trainblock, Lt, Ld);
                                        
%% calculate BER
BER_calc = ber(bitStream', seq_demod);
disp("BER is " + BER_calc);
