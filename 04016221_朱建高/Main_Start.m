clc
clf
clear
%% 初始定义信噪比及其间隔，功率分配，蒙特卡罗循环等参数
    MIN_SNR_dB = 0;   
    MAX_SNR_dB = 14;
    INTERVAL = 0.5;	% 信噪比间隔
    POW_DIV = 1/2;  % 功率分配比例
    Monte_MAX=10^1;    % 蒙特卡罗循环次数

%% 产生随机的二进制比特流
    M = 3;       % 符号数 
    N = 15000;   % 比特数
    x = randi(1,N,M);	% 随机二进制比特流

%% bpsk调制
    x_s= pskmod(x,2);%调制产生源信号 

%% 生成信道，采用恒参的瑞利衰落信道
    H_sd = RayleighCH( 1 );
    H_sr = RayleighCH( 1 );
    H_rd = RayleighCH( 1 );
    
%% In different SNR in dB
    snrcount = 0;
for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB
	snrcount = snrcount+1;    % count for different BER under SNR_dB   
    err_num_AF = 0;% Used to count the error bit
    
    for tries=0:Monte_MAX
 
        sig = 10^(SNR_dB/10); % SNR, said non-dB
        POW_S = POW_DIV;      % Signal power
        POW_N = POW_S / sig;  % Noise power
    % AWGN:在某一信号中加入高斯噪声
        y_sd = awgn( sqrt(POW_DIV)*H_sd * x_s, SNR_dB, 'measured');
        y_sr = awgn( sqrt(POW_DIV)*H_sr * x_s, SNR_dB, 'measured');
    % With Fixed Amplify-and-Forward relaying protocol
        [beta,x_AF] = AF(H_sr,POW_S,POW_N,y_sr);
        y_rd = awgn( sqrt(POW_S)*H_rd * x_AF, SNR_dB, 'measured');	
        y_combine_AF = Mrc( H_sd,H_sr,H_rd,beta,POW_S,POW_N,POW_S,POW_N,y_sd,y_rd);  
        y_AF = pskdemod(y_combine_AF,2); 
        err_num_AF = err_num_AF + Act_ber(x,y_AF);   % wrong number of bits with AF
    % Calculated the actual BER for each SNR %通过统计蒙特卡罗的误码数，与全部比特数目作对比	
	ber_AF(snrcount) = err_num_AF/(N*Monte_MAX);
    % Calculated the theoretical BER for each SNR %调用自定义函数得到
    theo_ber_AF(snrcount) = Theo_ber(H_sd,H_sr,H_rd,POW_S,POW_N,POW_S,POW_N);
        
    end    % for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB
end
%% draw BER curves 
SNR_dB = MIN_SNR_dB:INTERVAL:MAX_SNR_dB;

disp('theo_ber_AF=');disp(theo_ber_AF);%disp 控制显示函数

figure(1)  % the actual BER of Direct and AF,DF
semilogy(SNR_dB,ber_AF,'g-+');%semilogx用半对数坐标绘图,x轴是log10，y是线性的；semilogy用半对数坐标绘图,y轴是log10，x是线性的            
grid on; %增加网格
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual BER of  AF ');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);

figure(2)  % the theoretical BER of AF and DF
semilogy(SNR_dB,theo_ber_AF,'g-+');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the theoretical BER of AF ');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);

figure(3)  % the actual / theoretical BER of AF 
semilogy(SNR_dB,ber_AF,'r-o',SNR_dB,theo_ber_AF,'b-*');
legend('actual BER','theoretical BER');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual / theoretical BER of AF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);