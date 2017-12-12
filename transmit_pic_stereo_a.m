N = 512;
N_q = 4;
L = 0;
impulse_length = 20;

%% random impulse responses
seq = randi([0,1], 1, impulse_length);
h1 = transpose(randi([0,5], 1, impulse_length));
h2 = transpose(randi([0,5], 1, impulse_length));

[ofdm_seq1, ofdm_seq2] = ofdm_mod_stereo(seq,h1,h2,N_q,L,N);

%volgens mij gebruitken we ergens een andere functie ipv conv
Rx = conv(h1,ofdm_seq1)+conv(h2,ofdm_seq2);