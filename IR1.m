clear;

%% define variables
fs = 16000;
t = [0:1/fs:2];
t = t';

% define input signal
impulse = [1; zeros(length(t)-1,1)];

%% simulink
% play and record signal using simulink model
[simin, nbsecs, fs] = initparams(impulse, fs);
sim('recplay');
out = simout.signals.values;

%% synchronization
[Y,I] = max(abs(out));

limit_value = 1/10 * Y;
disp('limit value: ' + limit_value);
disp('max value: ' + Y + ', at ' + I);

%start looking for the start of the impulse response 300 samples left from 
%the maximum and scan to the right
i = I - 300;                    
while (out(i,1) < limit_value)
    i = i + 1;
end
sample_start = i;
disp('start: ' + i);

%start looking for the end of the impulse response 500 samples right from 
%the maximum and scan to the left
j = I + 500;
while out(j,1) < limit_value
    j = j - 1;
end
sample_end = j;
disp('end: ' + j);

%% results
%IR1
IR1_result = out(sample_start:sample_end, 1);

% % plot played and recorded signal
% figure(1);
% 
% subplot(411);
% plot(simin);
% xlabel('samples');
% title('input signal in time domain');
% 
% subplot(412);
% plot(out);
% xlabel('samples');
% title('impulse response in time domain');
% 
% subplot(413);
% plot(out);
% axis([sample_start sample_end -Y Y]);
% xlabel('samples');
% title('impulse response in time domain');

% %calculate and plot magnitude response
% subplot(414);
% out_cropped = out(sample_start:sample_end,1);
% fourrier = abs(fft(out_cropped));
% dF = fs/length(out_cropped);
% f = -fs/2:dF:fs/2-dF;
% plot(f,10*log10(fourrier)); %nog delen door length(out)?
% xlabel('Frequency (in hertz)');
% title('Magnitude Response');