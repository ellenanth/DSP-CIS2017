%modulate the given sequence seq to a OFDM sequence
%P = total number of frames in a packet
%N = total numbers per frame
%N_q is used for the QAM modulation to construct the frames
function [ofdm_seq] = ofdm_mod(seq, P, N_q)    
    %TODO padding seq with zeros to fit the sizes

    %QAM-modulation
    QAM_seq = qam_mod(seq, N_q);
    
    %TODO define frame size N, N must be even
    N = 18; %example for length(seq)=64, N_q = 4, P=2
    
    %fill each frame
    packet = zeros(N, P);
    end_N = N/2;
    for i_P = 1:P
        for i_N = 2:end_N
            packet(i_N, i_P) = 1; %TODO fill in value from QAM
            packet(N-i_N+2, i_P) = 1; %TODO fill in value from QAM*
        end
        %TODO IFFT per frame
    end
    
    %TODO parallel to serial conversion
end