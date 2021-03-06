%demodulate the given OFDM sequence seq back to the original sequence
%parameters:
%seq_mod = de modulated sequence to demodulate
%N = length of each frame in a packet, must be even
%N_q: 2^N_q is the constellation size for the QAM modulation, max. 6
%L = length of cyclic prefix
%original_length of the sequence needed to cut of padded zeros at the end
%channel_frequency_response
%scaling_on
%used carriers = row vector with indices of the used carrier frequencies
function [seq_demod] = ofdm_demod(seq_mod, N, N_q, L, original_length, ...
                            impulse_response, scaling_on, ...
                            used_carriers)    
    %default value for used_carriers
    if ~exist('used_carriers', 'var')
        used_carriers = [1:(N/2-1)];
    end
    
    %calculate channel frequency responses
    if scaling_on
        H_n = fft( [ impulse_response ; ...
                     zeros(N-length(impulse_response),1) ] );
    end
    
    %serial-to-parallel conversion
    P = (length(seq_mod)) / (N+L);
    packet = zeros(N+L,P);

    for i_P = 1:P
        %fill frames in packet
        start_pos = (i_P-1)*(N+L) + 1;
        end_pos = start_pos + (N+L) - 1;
        packet(:,i_P) = seq_mod(1, start_pos:end_pos)';
    end
    
    %cut off cyclic prefix
    packet = packet((L+1):N+L, :);
    
    %retrieve QAM sequence
    nb_data = length(used_carriers);
    QAM_seq = zeros(1, nb_data*P );
    
    for i_P = 1:P
        % FFT operation
        packet(:,i_P) = fft(packet(:,i_P));
        
        % scale components with the inverse of the channel frequency
        % response
        if scaling_on
            packet(:,i_P) = packet(:,i_P) ./ H_n;
        end
        
        % only retrieve values from used carriers
        start_QAM = (i_P-1) * nb_data;
        for i_data = 1:nb_data
            QAM_seq(1, start_QAM + i_data) = ...
                packet( used_carriers(i_data)+1, i_P );
        end
    end

    % demodulate QAM sequence
    seq_demod = qam_demod(QAM_seq, N_q, original_length); 
    
    % remove padded zeros
    seq_demod = seq_demod(1,1:original_length);
end