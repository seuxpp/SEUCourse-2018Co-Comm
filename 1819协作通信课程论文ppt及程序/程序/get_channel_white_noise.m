function [noise_vector,channel,a]=get_channel_white_noise(channel,signal_sequence)
%获得信道加性高斯白噪声，并且得到的a值用来进行功率分配
if (size(signal_sequence,2)~=0)
    S=mean(abs(signal_sequence).^2);
else
    S=0;
end
SNR_linear=10^(channel.noise.SNR/10);
channel.noise.sigma=sqrt(S/(2*SNR_linear));
noise_vector=(randn(size(signal_sequence))+j*randn(size(signal_sequence)))*channel.noise.sigma;

a=channel.attenuation.h_mag.*channel.attenuation.h_mag/(2*channel.noise.sigma^2);%用来为功率分配用