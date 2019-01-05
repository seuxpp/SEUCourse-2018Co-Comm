clear all

%% original definition
    MIN_SNR_dB = 0;   
    MAX_SNR_dB = 14;
    INTERVAL = 0.5;	
    POW_DIV = 1/2;  
    POW = 1;       
    Monte_MAX=10^1;  
%% (Signal Source) Generate a random binary data stream
    M = 2;     
    N = 10000;  
    x = randint(1,N,M);	

%% Modulate using bpsk
    h  = modem.pskmod(2);
    x_s=modulate(h,x);

%% Rayleigh Fading / Assumed to cross reference channel 
    H_sd = RayleighCH( 1 );    
    H_sr = RayleighCH( 1 ); 
    H_rd = RayleighCH( 1 );  
%% In different SNR in dB
    snrcount = 0;
    
for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB
    
	snrcount = snrcount+1;   
    
	err_num_SD = 0; 
	err_num_AF = 0;
	err_num_DF = 0;
    
    for tries=0:Monte_MAX
        sig = 10^(SNR_dB/10);
        POW_S = POW_DIV;   
        POW_N = POW_S / sig; 
        
        y_sd = awgn( sqrt(POW_DIV)*H_sd * x_s, SNR_dB, 'measured');	
        y_sr = awgn( sqrt(POW_DIV)*H_sr * x_s, SNR_dB, 'measured');	
    %01:Without Cooperation,Source node transmit the signal to Destination node directly
        y_SD = demodulate(modem.pskdemod(M),H_sd'*y_sd);
        err_num_SD = err_num_SD + Act_ber(x,y_SD);   % wrong number of bits without Cooperation   
    %02:With Fixed Amplify-and-Forward relaying protocol
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
        
end;  

%% draw BER curves 
SNR_dB = MIN_SNR_dB:INTERVAL:MAX_SNR_dB;

disp('theo_ber_SD=');disp(theo_ber_SD);
disp('theo_ber_AF=');disp(theo_ber_AF);
disp('theo_ber_DF=');disp(theo_ber_DF);

figure(1) 
semilogy(SNR_dB,ber_SD,'r-o',SNR_dB,ber_AF,'g-+',SNR_dB,ber_DF,'b-*');
legend('Direct','AF最优功率','AF等功率');              
grid on; 
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual BER of Direct and Direct, AF and DF');
axis([MIN_SNR_dB,MAX_SNR_dB,10^(-5),1]);
