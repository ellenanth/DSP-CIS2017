N = 59; %user defined length of pseudo random binary sequence (PRBS)
N_q = 4; %2^N_q = constellation size (max. 6)
P = 2; %number of frames per packet
SNR = 3; %signal to noise ratio for the AWGN (additive white gaussian noise)

seq = randi([0,1], 1, N);

%option 1: QAM included in OFDM function
seq_modulated_1 = ofdm_mod(seq, P, N_q);
seq_demodulated_1 = ofdm_demod(seq_modulated_1, P, N_q, N);

BER_cal = ber(seq, seq_demodulated_1);


%option 2: QAM excluded form OFDM function
%(tiny difference in padding with zeros)
%QAM_seq = qam_mod(seq, N_q);
%seq_modulated_2 = ofdm_mod_2(QAM_seq, P, N_q);
%seq_demodulated_1 = ofdm_demod(seq_modulated_1, P, N_q, length(seq));