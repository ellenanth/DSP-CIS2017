%modulate the given sequence seq to a OFDM sequence
%P = total number of frames in a packet
%N = total numbers per frame
%N_q is used for the QAM modulation to construct the frames
function [ofdm_seq] = ofdm_mod(seq, P, N_q)    
    %define nb_zeros_ofdm as total number of zeros to add to the original
    %data so the data fits in P frames of size N and the QAM doesn't need
    %padding anymore as length(seq) is a multiple of N_q
    nb_zeros_qam = mod(N_q - mod(length(seq),N_q), N_q);
    length_seq_qam = (length(seq)+nb_zeros_qam)/N_q;
    N = 2 * ( ceil( length_seq_qam/P ) + 1 );
    length_seq_ofdm = P * (N/2-1) * N_q;
    nb_zeros_ofdm = length_seq_ofdm - length(seq);
    %N = 18; %example for length(seq)=64, N_q = 4, P=2 
    
    %padding the original sequence with zeros at the end
    seq = [seq, zeros(1,nb_zeros_ofdm)];
    
    %QAM-modulation
    QAM_seq = qam_mod(seq, N_q);   
    
    
    %fill each frame
    packet = zeros(N, P);
    end_N = N/2-1;
    for i_P = 1:P
        start_QAM = (i_P-1) * end_N;
        for i_N = 1:end_N
            packet(i_N+1, i_P) = QAM_seq(start_QAM + i_N); %fill in value from QAM
            packet(N-i_N+3, i_P) = conj( QAM_seq(start_QAM + i_N) ); %fill in value from QAM*
        end
        %TODO IFFT per frame
    end
    disp(packet);
    
    %TODO parallel to serial conversion
end