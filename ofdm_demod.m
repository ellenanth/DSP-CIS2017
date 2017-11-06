%demodulate the given OFDM sequence seq back to the original sequence
%N_q is maximaal 6
%original_length is needed to cut of padded zeros at the end
function [seq_demod] = ofdm_demod(seq_mod, N_q, original_length) 
    %TODO serial-to-parallel conversion
    %TODO FFT operation
    %TODO retrieve QAM sequence
    %TODO demodulate QAM sequence
    
    %nullen wegdoen om terug orignele lengte te krijgen
    seq_demod = seq_demod(1,1:original_length);
end