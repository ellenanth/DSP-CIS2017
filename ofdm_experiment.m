N = 59; %user defined length of pseudo random binary sequence (PRBS)
N_q = 4; %2^N_q = constellation size (max. 6)
N_frame = 10; %size of each frame, must be even
L = 10;
SNR = 5; %signal to noise ratio for the AWGN (additive white gaussian noise)

seq = randi([0,1], 1, N);

% modulate
seq_modulated = ofdm_mod(seq, N_frame, N_q, L);

% add noise
seq_modulated = awgn(seq_modulated,SNR);

% demodulate
seq_demodulated = ofdm_demod(seq_modulated, N_frame, N_q, L, N, ...
                                [], 0);

% calculate BER
BER_cal = ber(seq, seq_demodulated);
disp("BER for SNR " + SNR + ", and QAM-size " + N_q + ...
    " equals " + BER_cal);
