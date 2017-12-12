% Exercise session 6: transmitting an image
%% variables
fs = 16000;
N = 512;
N_q = 4;
Lt = 20;
L = ceil(N/2);
BWusage = 70;

%% settings
OOK_on = true;
simulation = false;

%% generate trainblock
L_tb = N/2-1;
L_seq = N_q*L_tb;
seq = randi([0,1], 1, L_seq);
trainblock = qam_mod(seq, N_q);

%% define used carriers if OOK is on
if OOK_on && ~simulation
    % create a dummy ofdmStream
    dummy_ofdmStream = ofdm_mod([1], N, N_q, L, [], trainblock, 5);
    % send dummy ofdmStream over channel
    [simin, nbsecs, fs, sync_pulse] = initparams(dummy_ofdmStream, fs);
    sim('recplay');
    out = simout.signals.values;
    % reconstruct sent signal
    dummy_Rx = alignIO(out, sync_pulse, length(dummy_ofdmStream));
    dummy_Rx = transpose(dummy_Rx);
    [~, channel_est] = ofdm_demod(dummy_Rx, N, N_q, L, 1, ...
                                                [], trainblock, 5, 1);
    %find 'BWusage' percent best carriers
    H_abs = abs(channel_est(2:(N/2), 1));
    nb_used_carriers = round((N/2-1)*(BWusage/100));
    used_carriers = zeros(1,nb_used_carriers);
    for i = 1:nb_used_carriers
        [~,index] = max(H_abs);
        H_abs(index,1) = 0;
        used_carriers(1,i) = index;
    end
else
    used_carriers = [1:(N/2-1)];
end

%% generate OFDM stream of image
% create ofdm_Stream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
                            imagetobitstream('image.bmp');  

ofdmStream = ofdm_mod(bitStream', N, N_q, L, ...
                            [], trainblock, Lt);

if simulation
    [simin, nbsecs, fs, sync_pulse] = initparams(ofdmStream, fs);
    test = simin(:,1);
    Rx = alignIO(test, sync_pulse, length(ofdmStream));o
else
    % send ofdmStream over channel
    [simin, nbsecs, fs, sync_pulse] = initparams(ofdmStream, fs);
    sim('recplay');
    out = simout.signals.values;
    % reconstruct sent signal
    Rx = alignIO(out, sync_pulse, length(ofdmStream));
    Rx = transpose(Rx);
end

%% demodulate OFDM stream to bitstream
nbsecs = nbsecs - 0.5 - 2 - 2 - 1 ;
[seq_demod, channel_est] = ofdm_demod(Rx, N, N_q, L, length(bitStream), ...
                                   [], trainblock, Lt, nbsecs);

%% calculate BER
BER_calc = ber(bitStream', seq_demod);
disp("BER is " + BER_calc);