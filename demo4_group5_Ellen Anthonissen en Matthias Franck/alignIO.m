function [out_aligned] = alignIO(out, pulse, L_signal)
    %compute cross-correlation between vectors out and pulse
    [X1, lag]=xcorr(out,pulse);

    %find index of maximum value of cross-correlation amplitude
    [~,I] = max(abs(X1));
    lagDiff = lag(I);

    %align output
    out_aligned = out(lagDiff+1:end);

    %cut off samples that don't belong to the signal
    out_start = 2.5*16000 - 20; %0.5s sync_pulse + 2s silence and 20 samples margin
    %out_end = length(out_aligned)-1*16000; %1s silence
    out_end = out_start+L_signal-1;
    out_aligned = out_aligned(out_start:out_end);
end