%initialize parameters before using the simulink model
%toplay is a column vector that contains the samples of an audio signal,
%fs is the sampling frequency at which the playback/recording must operate
%simin contains 2s (=fs*2) of silence at beginning and 1s at the end and
%the given toplay vector in between
function [simin,nbsecs,fs] = initparams(toplay,fs)
    %make sure the values of toplay are in the interval [-1,1] to avoid
    %clipping (scale each value with the maximum absolute value)
    toplay = toplay/max(max(abs(toplay)));
    
    %construct simin with:
    % 2 seconds of silence at the begin
    % the samples of the given audio signal toplay
    % 1 second of silence at the end
    % After synchronization pulse 2 seconds of 'silence'. Can be addepted
    % in function of the impulse respponse
    synchronization_pulse = [1, 1; zeros(fs*2,2)];
    simin = [ zeros(fs*2,2) ; synchronization_pulse ; toplay,toplay ; zeros(fs,2) ];
    nbsecs = size(simin,1)/fs;
end