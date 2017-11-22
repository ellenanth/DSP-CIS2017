N = 512;
N_q = 6;
L_seq = N_q/2*N-N_q;
seq = randi([0,1], 1, L_seq);
qam_seq = qam_mod(seq, N_q);

seq_100 = zeros(1, 100*N);
for i = 1:100
    start_bit = (i-1)*L_seq+1;
    end_bit = start_bit + L_seq - 1;
    seq_100(1, start_bit:end_bit) = seq;
end
Tx = ofdm_mod(seq_100,N,N_q,0,[1:(N/2-1)]);
% trainblock = qam_mod(seq,N_q);