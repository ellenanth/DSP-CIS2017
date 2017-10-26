%modulate the given sequence seq to a N_q-bit QAM
%N_q is maximaal 6
function [qam_seq] = qam_mod(seq, N_q)
    %nullen bijplakken totdat length(seq) een veelvoud is van N_q
    nb_zeros = mod(N_q - mod(length(seq),N_q), N_q);
    seq = [seq, zeros(1, nb_zeros)];
    
    M = 2^N_q;
    X = zeros(1,length(seq)/N_q);
    for i=1:length(X)
        start = i*N_q - (N_q - 1);
        end_bit = start+N_q-1;
        X(1,i) = bi2de(seq(1,start:end_bit));
    end
    qam_seq = qammod(X,M);
end