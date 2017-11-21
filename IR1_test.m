IR1;
% IR = out(sample_start:sample_end, 1);
IR = IR1_result;
analyze_rec;
out_estimated = fftfilt(IR, simin);
out_recorded = out;

subplot(211);
plot(out_recorded);
xlabel('samples');
title('output recorded');

subplot(212);
plot(out_estimated);
xlabel('samples');
title('output estimated');

%soundsc(out_recorded,fs);
%soundsc(out_estimated,fs);