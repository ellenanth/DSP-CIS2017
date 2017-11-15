% Exercise session 4: DMT-OFDM transmission scheme

% User-defined parameters
P = 100;
N_q = 4;
%SNR = 35;
L_prefix = 20;  %length of the cyclic prefix
L = 10;         %L+1 is the length of the impulse response
%impulse_response = randi([0,50], 1, L+1);
%impulse_response = [1000 950 950 700 400 300 200 100 50 25 10];
%impulse_respons = rand(1,L+1);
impulse_response = [1,zeros(1,L)];
%impulse_response = ones(1,L+1);

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
    imagetobitstream('image.bmp');

% OFDM modulation
ofdmStream = ofdm_mod(bitStream', P, N_q, L_prefix);

% Channel
%rxOfdmStream = ofdmStream;
rxOfdmStream = fftfilt(impulse_response, ofdmStream);
%rxOfdmStream = awgn(rxOfdmStream, SNR);

% OFDM demodulation
rxBitStream = ofdm_demod(rxOfdmStream, P, N_q, L_prefix, length(bitStream));

% Compute BER
berTransmission = ber(bitStream',rxBitStream);
disp ("BER equals " + berTransmission);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream', imageSize, bitsPerPixel);

% Plot images
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
