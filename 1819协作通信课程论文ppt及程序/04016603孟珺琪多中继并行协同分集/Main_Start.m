
clear all;%%清除了所有的变量，包括全局变量global
datestr(now)%生成指定格式的日期和时间，now代表当前日期

%% original definition
    MIN_SNR_dB = 0;   
    MAX_SNR_dB = 14;
    INTERVAL = 0.5;	% SNR interval
    POW_DIV = 1/2;
    POW = 1;       
    Monte_MAX=10^1;   

%% (Signal Source) Generate a random binary data stream
    M = 2;       % number of symbols  
    N = 10000;   % number of bits
    x = randi(1,N,M);	% Random binary data stream %产生一个1*N的矩阵，矩阵中元素取值范围为[0,(M-1)]

%% Modulate using bpsk
    h  = modem.pskmod(2);%产生2psk调制器
    x_s=modulate(h,x);%调制产生源信号 

%% Rayleigh Fading / Assumed to cross reference channel  %采用恒参的瑞利衰落信道，即一次通信过程中，衰落系数表现为一恒定复数形式
    H_sd = RayleighCH( 1 );     % between Source and Destination
    H_sr1 = RayleighCH( 1 );  	% between Source and Relay station
    H_rd1 = RayleighCH( 1 );     % between Relay station and Destination
    H_sr2 = RayleighCH( 1 );  	% between Source and Relay station
    H_rd2 = RayleighCH( 1 );
    H_sr3 = RayleighCH( 1 );  	% between Source and Relay station
    H_rd3 = RayleighCH( 1 );
    H_sr4 = RayleighCH( 1 );  	% between Source and Relay station
    H_rd4 = RayleighCH( 1 );
    H_sr5 = RayleighCH( 1 );  	% between Source and Relay station
    H_rd5 = RayleighCH( 1 );


%% In different SNR in dB
 
    snrcount = 0;
    
for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB
    
	snrcount = snrcount+1;    % count for different BER under SNR_dB

    
    for tries=0:Monte_MAX
 
        sig= 10^(SNR_dB/10);

 
        POW_S = POW_DIV;     
        POW_N = POW_S / sig; 
     
  
        y_sd = awgn( sqrt(POW_DIV)*H_sd * x_s, SNR_dB, 'measured');	
        y_sr1 = awgn( sqrt(POW_DIV)*H_sr1 * x_s, SNR_dB, 'measured');      
        y_sr2 = awgn( sqrt(POW_DIV)*H_sr2 * x_s, SNR_dB, 'measured');    
        y_sr3 = awgn( sqrt(POW_DIV)*H_sr3 * x_s, SNR_dB, 'measured');	
        y_sr4 = awgn( sqrt(POW_DIV)*H_sr4 * x_s, SNR_dB, 'measured');
        y_sr5 = awgn( sqrt(POW_DIV)*H_sr5 * x_s, SNR_dB, 'measured');
    %01:Without Cooperation,Source node transmit the signal to Destination node directly
        y_SD = demodulate(modem.pskdemod(M),H_sd'*y_sd);

  
    %02:With Fixed Amplify-and-Forward relaying protocol
    	% beta: amplification factor
        % x_AF: Relaytransmit the AF signal 'x_AF'
       
        beta1 = sqrt( POW_S) / ( (abs(H_sr1))^2 * POW_S + POW_N ); % amplification factor保证中继节点功率受限
        y_AF1 = beta1 *y_sr1;
        beta2 = sqrt( POW_S) / ( (abs(H_sr2))^2 * POW_S + POW_N ); % amplification factor保证中继节点功率受限
        y_AF2 = beta2 * y_sr2;
        beta3 = sqrt( POW_S) / ( (abs(H_sr3))^2 * POW_S + POW_N ); % amplification factor保证中继节点功率受限
        y_AF3 = beta3 * y_sr3;
       beta4 = sqrt( POW_S) / ( (abs(H_sr4))^2 * POW_S + POW_N ); % amplification factor保证中继节点功率受限
        y_AF4 = beta4 * y_sr4; 
        beta5 = sqrt( POW_S) / ( (abs(H_sr1))^2 * POW_S + POW_N ); % amplification factor保证中继节点功率受限
        y_AF5 = beta5 * y_sr5;
        y_rd1 = awgn( sqrt(POW_S)*H_rd1 * y_AF1, SNR_dB, 'measured');	
        y_rd2 = awgn( sqrt(POW_S)*H_rd2 * y_AF2, SNR_dB, 'measured');
        y_rd3 = awgn( sqrt(POW_S)*H_rd3 * y_AF3, SNR_dB, 'measured');
        y_rd4 = awgn( sqrt(POW_S)*H_rd4 * y_AF4, SNR_dB, 'measured');
        y_rd5 = awgn( sqrt(POW_S)*H_rd5 * y_AF5, SNR_dB, 'measured');
       
    
    %03:With Fixed Decode-and-Forward relaying protocol
    end;% for tries=0:Monte_MAX
    
  
    theo_ber_1_AF(snrcount) = Theo_ber(H_sd,H_sr1,H_rd1,POW_S,POW_N,POW_S,POW_N);
    theo_ber_3_AF(snrcount) = Theo_ber(H_sd,H_sr1,H_rd1,H_sr2,H_rd2,H_sr3,H_rd3,POW_S,POW_N,POW_S,POW_N);
    theo_ber_5_AF(snrcount) = Theo_ber(H_sd,H_sr1,H_rd1,H_sr2,H_rd2,H_sr3,H_rd3,H_sr4,H_rd4,H_sr5,H_rd5,POW_S,POW_N,POW_S,POW_N);
    theo_ber_1_DF(snrcount) = Theo_ber(H_sd,H_rd1,POW_S,POW_N,POW_S,POW_N);
    theo_ber_3_DF(snrcount) = Theo_ber(H_sd,H_rd1,H_rd2,H_rd3,POW_S,POW_N,POW_S,POW_N);
    theo_ber_5_DF(snrcount) = Theo_ber(H_sd,H_rd1,H_rd2,H_rd3,H_rd4,H_rd5,POW_S,POW_N,POW_S,POW_N);   
end;    % for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB

%% draw BER curves 
SNR_dB = MIN_SNR_dB:INTERVAL:MAX_SNR_dB;

disp('theo_ber_1_AF=');disp(theo_ber_1_AF);
disp('theo_ber_3_AF=');disp(theo_ber_3_AF);
disp('theo_ber_5_AF=');disp(theo_ber_5_AF);
disp('theo_ber_1_DF=');disp(theo_ber_1_DF);
disp('theo_ber_3_DF=');disp(theo_ber_3_DF);
disp('theo_ber_5_DF=');disp(theo_ber_5_DF);
figure(1)  % the actual BER of Direct and AF,DF
semilogy(SNR_dB,theo_ber_1_AF,'blue',SNR_dB,theo_ber_3_AF,'green',SNR_dB,theo_ber_5_AF,'red');
legend('K=1','K=3','K=5');              
grid on; %增加网格
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the  BER of  AF ');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);

figure(2)  % the theoretical BER of AF and DF
semilogy(SNR_dB,theo_ber_1_DF,'blue',SNR_dB,theo_ber_3_DF,'green',SNR_dB,theo_ber_5_DF,'red');
legend('k=1','k=3','k=5');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the  BER of DF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);


