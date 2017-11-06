%modulate the given QAM sequence seq to a OFDM sequence
%P = total number of frames in a packet
%N_q = N_q used for the QAM of the sequence
function [ofdm_seq] = ofdm_mod_2(QAM_seq, P, N_q)    
    %define nb_zeros_ofdm as total number of zeros that should be added to
    %the original signal and QAM modulated to add to the QAM
    %data so the data fits in P frames of size N
    N = 2 * ( ceil( length(QAM_seq)/P ) + 1 ); %frame size
    after_padding_length = P * (N/2-1); %length of QAM_seq after padding
    nb_zeros_ofdm = (after_padding_length - length(QAM_seq))*N_q;
    
    %padding the original sequence with QAM-modulated zeros at the end
    QAM_seq = [ QAM_seq, qam_mod(zeros(1,nb_zeros_ofdm), N_q) ];
    
    
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
        
        %parallel to serial conversion
        start_pos = (i_P-1)*N + 1;
        end_pos = start_pos + N - 1;
        ofdm_seq(1, start_pos:end_pos) = packet(:,i_P)';
    end
end