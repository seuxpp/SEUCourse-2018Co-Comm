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
datestr(now)%生成指定格式的日期和时间，now代表当前日期

%% original definition
    MIN_SNR_dB = 0;   
    MAX_SNR_dB = 14;
    INTERVAL = 0.5;	% SNR interval
    
    POW_DIV1 = 1/2;  % Power division factor,with cooperation, in order to guarantee a certain power of the total,
                    % respectively, the Source using the 1/2 of the power to send singal to the Relay and Destination
    POW_DIV2 = factor*POW_DIV1;  %   send singal to Destination 
   
    POW = 1;        % without cooperation,Source send signals directly to the Restination with full power
    Monte_MAX=10^1;    % the times of Monte Carlo,Limited to the computer configuration level, select the number to 10

%% (Signal Source) Generate a random binary data stream
    M = 2;       % number of symbols  
    N = 10000;   % number of bits
    %x = randint(1,N,M);	% Random binary data stream %产生一个1*N的矩阵，矩阵中元素取值范围为[0,(M-1)]
    x = randi([0,1],1,N);

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
    
for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB
    
	snrcount = snrcount+1;    % count for different BER under SNR_dB
    
	err_num_SD = 0;  % Used to count the error bit
	err_num_AF = 0;
	err_num_DF = 0;
    
    for tries=0:Monte_MAX
 
        sig = 10^(SNR_dB/10); % SNR, said non-dB
        POW_S1 = POW_DIV1;      % Signal power
        POW_S2 = POW_DIV2;      % Signal power
        POW_N1 = POW_S1 / sig;  % Noise power
        POW_N2 = POW_S2 / sig;  % Noise power

    % 'x_s' is transmitted from Source to Relay and Destination
    % AWGN:在某一信号中加入高斯噪声
        y_sd = awgn( sqrt(POW_DIV1)*H_sd * x_s, SNR_dB, 'measured');	% Destination received the signal 'y_sd' from Source %'measured'表示测定信号强度
        y_sr = awgn( sqrt(POW_DIV1)*H_sr * x_s, SNR_dB, 'measured');	% Relay received the signal 'y_sr' from Source
      %y = awgn(x,SNR,SIGPOWER) 如果SIGPOWER是数值，则其代表以dBW为单位的信号强度；如果SIGPOWER为'measured'，则函数将在加入噪声之前测定信号强度。

    %01:Without Cooperation,Source node transmit the signal to Destination node directly在没有协作的情况下，源节点直接向目的地节点发送信号
        y_SD = demodulate(modem.pskdemod(M),H_sd'*y_sd);
        err_num_SD = err_num_SD + Act_ber(x,y_SD);   % wrong number of bits without Cooperation   
  
    %02:With Fixed Amplify-and-Forward relaying protocol采用固定放大转发中继协议 
    	% beta: amplification factor
        % x_AF: Relaytransmit the AF signal 'x_AF'
        [beta,x_AF] = AF(H_sr,POW_S2,POW_N2,y_sr);
        y_rd = awgn( sqrt(POW_S2)*H_rd * x_AF, SNR_dB, 'measured');	% Destination received the signal 'y_rd' from Relay
        y_combine_AF = Mrc( H_sd,H_sr,H_rd,beta,POW_S2,POW_N2,POW_S2,POW_N2,y_sd,y_rd);  % MRC
        y_AF = demodulate(modem.pskdemod(M),y_combine_AF); % After demodulate, Destinationthe gains the signal 'y_AF' 
        err_num_AF = err_num_AF + Act_ber(x,y_AF);   % wrong number of bits with AF
    
    %03:With Fixed Decode-and-Forward relaying protocol固定解码转发中继协议 
        x_DF = DF(M,y_sr,x);
        y_rd = awgn( sqrt(POW_DIV2)*H_rd * x_DF, SNR_dB, 'measured');
        y_combine_DF = Mrc( H_sd,H_rd,POW_S2,POW_N2,POW_S2,POW_N2,y_sd,y_rd);
        y_DF = demodulate(modem.pskdemod(M),y_combine_DF);
        err_num_DF = err_num_DF + Act_ber(x,y_DF);   % wrong number of bits with DF
    end;% for tries=0:Monte_MAX
    
    % Calculated the actual BER for each SNR %通过统计蒙特卡罗的误码数，与全部比特数目作对比
	ber_SD(snrcount) = err_num_SD/(N*Monte_MAX);	
	ber_AF(snrcount) = err_num_AF/(N*Monte_MAX);
	ber_DF(snrcount) = err_num_DF/(N*Monte_MAX);
    % Calculated the theoretical BER for each SNR %调用自定义函数得到
    theo_ber_SD(snrcount) = Theo_ber(SNR_dB);
    theo_ber_AF(snrcount) = Theo_ber(H_sd,H_sr,H_rd,POW_S2,POW_N2,POW_S2,POW_N2);
    theo_ber_DF(snrcount) = Theo_ber(H_sd,H_rd,POW_S1,POW_N1,POW_S1,POW_N1);
        
end;    % for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB

%% draw BER curves 
SNR_dB = MIN_SNR_dB:INTERVAL:MAX_SNR_dB;

disp('theo_ber_SD=');disp(theo_ber_SD);%disp 控制显示函数
disp('theo_ber_AF=');disp(theo_ber_AF);
disp('theo_ber_DF=');disp(theo_ber_DF);

figure(1)  % the actual BER of Direct and AF,DF
semilogy(SNR_dB,ber_SD,'r-o',SNR_dB,ber_AF,'g-+',SNR_dB,ber_DF,'b-*');%semilogx用半对数坐标绘图,x轴是log10，y是线性的；semilogy用半对数坐标绘图,y轴是log10，x是线性的
legend('Direct','AF','DF');              
grid on; %增加网格
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual BER of Direct and Direct, AF and DF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-6),1]);

figure(2)  % the theoretical BER of AF and DF
semilogy(SNR_dB,theo_ber_SD,'r-o',SNR_dB,theo_ber_AF,'g-+',SNR_dB,theo_ber_DF,'b-*');
legend('Direct','AF','DF');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the theoretical BER of Direct, AF and DF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-6),1]);

figure(3)  % the actual / theoretical BER of AF and DF
subplot(2,1,1)
semilogy(SNR_dB,theo_ber_AF,'r-o',SNR_dB,ber_AF,'b-*');
legend('theoretical BER','actual BER');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual / theoretical BER of AF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-6),1]);
subplot(2,1,2)
semilogy(SNR_dB,theo_ber_DF,'r-o',SNR_dB,ber_DF,'b-*');
legend('theoretical BER','actual BER');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual / theoretical BER of DF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-6),1]);
