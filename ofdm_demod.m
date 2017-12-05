%demodulate the given OFDM sequence seq back to the original QAM sequence
%parameters:
%seq_mod = de modulated sequence to demodulate
%N = length of each frame in a packet, must be even
%N_q: 2^N_q is the constellation size for the QAM modulation, max. 6
%L = length of cyclic prefix
%original_length of the sequence needed to cut of padded zeros at the end
%used carriers = row vector with indices of the used carrier frequencies
%trainblock = QAM sequence used in each frame of the training subpackets
%Lt = number of frames in training subpackets
%Ld = number of frames in data subpackets
function [seq_demod, channel_est_mtx] = ofdm_demod(seq_mod, N, N_q, L, original_length, ...
                            used_carriers, trainblock, Lt, Ld)    
    %default value for used_carriers
    if ~exist('used_carriers', 'var') || isempty(used_carriers)
        used_carriers = [1:(N/2-1)];
    end   
    nb_data = length(used_carriers);
    
    %if seq_mod is a column vector, transpose to a row vector
    if size(seq_mod,1)>size(seq_mod,2)
        seq_mod = transpose(seq_mod);
    end
    
    %serial-to-parallel conversion
    %TODO gebruik functies van matlab tutorial
    P = (length(seq_mod)) / (N+L);
    packet = zeros(N+L,P);

    for i_P = 1:P
        %fill frames in packet
        start_pos = (i_P-1)*(N+L) + 1;
        end_pos = start_pos + (N+L) - 1;
        packet(:,i_P) = seq_mod(1, start_pos:end_pos)';
    end
    
    %cut off cyclic prefix
    %TODO can be implemented directly above in the serial to parallel
    %conversion
    packet = packet((L+1):N+L, :);
        
    %fft op hele matrix
    packet = fft(packet);
    
    %define nb_subpackets
    nb_subpackets = P / (Lt + Ld);
    disp("number of subpackets is " + nb_subpackets);
    
    channel_est_mtx = zeros(N, nb_subpackets);
    seq_demod = zeros(1, nb_data*Ld*nb_subpackets*N_q);
    remaining_length = original_length;
    for i_SP = 1:nb_subpackets
    
        %estimate channel frequency response based on trainblock
        channel_est = zeros(N/2-1, 1);
        start_pos_tb = (i_SP-1)*(Lt+Ld) + 1;
        end_pos_tb = start_pos_tb + Lt - 1;
        start_pos_d = end_pos_tb + 1;
        end_pos_d = start_pos_d + Ld - 1;
        
        for i = 1:(N/2-1)
            b = transpose(packet(i+1,start_pos_tb:end_pos_tb));
            A = ones(Lt, 1) .* trainblock(1,i);
            channel_est(i,1) = A\b;
        end
        
        %load estimation in channel_est matrix
        channel_est_mtx(:,i_SP) = [0;channel_est;0;flipud(conj(channel_est))];

        %retrieve QAM sequence from subpacket
        QAM_seq_subpacket = zeros(1, nb_data*Ld);
        for i_P = start_pos_d:end_pos_d
            % scale components with the inverse of the channel frequency
            % response
            packet(:,i_P) = packet(:,i_P) ./ channel_est_mtx(:,i_SP);

            % only retrieve values from used carriers
            start_QAM = (i_P-start_pos_d) * nb_data;
            for i_data = 1:nb_data
                QAM_seq_subpacket(1, start_QAM + i_data) = ...
                    packet( used_carriers(i_data)+1, i_P );
            end
        end
        
        % demodulate QAM sequence from subpacket
        start_pos = (i_SP-1) * nb_data*Ld*N_q + 1;
        if i_SP == nb_subpackets
            seq_demod_subpacket = ...
                     qam_demod(QAM_seq_subpacket, N_q, remaining_length);
            end_pos = start_pos + remaining_length - 1;
        else
            seq_demod_subpacket = ...
                     qam_demod(QAM_seq_subpacket, N_q, nb_data*Ld*N_q); 
            remaining_length = remaining_length - nb_data*Ld*N_q;
            end_pos = start_pos + nb_data*Ld*N_q - 1;
        end
        %save demodulated QAM sequence of the subpacket
        seq_demod(1, start_pos:end_pos) = seq_demod_subpacket;
        
%         f = 16000; %frames per second
%         seconds = (Lt+Ld)/f * i_SP;
        seconds = 0.5 * i_SP;
        seconds_update = 0.5;
        visualize_demod(seq_demod, channel_est_mtx(:,i_SP), ...
                                                seconds, seconds_update);        
    end

    % remove padded zeros
    seq_demod = seq_demod(1,1:original_length);
end