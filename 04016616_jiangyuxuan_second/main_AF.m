function [SNR_dB,ber_AF,theo_ber_AF] = main_AF( POW_DIV1 )
%% original definition
    MIN_SNR_dB = 0;   
    MAX_SNR_dB = 12;
    INTERVAL = 0.05;	% SNR interval
    
%     POW_DIV1 = 1/2;  % Power division factor,with cooperation, in order to guarantee a certain power of the total,
                    % respectively, the Source using the 1/2 of the power to send singal to the Relay and Destination
    POW_DIV2 = 1-POW_DIV1;  %   send singal to Destination 
   
    POW = 1;        % without cooperation,Source send signals directly to the Restination with full power
    Monte_MAX=10^2;    % the times of Monte Carlo,Limited to the computer configuration level, select the number to 10

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
    
    for tries=0:Monte_MAX
 
        sig = 10^(SNR_dB/10); % SNR, said non-dB
        POW_S1 = POW_DIV1;      % Signal power sr
        POW_S2 = POW_DIV2;      % Signal power rd
        POW_N1 = POW_S1 / sig;  % Noise power sr
        POW_N2 = POW_S2 / sig;  % Noise power rd

    % 'x_s' is transmitted from Source to Relay and Destination
    % AWGN:在某一信号中加入高斯噪声
        y_sd = awgn( sqrt(POW)*H_sd * x_s, SNR_dB, 'measured');	% Destination received the signal 'y_sd' from Source %'measured'表示测定信号强度
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
   
    end;% for tries=0:Monte_MAX
    
    % Calculated the actual BER for each SNR %通过统计蒙特卡罗的误码数，与全部比特数目作对比
	ber_SD(snrcount) = err_num_SD/(N*Monte_MAX);	
	ber_AF(snrcount) = err_num_AF/(N*Monte_MAX);
    % Calculated the theoretical BER for each SNR %调用自定义函数得到
    theo_ber_SD(snrcount) = Theo_ber(SNR_dB);
    theo_ber_AF(snrcount) = Theo_ber(H_sd,H_sr,H_rd,POW_S1,POW_N1,POW_S2,POW_N2);     
end;    % for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB

%% draw BER curves 
SNR_dB = MIN_SNR_dB:INTERVAL:MAX_SNR_dB;
% 
% hold on;
% disp('theo_ber_SD=');disp(theo_ber_SD);%disp 控制显示函数
% disp('theo_ber_AF=');disp(theo_ber_AF);
% semilogy(SNR_dB,ber_AF,'-*');%semilogx用半对数坐标绘图,x轴是log10，y是线性的；semilogy用半对数坐标绘图,y轴是log10，x是线性的
% % legend('AF');              
% grid on; %增加网格
% ylabel('The AVERAGE BER');
% xlabel('SNR(dB)');
% title('the actual BER of AF');
% axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);

end




