%create input
fs = 16000;
t = [0:1/fs:2];
t = t';
sinewave = sin(440*2*pi*t);

%run simulink model
[simin, nbsecs, fs] = initparams(sinewave, fs);
sim('recplay');
out = simout.signals.values;

pulse = [1,; zeros(fs*2,1)];

X1=xcorr(out,pulse);   %compute cross-correlation between vectors s1 and s2
[m,d]=max(X1);      %find value and index of maximum value of cross-correlation amplitude

delay=d-max(length(out),length(pulse));   %shift index d, as length(X1)=2*N-1; where N is the length of the signals
out = out(delay-20:length(out),1);

figure,plot(out)                                     %Plot signal s1
plot([delay+1:length(pulse)+delay],pulse,'r');   %Delay signal s2 by delay in order to align them

%soundsc plays and scales (to avoid clipping) the given input vector
soundsc(out,fs); 