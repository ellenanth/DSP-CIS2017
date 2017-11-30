
%% create transmitted signal
fs = 16000; N_q = 6;
seq = randi([0,1], 1, fs*1);
Tx = ofdm_mod(seq,50,N_q,25);
Tx = transpose(Tx);
L_signal = length(Tx);
[simin, nbsecs, fs, sync_pulse] = initparams(Tx, fs);

subplot(311);
plot(simin(:,1));
title('sent signal');

%% send over channel (introduce delay)
sim('recplay');
out = simout.signals.values;
% out = circshift(simin(:,1), 6000); %to test, create a delay of 50 samples
% out = [out; zeros(112,1)];

subplot(312);
plot(out);
title('received signal');

%% align output based on synchronization pulse
Rx = alignIO(out,sync_pulse, L_signal);
Rx = transpose(Rx);

subplot(313);
plot(Rx);
title('reconstructed signal');
