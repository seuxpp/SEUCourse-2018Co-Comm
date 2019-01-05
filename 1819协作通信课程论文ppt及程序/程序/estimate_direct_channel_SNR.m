function SNR_direct=estimate_direct_channel_SNR(channel,modulation_type,Ps);
%直传信道的信噪比估计
global signal;
switch modulation_type
    case 'BPSK'
        SNR_direct=10^(channel.noise.SNR/10)*ones(size(signal.symbol_sequence)).*channel.attenuation.h_mag.^2.*Ps;
    case 'QPSK'
        SNR_direct=10^(channel.noise.SNR/10)*ones(size(signal.symbol_sequence)).*channel.attenuation.h_mag.^2.*Ps;
        SNR_direct=[SNR_direct,SNR_direct];
end



