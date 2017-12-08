%modulate the given sequence seq to an OFDM sequence
%parameters: 
%seq = the sequence of bits to modulate
%N = length of each frame in a packet, must be even
%N_q: 2^N_q is the constellation size for the QAM modulation, max. 6
%L = length of cyclic prefix, should be way smaller than N
%used carriers = row vector with indices of the used carrier frequencies
%training frame = QAM sequence of length N/2-1 used in each frame of 
%                                                   a training subpacket 
%Lt = number of training frames per training subpacket
%Ld = number of data frames per data subpacket
function [ofdm_seq] = ofdm_mod(seq, N, N_q, L, ...
    used_carriers, training_frame, Lt, Ld)    
    
    %check if N is even
    if mod(N,2) ~= 0
        error("N must be even");
    end

    %the number of data bits in one frame
    if ~exist('used_carriers', 'var') || isempty(used_carriers)
        used_carriers = [1:(N/2-1)];
    end
    nb_data = length(used_carriers);
    
    %QAM-modulation
    QAM_seq = qam_mod(seq, N_q);
        
    
    % define P as number of (total) data frames in a packet
    % define P_extended as the total data frame packets to fill all
    % subpackets
    P = ceil(length(QAM_seq)/(nb_data));
    Ld = P; %update for last demo
    nb_subpackets = ceil(P/Ld);
    P_extended = Ld*nb_subpackets;
    
    % padding with zeros to fit data in packet
    nb_padding_qam = P_extended*(nb_data) - length(QAM_seq);
    if (nb_padding_qam ~= 0)
        padding_seq = qam_mod(zeros(1, nb_padding_qam*N_q), N_q);
        QAM_seq = [QAM_seq, padding_seq];
    end
    
    %make a training subpacket of width Lt
    training_frame = [0, training_frame, 0, conj(fliplr(training_frame))];
    training_subpacket = repmat(transpose(training_frame),1,Lt);
   
    %fill each frame in the packet
    packet = zeros(N, P_extended);
    for i_P = 1:P_extended    
        %fill in QAM signals while keeping zeros on DC and Nyquist
        %frequencies, also keep zeros on non-used carrier frequencies
        start_QAM = (i_P-1) * nb_data;
        for i_data = 1:nb_data
            packet(used_carriers(i_data)+1, i_P) = QAM_seq(start_QAM + i_data);
            packet(N-used_carriers(i_data)+1, i_P) = conj( QAM_seq(start_QAM + i_data) );
        end
    end
    
    % put training subpackets in between data subpackets
%     for i_SP = 1:(nb_data_subpackets-1)
%         start = Ld*i_SP + Lt*(i_SP-1);
%         stop = start + 1 ;
%         packet = [packet(:,1:start) training_subpacket packet(:,stop:length(packet(1,:)))];
%     end
%     %add training_packet_matrix in front of the matrix
%     packet = [training_subpacket packet(:,:)];

    P_full = nb_subpackets * (Ld+Lt);
    packet_full = zeros(N, P_full);
    for i_SP = 1:nb_subpackets
        start_pos_tb = (i_SP-1)*(Ld+Lt) + 1;
        end_pos_tb = start_pos_tb + Lt - 1;
        start_pos_d = end_pos_tb + 1;
        end_pos_d = start_pos_d + Ld - 1;
        start_pos_packet = (i_SP-1) * Ld + 1;
        end_pos_packet = start_pos_packet + Ld - 1;
        
        packet_full(:,start_pos_tb:end_pos_tb) = training_subpacket;
        packet_full(:,start_pos_d:end_pos_d) = ...
                            packet(:,start_pos_packet:end_pos_packet);
    end
        
    
    %ifft op hele matrix
    packet_full = ifft(packet_full);
    
    %expand the packet with a cyclic prefix of length L
    packet_full = [ packet_full((N-L+1):N, :) ; packet_full];
    
    %parallel to serial conversion
    %TODO gebruik functies uit matlab tutorial
    ofdm_seq = zeros(1,(N+L)*P_full);
    for i_P = 1:P_full
        start_pos = (i_P-1)*(N+L) + 1;
        end_pos = start_pos + (N+L) - 1;
        ofdm_seq(1, start_pos:end_pos) = packet_full(:,i_P)';
    end
end