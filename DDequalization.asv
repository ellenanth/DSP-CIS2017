%% variables
N_q = 4;
L_QAM = 1000;
u = 1; % stepsize of filter
alpha = 1; %vaagheidsparameter


%% generate X_k
L_seq = N_q*L_QAM;
seq = randi([0,1], 1, L_seq);
X_k = qam_mod(seq, N_q);
H_k = 2 + 1i;
%TODO add noizzze
Y_k = H_k * X_k;

%% random
W_k = zeros(1,L_QAM);
W_k(1,1) = 1/conj(H_k) + 0.1;

for i = 2:L_QAM
    %TODO fix it
    W_k(1,i) = W_k(1,i-1) + ;
end
