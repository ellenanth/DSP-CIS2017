% Exercise session 5: channel estimaition and equalization
%% variables

N = 512;
N_q = 6;
L_seq = N_q/2*N-N_q;
L_seq_100 = L_seq*100;
seq = randi([0,1], 1, L_seq);
qam_seq = qam_mod(seq, N_q);

%impulse response
IRest = matfile('IRest.mat');
impulse_response = IRest.h;

%% calculations
seq_100 = zeros(1, 100*N);
for i = 1:100
    start_bit = (i-1)*L_seq+1;
    end_bit = start_bit + L_seq - 1;
    seq_100(1, start_bit:end_bit) = seq;
end
Tx = ofdm_mod(seq_100,L_seq,N_q,L_seq/10);
Rx = fftfilt(impulse_response, Tx);
% trainblock = qam_mod(seq,N_q);