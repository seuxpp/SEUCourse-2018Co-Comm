function [channel]=get_channel_muti_parameter(channel,signal_sequence,ruili_sigma);
%获得信道乘性噪声

channel.attenuation.d=1/(channel.attenuation.distance^2);%pass loss is constant for the whole transmittion

switch channel.attenuation.pattern
    case 'no'  %no fading at all(only pass loss)
        channel.attenuation.phi=zeros(size(signal_sequence));
        channel.attenuation.h=ones(size(signal_sequence))*channel.attenuation.d;
        channel.attenuation.h_mag=channel.attenuation.h;   
    case 'Rayleigh'%Rayleigh
        nr_of_blocks=ceil(size(signal_sequence,2)/channel.attenuation.block_length);
        h_block=(randn(nr_of_blocks,1)+j*randn(nr_of_blocks,1))*channel.attenuation.d*sqrt(ruili_sigma);
        h=reshape((h_block*ones(1,channel.attenuation.block_length))',1,nr_of_blocks*channel.attenuation.block_length);
        channel.attenuation.h=h(1:(size(signal_sequence,2)));
        [channel.attenuation.phi,channel.attenuation.h_mag]=cart2pol(real(channel.attenuation.h),imag(channel.attenuation.h));
        channel.attenuation.phi=-channel.attenuation.phi;
    otherwise
        error(['Fading pattern unknown:',channel.attenuation.pattern]);
end

