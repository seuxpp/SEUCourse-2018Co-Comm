clear;clc;%%清除了所有的变量，包括全局变量global
datestr(now)%生成指定格式的日期和时间，now代表当前日期    
%% original definition
    
    Monte_MAX=10;    % the times of Monte Carlo,Limited to the computer configuration level, select the number to 10
    P=1000;%Total power
%% (Signal Source) Generate a random binary data stream
    M = 2;       % number of symbols  
    N = 10000;   % number of bits
    x = randint(1,N,M);	% Random binary data stream %产生一个1*N的矩阵，矩阵中元素取值范围为[0,(M-1)]

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
    
for N0=1:0.5:P
	snrcount = snrcount+1;    % count for different BER under SNR_dB
    err_num_SD = 0;  % Used to count the error bit
	err_num_AF = 0;
    
    err_num_SD1 = 0;  % Used to count the error bit
	err_num_AF1 = 0;
    
    err_num_SD2 = 0;  % Used to count the error bit
	err_num_AF2 = 0;
for tries=0:Monte_MAX
 
        
        a=abs(H_sd)*abs(H_sd);b=abs(H_sr)*abs(H_sr)-abs(H_rd)*abs(H_rd);d=abs(H_sr)*abs(H_sr)*abs(H_rd)*abs(H_rd);
        c=abs(H_rd)*abs(H_rd)+N0/P;
        fenzi=(a*b-d)*c+sqrt((d-a*b)*(b+c)*c*d);
        fenmu=b*(d-a*b);
        POW_S=abs(fenzi*P/fenmu);
        POW_R=abs(P-POW_S);
        POW_SN = N0;POW_RN = N0;
        SNR_dBS=-10*log(POW_SN/POW_S);
        SNR_dBR=-10*log(POW_RN/POW_R);
        
        POW_S1=P/2;
        POW_R1=P/2;
        POW_SN1 = N0;POW_RN1 = N0;
        SNR_dBS1=-10*log(POW_SN1/POW_S1);
        SNR_dBR1=-10*log(POW_RN1/POW_R1);
        
        POW_S2=P/3;
        POW_R2=P*2/3;
        POW_SN2 = N0;POW_RN2 = N0;
        SNR_dBS2=-10*log(POW_SN2/POW_S2);
        SNR_dBR2=-10*log(POW_RN2/POW_R2);
    % 'x_s' is transmitted from Source to Relay and Destination
    % AWGN:在某一信号中加入高斯噪声
        y_sd = awgn( sqrt(POW_S)*H_sd * x_s, SNR_dBS, 'measured');	% Destination received the signal 'y_sd' from Source %'measured'表示测定信号强度
        y_sr = awgn( sqrt(POW_S)*H_sr * x_s, SNR_dBS, 'measured');	% Relay received the signal 'y_sr' from Source
        
        y_sd1 = awgn( sqrt(POW_S1)*H_sd * x_s, SNR_dBS1, 'measured');	% Destination received the signal 'y_sd' from Source %'measured'表示测定信号强度
        y_sr1 = awgn( sqrt(POW_S1)*H_sr * x_s, SNR_dBS1, 'measured');	% Relay received the signal 'y_sr' from Source
        
        y_sd2 = awgn( sqrt(POW_S2)*H_sd * x_s, SNR_dBS2, 'measured');	% Destination received the signal 'y_sd' from Source %'measured'表示测定信号强度
        y_sr2 = awgn( sqrt(POW_S2)*H_sr * x_s, SNR_dBS2, 'measured');	% Relay received the signal 'y_sr' from Source
      %y = awgn(x,SNR,SIGPOWER) 如果SIGPOWER是数值，则其代表以dBW为单位的信号强度；如果SIGPOWER为'measured'，则函数将在加入噪声之前测定信号强度。

    %01:Without Cooperation,Source node transmit the signal to Destination node directly
