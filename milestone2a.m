N = 1000;
results = zeros(6, 10);
nb_it = 100; %number of iterations
SNR_max = 10;

for SNR = 1:SNR_max
    for N_q = 1:6
        disp(SNR + ", " + N_q);
        %calculate the mean of nb_it calculations
        sum = 0;
        for i = 1:nb_it
            seq = randi([0,1], 1, N);
            BER_cal = qam_experiment(N, N_q, SNR);
            sum = sum + BER_cal;
        end
        BER_mean = sum/nb_it;
        
        results(N_q,SNR) = BER_mean;
    end
end

%colors = {'r', 'm', 'y', 'g', 'c', 'b'};
figure(1);
plot( 1:SNR_max, results);
xlabel('SNR'); 
ylabel('BER');
title('BER for QAM (de)modulation');
legend('2', '4', '8', '16', '32', '64');
