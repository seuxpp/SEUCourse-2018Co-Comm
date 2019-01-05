function [channel_structure]=generate_channel_structure();
%创建信道结构体
attenuation_structure=generate_attenuation_structure;
noise_structure=generate_noise_structure;

channel_structure=struct(...   %matlab一行写不下时，用省略号开启另外一行，续行的作用
'attenuation',attenuation_structure,... %fading
'noise',noise_structure);            %noise

function [attenuation_structure]=generate_attenuation_structure();
%为衰落参数创建一个结构体
attenuation_structure=struct(...
'pattern',{},...     %'no','Rayleigh'
'distance',{},...    %信号传输距离
'd',{},...           %pass loss
'h',{},...           %attenuation 包括幅度和相位
'h_mag',{},...       %attenuation幅度
'phi',{},...         %相移
'block_length',{});%块长(bit/block)

function [noise_structure]=generate_noise_structure();
%创建表征白噪声的结构体
noise_structure=struct(...
'SNR',{},...%信噪比
'sigma',{});%高斯噪声的标准差


