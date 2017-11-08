%demodulate the given OFDM sequence seq back to the original sequence
%N_q is maximaal 6
%original_length is needed to cut of padded zeros at the end
%L = length of cyclic prefix
function [seq_demod] = ofdm_demod(seq_mod, P, N_q, L, original_length) 
    %serial-to-parallel conversion
    N = (length(seq_mod))/P - L;
    packet = zeros(N+L,P);
    QAM_seq = zeros(1, (N/2-1)*P );

    for i_P = 1:P
        %fill frames in packet
        start_pos = (i_P-1)*(N+L) + 1;
        end_pos = start_pos + (N+L) - 1;
        packet(:,i_P) = seq_mod(1, start_pos:end_pos)';
    end
    
    %cut off cyclic prefix
    packet = packet((L+1):N+L, :);
    
    for i_P = 1:P
        % FFT operation
        packet(:,i_P) = fft(packet(:,i_P));
        
        % retrieve QAM sequence
        start_QAM = (i_P-1) * (N/2-1) + 1;
        end_QAM = start_QAM + N/2 - 2;
        QAM_seq(1, start_QAM:end_QAM) = transpose( packet(2:(N/2), i_P) ); 
    end
    

    % demodulate QAM sequence
    seq_demod = qam_demod(QAM_seq, N_q, original_length); 
    
    %nullen wegdoen om terug orignele lengte te krijgen
    %TODO kan dit weg?
    seq_demod = seq_demod(1,1:original_length);
end