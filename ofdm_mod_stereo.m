function [ofdm_seq_a, ofdm_seq_b] = ofdm_mod_stereo(seq, a, b, N, N_q, L, used_carriers)   

%modulate seq 

    %check if N is even
    if mod(N,2) ~= 0
        error("N must be even");
    end
    
    if size(seq,1)>size(seq,2)
        seq = transpose(seq);
    end

    %the number of data bits in one frame
    if ~exist('used_carriers', 'var') || isempty(used_carriers)
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
    end
    
    ofdm_packet_a = [0;a;0;flipud(conj(a))] .* packet;
    ofdm_packet_b = [0;b;0;flipud(conj(b))] .* packet;
    
    %IFFT on each matrix
    ofdm_packet_a = ifft(ofdm_packet_a);
    ofdm_packet_b = ifft(ofdm_packet_b);
    
    %expand each packet with a cyclic prefix of length L
    ofdm_packet_a = [ ofdm_packet_a((N-L+1):N, :) ; ofdm_packet_a];
    ofdm_packet_b = [ ofdm_packet_b((N-L+1):N, :) ; ofdm_packet_b];

    
    for i_P = 1:P
        %parallel to serial conversion
        start_pos = (i_P-1)*(N+L) + 1;
        end_pos = start_pos + (N+L) - 1;
        ofdm_seq_a(1, start_pos:end_pos) = ofdm_packet_a(:,i_P)';
        ofdm_seq_b(1, start_pos:end_pos) = ofdm_packet_b(:,i_P)';
    end

end