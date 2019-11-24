%Author: Shaoqing Yu
%AF关于系统性能的研究
clear,clf;
datestr(now)
    min_SNR = 0;          %设置边界值
    max_SNR= 12;
    interval_plot = 0.5;	
    pow_division = 1/2;  %从源到目的和中继分50%能量                      
    Monte=10;      % 蒙特卡洛循环的次数
  
    H_sd = R_channel(1);     %源和目的之间的瑞利衰减，选取方差为1
    H_sr = R_channel(1);  	% 源和中继之间的瑞利衰减
    H_rd = R_channel(1);     % 中继和目的之间的瑞利衰减
     
    M = 2;N = 10000;   % 符号数和比特数
    %%
    x = randi(M,1,N)-1;                 %产生一个1*N的矩阵，矩阵中整型元素取值范围为[0,(M-1)]
    h = modem.pskmod(2);                  %产生2psk调制器           暂时没学 psk调制，这些借鉴的
    x_s=modulate(h,x);                   %调制产生源信号
  %%
    length= (max_SNR-min_SNR)/interval_plot+1;
    count = 0;
    %分配初值提升运算速度
    ber_SD=zeros(1,	length);ber_AF=zeros(1,	length);
    theo_ber_SD=zeros(1,length);theo_ber_AF=zeros(1,length);
    
for SNR_dB=min_SNR:interval_plot:max_SNR   %外循环
	count = count+1;    % 作为下标计数
	err_num_SD = 0;  % 传输过程中的错误的数量
	err_num_AF = 0;
    
    for nums=0:Monte        %内循环
 
        real_sig = 10^(SNR_dB/10);  %将真实的信号db值转换为十进制数值
        POW_S =  pow_division;      % 信号功率，已经被设置为50%
        POW_N =  pow_division/real_sig;    % 噪声功率
        
        %%
    % AWGN:在某一信号中加入高斯噪声  
        y_sd = awgn( sqrt( pow_division)*H_sd * x_s, SNR_dB, 'measured');	% Destination received the signal 'y_sd' from Source %'measured'表示测定信号强度
        y_sr = awgn( sqrt( pow_division)*H_sr * x_s, SNR_dB, 'measured');	% Relay received the signal 'y_sr' from Source
      %y = awgn(x,SNR,SIGPOWER) 如果SIGPOWER是数值，则其代表以dBW为单位的信号强度；如果SIGPOWER为'measured'，则函数将在加入噪声之前测定信号强度。
%%
     %直传direct
        y_SD = demodulate(modem.pskdemod(M),H_sd'*y_sd);       %先解调
        err_num_SD = err_num_SD + cal_err_bit(x,y_SD);   % 直传产生的错误数量
    
    %AF
        [beta,x_AF] = tran_AF(H_sr,POW_S,POW_N,y_sr);  %beta 为放大系数
        y_rd = awgn( sqrt(POW_S)*H_rd * x_AF, SNR_dB, 'measured');	  %目的收到的来自中继的含高斯白噪声的信号     
        y_combine_AF = MRC( beta,H_sd,H_sr,H_rd,POW_S,POW_N,POW_S,POW_N,y_sd,y_rd);  % 接收端MRC合并        
        y_AF = demodulate(modem.pskdemod(M),y_combine_AF); % BPSK解调MRC合并后的信号 
        err_num_AF = err_num_AF + cal_err_bit(x,y_AF);   % AF协作产生的总的误码数
   
    end;% for nums=0:Monte
    
    %通过统计蒙特卡罗的误码数，与全部比特数目作对比，除以全部比特数
	ber_SD(count) = err_num_SD/(N*Monte);                 
	ber_AF(count) = err_num_AF/(N*Monte);

    % 计算理论误码率
    theo_ber_SD(count) = 1 / ( 2 * sqrt(pi*SNR_dB)) * exp(-SNR_dB);  
    theo_ber_AF(count) = Theo_BER(H_sd,H_sr,H_rd,POW_S,POW_N,POW_S,POW_N);
        
end;    %for SNR....

SNR_dB = min_SNR:interval_plot:max_SNR;

figure(1)  % Direct and AF的实际误比特率
semilogy(SNR_dB,ber_SD,'r-o',SNR_dB,ber_AF,'b-+');     %semilogx用半对数坐标绘图,x轴是log10，y是线性的；semilogy用半对数坐标绘图,y轴是log10，x是线性的
legend('直传','AF协作');              
grid on; 
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('AF和直传的实际误比特率');
axis([min_SNR,max_SNR,10^(-5),1]);

figure(2)  % SD,AF 的误比特率的理论值
semilogy(SNR_dB,theo_ber_SD,'r-o',SNR_dB,theo_ber_AF,'b-+');
legend('直传','AF');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('直传和AF的理论误码率');
axis([min_SNR,max_SNR,10^(-5),1]);

figure(3)  %  AF and SD的实际值和理论值的误比特率的比较
subplot(2,1,1)
semilogy(SNR_dB,theo_ber_AF,'r-o',SNR_dB,ber_AF,'b-+');
legend('理论误比特率','实际误比特率');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('AF协作的平均和实际的误比特率');
axis([min_SNR,max_SNR,10^(-5),1]);
subplot(2,1,2)
semilogy(SNR_dB,theo_ber_SD,'r-o',SNR_dB,ber_SD,'b-+');
legend('理论误比特率','实际误比特率');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('直传的实际，理论误比特率比较');
axis([min_SNR,max_SNR,10^(-5),1]);