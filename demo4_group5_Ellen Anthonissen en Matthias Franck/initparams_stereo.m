%initialize parameters before using the simulink model
%toplay is a column vector that contains the samples of an audio signal,
%fs is the sampling frequency at which the playback/recording must operate
%simin contains 2s (=fs*2) of silence at beginning and 1s at the end and
%the given toplay vector in between
function [simin,nbsecs,fs, sync_pulse] = initparams_stereo(toplay_left, toplay_right,fs)
    %
    if size(toplay_left,1)<size(toplay_left,2)
        toplay_left = transpose(toplay_left);
    end
    if size(toplay_right,1)<size(toplay_right,2)
        toplay_right = transpose(toplay_right);
    end
    
    %make sure the values of toplay are in the interval [-1,1] to avoid
    %clipping (scale each value with the maximum absolute value)
    max_left = max(max(abs(toplay_left)));
    max_right = max(max(abs(toplay_right)));
    max_tot = max(max_left, max_right);
    toplay_left = toplay_left/max_tot;
    toplay_right = toplay_right/max_tot;
    
    %define a synchronization pulse: 0.5s sine wave at 440Hz
    t = [0:1/fs:(0.5-1/fs)];
    t = t';
    sync_pulse = sin(2*pi*400*t);
    %create output
    simin = [ zeros(fs*2,2) ;           %2sec silence at start
              sync_pulse, sync_pulse ;  %sync_pulse
              zeros(fs*2,2);            %2sec silence after sync_pulse
              toplay_left,toplay_right ;%signals
              zeros(fs,2) ];            %1sec silence at end
    nbsecs = size(simin,1)/fs;
end