function [] = visualize_demod(seq_demod, frequency_response, seconds, seconds_update)
    figure(1)
    
    %estimated time_domain channel impulse response
    subplot(2,2,1);
    plot(ifft(frequency_response));
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
    plot(abs(frequency_response));
    title("Channel in frequency domain");

    %received image
    subplot(2,2,4);
    image_received = bitstreamtoimage(seq_demod', imageSize, bitsPerPixel);
    colormap(colorMap); image(image_received); axis image; 
    title("Received image after " + seconds + " seconds"); drawnow;
    
    pause(seconds_update);
end