%         y_SD = demodulate(modem.pskdemod(M),H_sd'*y_sd);
%         err_num_SD = err_num_SD + Act_ber(x,y_SD);   % wrong number of bits without Cooperation 
    %02:With Fixed Amplify-and-Forward relaying protocol
    	% beta: amplification factor
        % x_AF: Relaytransmit the AF signal 'x_AF'
        [beta,x_AF] = AF(H_sr,POW_S,POW_SN,y_sr);
        y_rd = awgn( sqrt(POW_R)*H_rd * x_AF, SNR_dBR, 'measured');	% Destination received the signal 'y_rd' from Relay
        y_combine_AF = Mrc( H_sd,H_sr,H_rd,beta,POW_S,POW_SN,POW_R,POW_RN,y_sd,y_rd);  % MRC
        y_AF = demodulate(modem.pskdemod(M),y_combine_AF); % After demodulate, Destinationthe gains the signal 'y_AF' 
        err_num_AF = err_num_AF + Act_ber(x,y_AF);   % wrong number of bits with AF
        
        [beta1,x_AF1] = AF(H_sr,POW_S1,POW_SN1,y_sr1);
        y_rd1 = awgn( sqrt(POW_R1)*H_rd * x_AF1, SNR_dBR, 'measured');	% Destination received the signal 'y_rd' from Relay
        y_combine_AF1 = Mrc( H_sd,H_sr,H_rd,beta1,POW_S1,POW_SN1,POW_R1,POW_RN1,y_sd1,y_rd1);  % MRC
        y_AF1 = demodulate(modem.pskdemod(M),y_combine_AF1); % After demodulate, Destinationthe gains the signal 'y_AF' 
        err_num_AF1 = err_num_AF1 + Act_ber(x,y_AF1);   % wrong number of bits with AF
        
        [beta2,x_AF2] = AF(H_sr,POW_S2,POW_SN2,y_sr);
        y_rd2 = awgn( sqrt(POW_R2)*H_rd * x_AF2, SNR_dBR2, 'measured');	% Destination received the signal 'y_rd' from Relay
        y_combine_AF2 = Mrc( H_sd,H_sr,H_rd,beta2,POW_S2,POW_SN2,POW_R2,POW_RN2,y_sd2,y_rd2);  % MRC
        y_AF2 = demodulate(modem.pskdemod(M),y_combine_AF2); % After demodulate, Destinationthe gains the signal 'y_AF' 
        err_num_AF2 = err_num_AF2 + Act_ber(x,y_AF2);   % wrong number of bits with AF
    % Calculated the actual BER for each SNR %通过统计蒙特卡罗的误码数，与全部比特数目作对比
	ber_SD(snrcount) = err_num_SD/(N*Monte_MAX);	
	ber_AF(snrcount) = err_num_AF/(N*Monte_MAX);
    
    ber_SD1(snrcount) = err_num_SD1/(N*Monte_MAX);	
	ber_AF1(snrcount) = err_num_AF1/(N*Monte_MAX);
    
    ber_SD2(snrcount) = err_num_SD2/(N*Monte_MAX);	
	ber_AF2(snrcount) = err_num_AF2/(N*Monte_MAX);
    % Calculated the theoretical BER for each SNR %调用自定义函数得到
%     theo_ber_SD(snrcount) = Theo_ber(SNR_dBS);
%     theo_ber_AF(snrcount) = Theo_ber(H_sd,H_sr,H_rd,POW_S,POW_SN,POW_S,POW_RN);
    end;% for tries=0:Monte_MAX        
end;    % for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB

%% draw BER curves 
N0=1:0.5:P
SNR_dB = -10*log(N0/P);

% figure(1)  % the actual BER of Direct and AF,DF
% semilogy(SNR_dB,ber_SD,'r-o',SNR_dB,ber_AF,'g-+');%semilogx用半对数坐标绘图,x轴是log10，y是线性的；semilogy用半对数坐标绘图,y轴是log10，x是线性的
% legend('Direct','AF');              
% grid on; %增加网格
% ylabel('The AVERAGE BER');
% xlabel('SNR(dB)');
% title('the actual BER of Direct and Direct, AF');
% axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);

semilogy(SNR_dB,ber_AF,'-o',SNR_dB,ber_AF1,'-+',SNR_dB,ber_AF2,'-*');%semilogx用半对数坐标绘图,x轴是log10，y是线性的；semilogy用半对数坐标绘图,y轴是log10，x是线性的
legend('最优功率分配','Ps:Pr=1:1','Ps:Pr=1:2');              
grid on; %增加网格
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual BER of AF');
%axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);
