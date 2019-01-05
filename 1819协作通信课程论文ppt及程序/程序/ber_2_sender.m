function y=ber_2_sender(SNR_avg,modulation_type);
%计算有两个等同发送方的理论ber

global signal;
switch signal.modulation_type
    case 'BPSK'
        mu = sqrt(SNR_avg ./ (1 / 2 + SNR_avg));
    case 'QPSK'
        mu = sqrt(SNR_avg ./ (1 + SNR_avg));
    otherwise
        error(['Modulation-type unknown: ', modulation_type])
end
y = 1 / 4 * (1 - mu) .^ 2 .* (2 + mu);
