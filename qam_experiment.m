N = 1000; %user defined length of pseudo random binary sequence (PRBS)
N_q = 6; %2^N_q = constellation size
SNR = 7; %signal to noise ratio for the AWGN (additive white gaussian noise)

seq = randi([0,1], 1, N);
seq_modulated = qam_mod(seq, N_q);
scatterplot(seq_modulated);

%hogere N_q betekent hogere bit-rate
%average signal power? normalization to unit power?

seq_mod_noise = awgn(seq_modulated, SNR);
scatterplot(seq_mod_noise);
%hogere constellation size betekent minder grote hamming-afstand tussen de
%verschillende punten, en dus minder marge om fouten te maken
%hoe hoger N_q = hoe gevoeliger aan ruis

seq_demodulated = qam_demod(seq_mod_noise, N_q, N);
BER_cal = ber(seq, seq_demodulated);
BER_cal