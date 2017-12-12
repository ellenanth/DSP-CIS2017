%% variables
N_q = 4;
L_QAM = 100;
u = 1; % stepsize of filter
alpha = 1; %vaagheidsparameter
delta = 0.5; %Deviation of initial value of W_k


%% generate X_k
L_seq = N_q*L_QAM;
seq = randi([0,1], 1, L_seq);
X_k = qam_mod(seq, N_q);
H_k = 2 + 2i;
%TODO add noizzze
Y_k = H_k * X_k;

%% Adaptive filter
W_k = zeros(1,L_QAM);
W_k(1,1) = 1/conj(H_k) + delta; %initial value

for i = 2:L_QAM
    X_received = conj(W_k(1,i-1))*Y_k(1,i);
    X_corrected = qam_demod(X_received,N_q,N_q);
    X_corrected = qam_mod(X_corrected,N_q);
    W_k(1,i) = W_k(1,i-1) + ...
        (u*Y_k(1,i))/(alpha+conj(Y_k(1,i))*Y_k(1,i)) ...
        * (X_corrected - X_received);
end

%% plot error signal
error = abs(W_k) - 1/abs(H_k);
plot(error);
