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
                            used_carriers, trainblock, Lt, nbsecs)
    if ~exist('nbsecs', 'var') || isempty(nbsecs)
    nbsecs = 5;
    end   
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
    Ld = P - Lt;
    packet = zeros(N+L,P);

    for i_frame = 1:P
        %fill frames in packet
        start_pos = (i_frame-1)*(N+L) + 1;
        end_pos = start_pos + (N+L) - 1;
        packet(:,i_frame) = seq_mod(1, start_pos:end_pos)';
    end
    
    %cut off cyclic prefix
    %TODO can be implemented directly above in the serial to parallel
    %conversion
    packet = packet((L+1):N+L, :);
        
    %fft op hele matrix
    packet = fft(packet);
    
    % initializing
    channel_est_mtx = zeros(N, Ld);
    seq_demod = zeros(1, nb_data*Ld*N_q);
    
    % estimate channel frequency response based on trainblock
    channel_est = zeros(N/2-1, 1);
    for i = 1:(N/2-1)
        b = transpose(packet(i+1,1:Lt));
        A = ones(Lt, 1) .* trainblock(1,i);
        channel_est(i,1) = A\b;
    end
        
    % load estimation in channel_est matrix as initial value
    % TODO load W instead of H
    channel_est_mtx(:,1) = [0;channel_est;0;flipud(conj(channel_est))];

    %process data packet per frame
    QAM_seq = zeros(1, nb_data);
    start_bit = 1;
    for i_frame = (Lt+1):(Lt+Ld)
        if i_frame ~= Lt+1
            %TODO adaptive filter
            %store result in channel_est_mtx(:,i_P-Lt)
        end

        % scale components with the inverse of the channel frequency
        % response
        % TODO maal W
        packet(:,i_frame) = packet(:,i_frame) ./ channel_est_mtx(:,i_frame-Lt);

        % only retrieve values from used carriers
        start_QAM = (i_frame-Lt-1) * nb_data;
        for i_data = 1:nb_data
            QAM_seq(1, start_QAM + i_data) = ...
                packet( used_carriers(i_data)+1, i_frame );
        end

        %qam_demod per frame
        frame_bitstream = qam_demod(QAM_seq, N_q, nb_data*N_q);
        end_bit = start_bit + nb_data*N_q - 1;
        seq_demod(1, start_bit:end_bit) = frame_bitstream;
        start_bit = end_bit + 1;
        
        %visualize demod
        delta_s = nbsecs/Ld;
        s = delta_s * i_frame;
        %TODO H meegeven ipv W
        visualize_demod(seq_demod, channel_est_mtx(:,i_frame), ...
                                           used_carriers, s, delta_s);    
    end
    
    % remove padded zeros
    seq_demod = seq_demod(1,1:original_length);
end