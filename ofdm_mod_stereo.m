function [ofdm_seq1, ofdm_seq2] = ofdm_mod_stereo(seq, h1, h2, N_q, L, N)   

H1 = fft(h1);
H2 = fft(h2);

a = conj(H1)./(H1.*conj(H1)+H2.*conj(H2));
b = conj(H2)./(H1.*conj(H1)+H2.*conj(H2));
ofdm_seq = ofdm_mod2(seq, N, N_q, L,[1:(N/2-1)]);  
disp(length(a));
ofdm_seq1 = a.*ofdm_seq;
ofdm_seq2 = b.*ofdm_seq;

end