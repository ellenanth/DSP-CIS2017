N = 59; %user defined length of pseudo random binary sequence (PRBS)
N_q = 4; %2^N_q = constellation size (max. 6)
P = 2; %number of frames per packet
SNR = 3; %signal to noise ratio for the AWGN (additive white gaussian noise)

seq = randi([0,1], 1, N);

%option 1: QAM included in OFDM function
seq_modulated = ofdm_mod(seq, P, N_q);
seq_demodulated = ofdm_demod(seq_modulated, P, N_q, N);

BER_cal = ber(seq, seq_demodulated);