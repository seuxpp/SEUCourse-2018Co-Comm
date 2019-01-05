%**************************************************************************
%In this process, which function names begins with an uppercase letter is writen, 
%and function names starts with lowercase letters comes from the MATLAB system.
%**************************************************************************
%本程序有版权可随意使用发布，但请保留原版信息Copyleft
%Author: 11/06/2010 Davy
%2010.06.11 由 Davy 以账号 yuema1086 发布于 www.CSDN.com
%**************************************************************************
clear all;
datestr(now)

%% original definition
    MIN_SNR_dB = 0;   
    MAX_SNR_dB = 14;
    INTERVAL = 0.5;	% SNR interval
    POW_DIV = 1/2;  % Power division factor,with cooperation, in order to guarantee a certain power of the total,
                    % respectively, the Source using the 1/2 of the power to send signals to the Relay and Destination
    POW = 1;        % without cooperation,Source send signals directly to the Restination with full power
    Monte_MAX=10^1;    % the times of Monte Carlo,Limited to the computer configuration level, select the number to 10

%% (Signal Source) Generate a random binary data stream
    M = 2;       % number of symbols  
    N = 10000;   % number of bits
    x = randint(1,N,M);	% Random binary data stream

%% Modulate using bpsk
    x_s = modulate(modem.pskmod(M),x);	% The signal 'x_s' after bpsk modulation 

%% Rayleigh Fading / Assumed to cross reference channel
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
        POW_S = POW_DIV;      % Signal power
        POW_N = POW_S / sig;  % Noise power

    % 'x_s' is transmitted from Source to Relay and Destination
        y_sd = awgn( sqrt(POW_DIV)*H_sd * x_s, SNR_dB, 'measured');	% Destination received the signal 'y_sd' from Source
        y_sr = awgn( sqrt(POW_DIV)*H_sr * x_s, SNR_dB, 'measured');	% Relay received the signal 'y_sr' from Source


    %01:Without Cooperation,Source node transmit the signal to Destination node directly
        y_SD = demodulate(modem.pskdemod(M),H_sd'*y_sd);
        err_num_SD = err_num_SD + Act_ber(x,y_SD);   % wrong number of bits without Cooperation   
  
    %02:With Fixed Amplify-and-Forward relaying protocol
    	% beta: amplification factor
        % x_AF: Relaytransmit the AF signal 'x_AF'
        [beta,x_AF] = AF(H_sr,POW_S,POW_N,y_sr);
        y_rd = awgn( sqrt(POW_S)*H_rd * x_AF, SNR_dB, 'measured');	% Destination received the signal 'y_rd' from Relay
        y_combine_AF = Mrc( H_sd,H_sr,H_rd,beta,POW_S,POW_N,POW_S,POW_N,y_sd,y_rd);  % MRC
        y_AF = demodulate(modem.pskdemod(M),y_combine_AF); % After demodulate, Destinationthe gains the signal 'y_AF' 
        err_num_AF = err_num_AF + Act_ber(x,y_AF);   % wrong number of bits with AF
    
    %03:With Fixed Decode-and-Forward relaying protocol
        x_DF = DF(M,y_sr,x);
        y_rd = awgn( sqrt(POW_DIV)*H_rd * x_DF, SNR_dB, 'measured');
        y_combine_DF = Mrc( H_sd,H_rd,POW_S,POW_N,POW_S,POW_N,y_sd,y_rd);
        y_DF = demodulate(modem.pskdemod(M),y_combine_DF);
        err_num_DF = err_num_DF + Act_ber(x,y_DF);   % wrong number of bits with DF
    end;% for tries=0:Monte_MAX
    
    % Calculated the actual BER for each SNR
	ber_SD(snrcount) = err_num_SD/(N*Monte_MAX);	
	ber_AF(snrcount) = err_num_AF/(N*Monte_MAX);
	ber_DF(snrcount) = err_num_DF/(N*Monte_MAX);
    % Calculated the theoretical BER for each SNR
    theo_ber_SD(snrcount) = Theo_ber(SNR_dB);
    theo_ber_AF(snrcount) = Theo_ber(H_sd,H_sr,H_rd,POW_S,POW_N,POW_S,POW_N);
    theo_ber_DF(snrcount) = Theo_ber(H_sd,H_rd,POW_S,POW_N,POW_S,POW_N);
        
end;    % for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB

%% draw BER curves 
SNR_dB = MIN_SNR_dB:INTERVAL:MAX_SNR_dB;

disp('theo_ber_SD=');disp(theo_ber_SD);
disp('theo_ber_AF=');disp(theo_ber_AF);
disp('theo_ber_DF=');disp(theo_ber_DF);

figure(1)  % the actual BER of Direct and AF,DF
semilogy(SNR_dB,ber_SD,'r-o',SNR_dB,ber_AF,'g-+',SNR_dB,ber_DF,'b-*');
legend('Direct','AF','DF');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual BER of Direct and Direct, AF and DF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);

figure(2)  % the theoretical BER of AF and DF
semilogy(SNR_dB,theo_ber_SD,'r-o',SNR_dB,theo_ber_AF,'g-+',SNR_dB,theo_ber_DF,'b-*');
legend('Direct','AF','DF');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the theoretical BER of Direct, AF and DF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);

figure(3)  % the actual / theoretical BER of AF and DF
subplot(2,1,1)
semilogy(SNR_dB,theo_ber_AF,'r-o',SNR_dB,ber_AF,'b-*');
legend('theoretical BER','actual BER');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual / theoretical BER of AF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);
subplot(2,1,2)
semilogy(SNR_dB,theo_ber_DF,'r-o',SNR_dB,ber_DF,'b-*');
legend('theoretical BER','actual BER');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual / theoretical BER of DF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);
