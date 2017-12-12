function [] = visualize_demod(seq_demod, frequency_response, used_carriers, s, delta_s)
    figure(1)
    
    %estimated time_domain channel impulse response
    subplot(2,2,1);
    plot(ifft(frequency_response));
    axis([0 600 -0.02 0.02])
    title("Channel in time domain");

    %transmitted image
    subplot(2,2,2);
    [~, image_expected, colorMap, imageSize, bitsPerPixel] = ...
        imagetobitstream('image.bmp');
    %image_expected = bitstreamtoimage(expected_result, imageSize, bitsPerPixel);
    colormap(colorMap); image(image_expected); axis image; 
    title('Transmitted image'); drawnow;

    %estimated channel frequency response
    subplot(2,2,3);
    N = length(frequency_response);
    for i = 1:(N/2-1)
        if ~ismember(i,used_carriers)
            frequency_response(i+1,1) = 0;
        end
    end
    plot(abs( frequency_response(2:(N/2),1) ));
    axis([0 300 0 0.4])
    title("Channel in frequency domain");

    %received image
    subplot(2,2,4);
    image_received = bitstreamtoimage(seq_demod', imageSize, bitsPerPixel);
    colormap(colorMap); image(image_received); axis image; 
    title("Received image after " + s + " seconds"); drawnow;
    
    pause(delta_s);
end