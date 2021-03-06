% Exercise session 4: DMT-OFDM transmission scheme
%% variables

%impulse response
IRest = matfile('IRest.mat');
impulse_response = IRest.h;

% t = 1:115;
% t = t';
% impulse_response =  exp(-0.1*t) .* sin(t);

% impulse_response = [1;zeros(115,1)]; %ideal channel


% User-defined parameters
N_q = 4;        %2^N_q = constellation size of QAM modulation
            
L = length(impulse_response);         
L_prefix = L+20;  %length of the cyclic prefix (should be longer than L)
                % and significantly shorter than N_frame
N_frame = 6*L_prefix;  %length of each frame in a packet

% % test settings
% scaling_on = true;
% add_noise = true;
% SNR = 80;       %signal to noise ratio of the added noise
% bit_loading_on = false;
%% calculations
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = ...
    imagetobitstream('image.bmp');

% measure channel

% define used carriers
if bit_loading_on
    %TODO define the used carriers correctly based on the PSD of the
    %channel
    used_carriers = [1:(N_frame/2-1)];
else
    %use all cariers
    used_carriers = [1:(N_frame/2-1)];
end

% OFDM modulation
ofdmStream = ofdm_mod(bitStream', N_frame, N_q, L_prefix, used_carriers);

% Channel
rxOfdmStream = fftfilt(impulse_response, ofdmStream);
if add_noise
    rxOfdmStream = awgn(rxOfdmStream, SNR);
end

% OFDM demodulation
rxBitStream = ofdm_demod(rxOfdmStream, N_frame, N_q, L_prefix, ...
    length(bitStream), impulse_response, scaling_on, used_carriers);

% Compute BER
berTransmission = ber(bitStream',rxBitStream);
disp ("BER equals " + berTransmission);

%% create output

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream', imageSize, bitsPerPixel);

% Plot images
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; 
title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; 
title(['Received image']); drawnow;
