% Exercise session 6: transmitting an image
%% variables
N = 512;
N_q = 6;

%% generate trainblock
L_tb = N/2-1;
L_seq = N_q*L_tb;
seq = randi([0,1], 1, L_seq);
trainblock = qam_mod(seq, N_q);

%% generate QAMstream of image
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
    imagetobitstream('image.bmp');
qamStream = qam_mod(bitStream, N_q);

