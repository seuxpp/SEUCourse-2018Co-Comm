%**************************************************************************
%In this process, which function names begins with an uppercase letter is writen, 
%and function names starts with lowercase letters comes from the MATLAB system.
%**************************************************************************
%本程序有版权,仅供教学使用
%Author: Guilu Wu(Emperor)
%Date:29/09/2013 
%Copyright:东南大学移动通信国家重点实验室
%**************************************************************************
%本系统采用BPSK调制，无信道编码，Monte Carlo仿真方法，信道状态信息对接收节点是已知的，对发送节点是未知的。
%接收节点对接收到的信号采用相关检测。源节点与中继节点之间以及二者和目的节点之间的信道是相互独立的，服从瑞利慢衰落。
%**************************************************************************
clear all;%%清除了所有的变量，包括全局变量global
clear;clc;
datestr(now)%生成指定格式的日期和时间，now代表当前日期
tic;
%% original definition
    MIN_SNR_dB = 0;   
    MAX_SNR_dB = 6;
    INTERVAL = 0.5;	% SNR interval
  %  POW_DIV = 1/2;  % Power division factor,with cooperation, in order to guarantee a certain power of the total,
                    % respectively, the Source using the 1/2 of the power to send signals to the Relay and Destination
    POW = 1;        % without cooperation,Source send signals directly to the Restination with full power
    Monte_MAX=100;   % the times of Monte Carlo,Limited to the computer configuration level, select the number to 10

%% (Signal Source) Generate a random binary data stream
    M = 2;       % number of symbols  
    N = 10000;   % number of bits
    x = randi(M,1,N)-1;	% Random binary data stream %产生一个1*N的矩阵，矩阵中元素取值范围为[0,(M-1)]

%% Modulate using bpsk
    h  = modem.pskmod(2);%产生2psk调制器
    x_s=modulate(h,x);%调制产生源信号
    %x_s = modulate(modem.pskmod(M),x);	% The signal 'x_s' after bpsk modulation 

%% Rayleigh Fading / Assumed to cross reference channel  %采用恒参的瑞利衰落信道，即一次通信过程中，衰落系数表现为一恒定复数形式
    H_sd = RayleighCH( 1 );     % between Source and Destination
    H_sr = RayleighCH( 1 );  	% between Source and Relay station
    H_rd = RayleighCH( 1 );     % between Relay station and Destination
    
%% In different SNR in dB
    snrcount = 0;
    SNR_dB=MAX_SNR_dB;
    ber_AF1=1;
    ber_AF=1;
    m=0;
for mengte=1:1000
    mengte
    belta=round(rand(1)*999)/1000;
    %源节点
    POW_S=POW*(1-belta);  %*(1-belta)
    sig = 10^(SNR_dB/10); % SNR, said non-dB
     POW_SN = POW_S / sig;  % Noise power
     %中继节点
     POW_R=POW*(belta);
    sig = 10^(SNR_dB/10); % SNR, said non-dB
     POW_RN = POW_R / sig;  % Noise power
	err_num_SD = 0;  % Used to count the error bit
	err_num_AF = 0;
	
    for tries=0:Monte_MAX
        
    % 'x_s' is transmitted from Source to Relay and Destination
    % AWGN:在某一信号中加入高斯噪声
        y_sd = awgn( sqrt(POW_S)*H_sd * x_s, SNR_dB, 'measured');	% Destination received the signal 'y_sd' from Source %'measured'表示测定信号强度
        y_sr = awgn( sqrt(POW_S)*H_sr * x_s, SNR_dB, 'measured');	% Relay received the signal 'y_sr' from Source
      %y = awgn(x,SNR,SIGPOWER) 如果SIGPOWER是数值，则其代表以dBW为单位的信号强度；如果SIGPOWER为'measured'，则函数将在加入噪声之前测定信号强度。   
    %02:With Fixed Amplify-and-Forward relaying protocol
    	% beta: amplification factor
        % x_AF: Relaytransmit the AF signal 'x_AF'
        [beta,x_AF] = AF(H_sr,POW_S,POW_SN,y_sr);
        y_rd = awgn( sqrt(POW_R)*H_rd * x_AF, SNR_dB, 'measured');	% Destination received the signal 'y_rd' from Relay
        y_combine_AF = Mrc( H_sd,H_sr,H_rd,beta,POW_S,...
            POW_SN,POW_R,POW_RN,y_sd,y_rd);  % MRC
        y_AF = demodulate(modem.pskdemod(M),y_combine_AF); % After demodulate, Destinationthe gains the signal 'y_AF' 
        err_num_AF = err_num_AF + Act_ber(x,y_AF);   % wrong number of bits with AF  
    end;% for tries=0:Monte_MAX
	ber_AF1= err_num_AF/(N*Monte_MAX);
    if(ber_AF>ber_AF1)
        m=m+1;
        ber_AF=ber_AF1;
        ber_AF_R(m)=ber_AF1;
        BELTA(m)=belta;
    end    
end;    % for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB
plot(1:m,ber_AF_R,'-o');
title('蒙特卡洛算法衰减曲线');
ylabel('BER');


