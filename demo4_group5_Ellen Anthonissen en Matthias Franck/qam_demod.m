%demodulate the given N_q-QAM sequence seq back to the original sequence
%N_q is maximaal 6
%original_length is needed to cut of padded zeros at the end
function [seq_demod] = qam_demod(seq_mod, N_q, original_length) 
    M = 2^N_q;
    
    seq_1 = qamdemod(seq_mod, M);
    seq_2 = de2bi(seq_1, length(seq_mod)*N_q);
    
    %convert matrix (each row is a binary) to a sequence (all binaries next
    %to each other)
    seq_demod = zeros(1,length(seq_mod)*N_q);
    for i=1:size(seq_2, 1)
        start = i*N_q-N_q+1;
        end_bit = start+N_q-1;
        seq_demod(1, start:end_bit) = seq_2(i,1:N_q);
    end
    
    %nullen wegdoen om terug orignele lengte te krijgen
    seq_demod = seq_demod(1,1:original_length);
end