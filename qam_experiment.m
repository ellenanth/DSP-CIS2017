%user defined length of pseudo random binary sequence (PRBS) bv. 1000
%2^N_q = constellation size (max. 6)
%signal to noise ratio for the AWGN (additive white gaussian noise)
function [BER_cal] = qam_experiment(N, N_q, SNR)
    seq = randi([0,1], 1, N);
    seq_modulated = qam_mod(seq, N_q);
    %scatterplot(seq_modulated);

    %hogere N_q betekent hogere bit-rate
    %average signal power? normalization to unit power?

    seq_mod_noise = awgn(seq_modulated, SNR);
    %scatterplot(seq_mod_noise);
    %hogere constellation size betekent minder grote hamming-afstand tussen de
    %verschillende punten, en dus minder marge om fouten te maken
    %hoe hoger N_q = hoe gevoeliger aan ruis

    seq_demodulated = qam_demod(seq_mod_noise, N_q, N);
    BER_cal = ber(seq, seq_demodulated);
    %disp("SNR = " + SNR + ", N_q = " + N_q + " => " + BER_cal);
end