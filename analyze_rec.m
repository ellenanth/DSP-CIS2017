%initialize parameters
fs = 16000;
t = [0:1/fs:2];
t = t';
dftsize = 512;

%create signal
%sig = sin(400*2*pi*t); % zonder DC component
%sig = 0.5*sin(400*2*pi*t) + 0.5; %met DC-component geschaald
%sig = sin(400*2*pi*t) + 0.5; %met DC-component, niet geschaald
sig = sin(100*2*pi*t)+sin(200*2*pi*t)+sin(500*2*pi*t)+sin(1000*2*pi*t)+sin(2000*2*pi*t)+sin(4000*2*pi*t)+sin(6000*2*pi*t);
%sig = awgn(sig,30); %met witte ruis
%sig = sin(0.001*2*pi*t); %met DC-component, niet geschaald

%create output
[simin, nbsecs, fs] = initparams(sig, fs);
sim('recplay');
out = simout.signals.values;

%draw spectogram
[S_sig,F_sig,T_sig,P_sig] = spectrogram(simin(:,1) , dftsize, dftsize/2, dftsize, fs,'yaxis');
[S_out,F_out,T_out,P_out] = spectrogram(out(:,1) , dftsize, dftsize/2, dftsize, fs,'yaxis');

figure(1)
subplot(211)
surf(T_sig,F_sig,10*log10(P_sig),'edgecolor','none'); 
axis tight;
view(0,90); 
set(gca,'clim',[-80 -30]); 
xlabel('Time (Seconds)'); 
ylabel('Frequnency (Hz)');
title('input signal');

subplot(212)
surf(T_out,F_out,10*log10(P_out),'edgecolor','none'); 
axis tight;
view(0,90); 
set(gca,'clim',[-80 -30]); 
xlabel('Time (Seconds)'); 
ylabel('Frequnency (Hz)');
title('recorded signal');

%draw PSD
%periodogram(x,rectwin(length(x)),length(x),Fs)
figure(2)
subplot(211)
[Pxx,F] = periodogram(simin(:,1),[],length(simin(:,1)),fs);
plot(F,10*log10(Pxx))
xlabel('Frequnency (Hz)'); 
ylabel('PSD');
title('input signal');

subplot(212)
[Pxx,F] = periodogram(out(:,1),[],length(out(:,1)),fs);
plot(F,10*log10(Pxx))
xlabel('Frequnency (Hz)'); 
ylabel('PSD');
title('recorded signal');

