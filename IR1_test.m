IR1;
IR = out(sample_start:sample_end, 1);
analyze_rec;
out_estimated = fftfilt(IR, simin);
out_recorded = out;

subplot(211);
plot(out_recorded);
%axis([sample_start sample_end -0.1 0.1]);
xlabel('samples');
title('output recorded');

subplot(212);
plot(out_estimated);
%axis([sample_start sample_end -0.1 0.1]);
xlabel('samples');
title('output estimated');

%soundsc(out_recorded,fs);
soundsc(out_estimated,fs);

% figure(2);
% plot(out_recorded-out_estimated);
% xlabel('samples');
% title('delta out');