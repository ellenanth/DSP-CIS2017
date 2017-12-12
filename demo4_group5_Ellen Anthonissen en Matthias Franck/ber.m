%calculate the bit error rate (BER)
%seq_Tx = transmitted signal
%seq_Rx = received signal containing noise
function [result] = ber(seq_Tx, seq_Rx)
    [~,result] = biterr(seq_Tx, seq_Rx);
end