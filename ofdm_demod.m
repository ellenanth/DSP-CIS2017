%demodulate the given OFDM sequence seq back to the original sequence
%N_q is maximaal 6
%original_length is needed to cut of padded zeros at the end
function [seq_demod] = ofdm_demod(seq_mod, P, N_q, original_length) 
    %TODO serial-to-parallel conversion
    N = length(seq_mod)/P;
    packet = zeros(N,P);
    disp(packet);

    for i_P = 1:P
        %TODO fill frames in packet
        start_pos = (i_P-1)*N + 1;
        end_pos = start_pos + N - 1;
        packet(:,i_P) = seq_mod(1, start_pos:end_pos);
        
        %TODO FFT operation
        packet(:,i_P) = fft(packet(:,i_P));
        
        %TODO retrieve QAM sequence
        end_N = length(packet(:,1))-1;
        start_QAM = (i_P-1) * end_N + 1;
        QAM_seq(start_QAM:start_QAM + end_N - 1) = packet(2:end_N+1, i_P); 
    end
    

    %TODO demodulate QAM sequence
    seq_demod = qam_demod(QAM_seq, N_q, original_length); 
    
    %nullen wegdoen om terug orignele lengte te krijgen
    seq_demod = seq_demod(1,1:original_length);
end