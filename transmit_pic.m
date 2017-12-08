% Exercise session 6: transmitting an image
%% variables
fs = 16000;
N = 512;
N_q = 4;
Lt = 20;
Ld = 30;
L = ceil(N/2);
%BWusage = 70;

%% settings
%OOK_on = true;
simulation = true;

%% generate trainblock
L_tb = N/2-1;
L_seq = N_q*L_tb;
seq = randi([0,1], 1, L_seq);
trainblock = qam_mod(seq, N_q);


%% generate OFDM stream of image
% create ofdm_Stream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
                            imagetobitstream('image.bmp');  

ofdmStream = ofdm_mod(bitStream', N, N_q, L, ...
                            [], trainblock, Lt, Ld);

if simulation
    [simin, nbsecs, fs, sync_pulse] = initparams(ofdmStream, fs);
    test = simin(:,1);
    Rx = alignIO(test, sync_pulse, length(ofdmStream));
end

%% demodulate OFDM stream to bitstream
nbsecs = nbsecs - 0.5 - 2 - 2 - 1 ;
[seq_demod, channel_est] = ofdm_demod(Rx, N, N_q, L, length(bitStream), ...
                                   [], trainblock, Lt, nbsecs);

%% calculate BER
BER_calc = ber(bitStream', seq_demod);
disp("BER is " + BER_calc);