function [channel,rx]=add_channel_effect_noNoise(channel,rx,signal_sequence);
%信道影响函数

global signal;

channel.attenuation.d=1/(channel.attenuation.distance^2);%pass loss is constant for the whole transmittion

switch channel.attenuation.pattern
    case 'no'  %no fading at all(only pass loss)
        channel.attenuation.phi=zeros(size(signal_sequence));
        channel.attenuation.h=ones(size(signal_sequence))*channel.attenuation.d;
        channel.attenuation.h_mag=channel.attenuation.h;   
    case 'Rayleigh'%Rayleigh
        nr_of_blocks=ceil(size(signal_sequence,2)/channel.attenuation.block_length);
        h_block=(randn(nr_of_blocks,1)+j*randn(nr_of_blocks,1))*channel.attenuation.d;
        h=reshape((h_block*ones(1,channel.attenuation.block_length))',1,nr_of_blocks*channel.attenuation.block_length);
        channel.attenuation.h=h(1:(size(signal_sequence,2)));
        [channel.attenuation.phi,channel.attenuation.h_mag]=cart2pol(real(channel.attenuation.h),imag(channel.attenuation.h));
        channel.attenuation.phi=-channel.attenuation.phi;
    otherwise
        error(['Fading pattern unknown:',channel.attenuation.pattern])
end

%加性高斯白噪声
if (size(signal_sequence,2)~=0)
    S=mean(abs(signal_sequence).^2);
else
    S=0;
end
SNR_linear=10^(channel.noise.SNR/10);
channel.noise.sigma=sqrt(S/(2*SNR_linear));
noise_vector=(randn(size(signal_sequence))+j*randn(size(signal_sequence)))*channel.noise.sigma;

%把衰落和加性高斯白噪声作用于信号,得到接收信号
rx.received_signal=signal_sequence.*channel.attenuation.h;


        
        
        
