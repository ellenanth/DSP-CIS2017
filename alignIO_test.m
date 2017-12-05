%% variables
fs = 16000;
N = 512;
N_q = 6;
Lt = 5;
Ld = 7;
L = ceil(N/2);

%% create transmitted signal
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
                            imagetobitstream('image.bmp');
ofdmStream = ofdm_mod(bitStream', N, N_q, L, ...
                            used_carriers, trainblock, Lt, Ld)  ;
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
%TODO dit geeft nog erros om één of andere louche reden, maar ik had efkes
% geen tijd meer om uit te zoeken waarom
% ber_align = ber(bitStream', Rx);
% disp("BER equals " + ber_align);