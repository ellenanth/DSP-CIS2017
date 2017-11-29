function [out_aligned] = alignIO(out,pulse)

%compute cross-correlation between vectors s1 and s2
X1=xcorr(out,pulse);
%find index of maximum value of cross-correlation amplitude
[~,d]=max(X1);      

%shift index d, as length(X1)=2*N-1; where N is the length of the signals
delay=d-max(length(out),length(pulse));

%TODO fs en wachtlengtes meegeven in functie
out_aligned = [out(delay-20+16000*2:length(out)-1*16000,1) ; zeros(delay-20,1)];
end