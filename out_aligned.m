function [out_aligned] = alignIO(out,pulse)

X1=xcorr(out,pulse);   %compute cross-correlation between vectors s1 and s2
[m,d]=max(X1);      %find value and index of maximum value of cross-correlation amplitude

delay=d-max(length(out),length(pulse));   %shift index d, as length(X1)=2*N-1; where N is the length of the signals

figure,plot(out)                                     %Plot signal s1
plot([delay+1:length(pulse)+delay],pulse,'r');   %Delay signal s2 by delay in order to align them