function [seq_demod] = ofdm_demod_stereo(seq_mod, N, N_q, L, original_length, ...                         
                            used_carriers, num)

%default value for used_carriers
if ~exist('used_carriers', 'var') || isempty(used_carriers)
    used_carriers = [1:(N/2-1)];
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

%FFT
packet = fft(packet);

%scale using formula 5 (for 7-3)
factor = 1 ./ num;
factor_full_frame = [0;factor;0;flipud(conj(factor))];
packet = factor_full_frame .* packet;

%retrieve QAM sequence
nb_data = length(used_carriers);
QAM_seq = zeros(1, nb_data*P );
seq_demod = zeros(1, nb_data*P*N_q);
start_bit = 1;

for i_P = 1:P
    % only retrieve values from used carriers
    start_QAM = (i_P-1) * nb_data;
    for i_data = 1:nb_data
        QAM_seq(1, start_QAM + i_data) = ...
            packet( used_carriers(i_data)+1, i_P );
    end
    
    %qam_demod per frame
    frame_bitstream = qam_demod(...
        QAM_seq(1, (start_QAM+1):(start_QAM+N/2-1)),...
        N_q, nb_data*N_q);
    end_bit = start_bit + nb_data*N_q - 1;
    seq_demod(1, start_bit:end_bit) = frame_bitstream;
    start_bit = end_bit + 1;
end

% % demodulate QAM sequence
% seq_demod = qam_demod(QAM_seq, N_q, original_length); 

% remove padded zeros
seq_demod = seq_demod(1,1:original_length);
end

