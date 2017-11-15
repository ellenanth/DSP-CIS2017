N_q = 6;
N = 1000;
P = 20;
L = 5;
results = zeros(1,10);
nb_it = 200; %number of iterations
plot_case = 0; %0 to plot qam, 1 to plot ofdm

for SNR = 1:10
    disp(SNR);
    sum = 0;
    for i = 1:nb_it
        seq = randi([0,1], 1, N);
        switch plot_case
            case 0, seq_modulated = qam_mod(seq, N_q);
            case 1, seq_modulated = ofdm_mod(seq, P, N_q, L);
        end
        seq_mod_noise = awgn(seq_modulated, SNR);
        switch plot_case
            case 0, seq_demodulated = qam_demod(seq_mod_noise, N_q, N);
            case 1, seq_demodulated = ofdm_demod(seq_mod_noise, P, N_q, L, N);
        end
        BER_cal = ber(seq, seq_demodulated);
        sum = sum + BER_cal;
    end
    BER_mean = sum/nb_it;
    results(1,SNR) = BER_mean;
end
plot(1:10, results);
xlabel('QAM-constellation size N_q'); 
ylabel('BER');
switch plot_case
    case 0, title('BER for QAM (de)modulation');
    case 1, title('BER for OFDM (de)modulation');
end