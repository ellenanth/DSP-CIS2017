%calculate the bit error rate (BER)
function [result] = ber(seq_Tx, seq_Rx) 
    [~,result] = biterr(seq_Tx, seq_Rx);
end