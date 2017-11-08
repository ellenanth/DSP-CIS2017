%modulate the given sequence seq to a OFDM sequence
%P = total number of frames in a packet
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
    %length_cyclic_prefix = length(cyclic_prefix);
    
    %padding the original sequence with zeros at the end
    seq = [seq, zeros(1,nb_zeros_ofdm)];
    
    %QAM-modulation
    QAM_seq = qam_mod(seq, N_q);     
    
    %fill each frame
    packet = zeros(N, P);
    end_N = N/2-1;
    for i_P = 1:P
        %fill in QAM signals, keep zeros on DC and Nyquist frequencies
        start_QAM = (i_P-1) * end_N;
        for i_N = 1:end_N
            packet(i_N+1, i_P) = QAM_seq(start_QAM + i_N); %fill in value from QAM
            packet(N-i_N+1, i_P) = conj( QAM_seq(start_QAM + i_N) ); %fill in value from QAM*
        end
        
        %IFFT per frame
        packet(:,i_P) = ifft(packet(:,i_P));
        
%         cyclic_matrix = zeros(length_cyclic_prefix,P);
        
        
        %parallel to serial conversion
        start_pos = (i_P-1)*N + 1;
        end_pos = start_pos + N - 1;
        ofdm_seq(1, start_pos:end_pos) = packet(:,i_P)';
    end
end