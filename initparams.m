%toplay is a vector that contains the samples of an audio signal,
%fs is the sampling frequency at which the playback/recording must operate
%simin contains 2s (=fs*2) of silence at beginning and 1s at the end and
%the given toplay vector in between
function [simin,nbsecs,fs] = initparams(toplay,fs)
    toplay = toplay/max(max(toplay));
    simin = [ zeros(fs*2,2) ; toplay,toplay ; zeros(fs,2) ];
    nbsecs = size(simin,1)/fs;
end