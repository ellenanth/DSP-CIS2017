IR2;
IR = h;
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
soundsc(out_estimated,fs);