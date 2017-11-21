    % play and record impulse using simulink model
    fs = 16000;
    impulse = [1; zeros(2*fs-1,1)];
    [simin, nbsecs, fs] = initparams(impulse, fs);
    sim('recplay');
    out = simout.signals.values;

    % synchronization
    [Y,I] = max(abs(out));

    limit_value = 1/10 * Y;

    %start looking for the start of the impulse response 300 samples left 
    %from the maximum and scan to the right
    i = I - 300;                    
    while (out(i,1) < limit_value)
        i = i + 1;
    end
    sample_start = i;

    %start looking for the end of the impulse response 500 samples right 
    %from the maximum and scan to the left
    j = I + 500;
    while out(j,1) < limit_value
        j = j - 1;
    end
    sample_end = j;
    
    N_IR = sample_end-sample_start+1;
    save('IRest.mat','N_IR');
