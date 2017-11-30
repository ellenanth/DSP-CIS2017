% Exercise session 6: transmitting an image
%% variables
N = 512;
N_q = 6;
Lt = 5;
Ld = 5;

%% generate trainblock
L_tb = N/2-1;
L_seq = N_q*L_tb;
seq = randi([0,1], 1, L_seq);
trainblock = qam_mod(seq, N_q);

%% generate QAMstream of image
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
    imagetobitstream('image.bmp');
%qamStream = qam_mod(bitStream, N_q);
used_carriers = [1:(N/2-1)];
ofdmStream = ofdm_mod(bitStream', N, N_q, ceil(N/2), ...
    used_carriers, trainblock, Lt, Ld)  ;
