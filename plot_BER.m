SNR = 1.5;
N = 1000;
results = zeros(1,6);
for N_q = 1:6
    disp(N_q);
    sum = 0;
    for i = 1:200
        seq = randi([0,1], 1, N);
        seq_modulated = qam_mod(seq, N_q);
        seq_mod_noise = awgn(seq_modulated, SNR);
        seq_demodulated = qam_demod(seq_mod_noise, N_q, N);
        BER_cal = ber(seq, seq_demodulated);
        sum = sum + BER_cal;
    end
    BER_mean = sum/1000;
    results(1,N_q) = BER_mean;
end
plot(1:6, results);