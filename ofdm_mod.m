%modulate the given sequence seq to an OFDM sequence
%parameters: 
%seq = the sequence of bits to modulate
%N = length of each frame in a packet, must be even
%N_q: 2^N_q is the constellation size for the QAM modulation, max. 6
%L = length of cyclic prefix, should be way smaller than N
%used carriers = row vector with indices of the used carrier frequencies
function [ofdm_seq] = ofdm_mod(seq, N, N_q, L, ...
    used_carriers)    

    %check if N is even
    if mod(N,2) ~= 0
        error("N must be even");
    end

    %the number of data bits in one frame
    if ~exist('used_carriers', 'var')
        used_carriers = [1:(N/2-1)];
    end
    nb_data = length(used_carriers);

    %QAM-modulation
    QAM_seq = qam_mod(seq, N_q);  
    
    % define P as number of frames in a packet
    P = ceil(length(QAM_seq)/(nb_data));
    
    % padding with zeros to fit data in packet
    nb_padding_qam = P*(nb_data) - length(QAM_seq);
    padding_seq = qam_mod(zeros(1, nb_padding_qam*N_q), N_q);
    QAM_seq = [QAM_seq, padding_seq];
    
    %fill each frame in the packet
    packet = zeros(N, P);
    for i_P = 1:P    
        %fill in QAM signals while keeping zeros on DC and Nyquist
        %frequencies, also keep zeros on non-used carrier frequencies
        start_QAM = (i_P-1) * nb_data;
        for i_data = 1:nb_data
            packet(used_carriers(i_data)+1, i_P) = QAM_seq(start_QAM + i_data);
            packet(N-used_carriers(i_data)+1, i_P) = conj( QAM_seq(start_QAM + i_data) );
        end
        
        %IFFT per frame
        packet(:,i_P) = ifft(packet(:,i_P));
    end
    
    %expand the packet with a cyclic prefix of length L
    packet = [ packet((N-L+1):N, :) ; packet];
    
    for i_P = 1:P
        %parallel to serial conversion
        start_pos = (i_P-1)*(N+L) + 1;
        end_pos = start_pos + (N+L) - 1;
        ofdm_seq(1, start_pos:end_pos) = packet(:,i_P)';
    end
end