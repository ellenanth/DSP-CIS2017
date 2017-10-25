%modulate the given sequence to a N_q-bit QAM
%length(seq)/N_q moet een geheel getal zijn
function [qam_seq] = qam_mod(seq, N_q)
    %nullen bijplakken totdat length(seq) een veelvoud is van N_q
    nb_zeros = N_q - mod(length(seq),N_q);
    seq = [seq, zeros(1, nb_zeros)];
    
    M = 2^N_q;
    X = zeros(1,length(seq)/N_q);
    for i=1:length(X)
        start = i*N_q - (N_q - 1);
        end_bit = start+N_q-1;
        X(1,i) = bi2de(seq(1,start:end_bit));
    end
    X
    qam_seq = qammod(X,M);
end