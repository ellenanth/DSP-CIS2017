% Exercise session 4: DMT-OFDM transmission scheme
clear;
%% variables

% User-defined parameters
P = 100;
N_q = 4;
SNR = 5;
L_prefix = 20;  %length of the cyclic prefix (should be longer than L+1)
L = 10;         %L+1 is the length of the impulse response
scaling_on = false;
add_noise = true;
bit_loading_on = true;

%provided impulse response of the channel
%impulse_response = randi([0,50], 1, L+1);
impulse_response = [1000 950 950 700 400 300 200 100 50 25 10];
%impulse_response = rand(1,L+1);
%impulse_response = [1,zeros(1,L)];
%impulse_response = ones(1,L+1);
%% calculations
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
    imagetobitstream('image.bmp');

% OFDM modulation
ofdmStream = ofdm_mod(bitStream', P, N_q, L_prefix, ...
    fft(impulse_response), bit_loading_on);

% Channel
rxOfdmStream = fftfilt(impulse_response, ofdmStream);
if add_noise
    rxOfdmStream = awgn(rxOfdmStream, SNR);
end

% OFDM demodulation
rxBitStream = ofdm_demod(rxOfdmStream, P, N_q, L_prefix, ...
    length(bitStream), fft(impulse_response'), scaling_on);

% Compute BER
berTransmission = ber(bitStream',rxBitStream);
disp ("BER equals " + berTransmission);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream', imageSize, bitsPerPixel);

% Plot images
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
