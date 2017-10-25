N = 64; %user defined length of pseudo random binary sequence (PRBS)
seq = randi([0,1], 1, N);
seq_modulated = qam_mod(seq, 6);
