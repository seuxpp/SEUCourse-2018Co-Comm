function [SNR_dB,ber_DF,theo_ber_DF] = main_DF( POW_DIV1 )
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
    %x = randint(1,N,M);	% Random binary data stream %����һ��1*N�ľ��󣬾�����Ԫ��ȡֵ��ΧΪ[0,(M-1)]
    x = randi([0,1],1,N);

%% Modulate using bpsk
    h  = modem.pskmod(2);%����2psk������
    x_s=modulate(h,x);%���Ʋ���Դ�ź�
    %x_s = modulate(modem.pskmod(M),x);	% The signal 'x_s' after bpsk modulation 

%% Rayleigh Fading / Assumed to cross reference channel  %���ú�ε�����˥���ŵ�����һ��ͨ�Ź����У�˥��ϵ������Ϊһ�㶨������ʽ
    H_sd = RayleighCH( 1 );     % between Source and Destination
    H_sr = RayleighCH( 1 );  	% between Source and Relay station
    H_rd = RayleighCH( 1 );     % between Relay station and Destination
    
%% In different SNR in dB
    snrcount = 0;
    
for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB
    
	snrcount = snrcount+1;    % count for different BER under SNR_dB
    
	err_num_SD = 0;  % Used to count the error bit
	err_num_DF = 0;
    
    for tries=0:Monte_MAX
 
        sig = 10^(SNR_dB/10); % SNR, said non-dB
        POW_S1 = POW_DIV1;      % Signal power sr
        POW_S2 = POW_DIV2;      % Signal power rd
        POW_N1 = POW_S1 / sig;  % Noise power sr
        POW_N2 = POW_S2 / sig;  % Noise power rd

    % 'x_s' is transmitted from Source to Relay and Destination
    % AWGN:��ĳһ�ź��м����˹����
        y_sd = awgn( sqrt(POW)*H_sd * x_s, SNR_dB, 'measured');	% Destination received the signal 'y_sd' from Source %'measured'��ʾ�ⶨ�ź�ǿ��
        y_sr = awgn( sqrt(POW_DIV1)*H_sr * x_s, SNR_dB, 'measured');	% Relay received the signal 'y_sr' from Source
      %y = awgn(x,SNR,SIGPOWER) ���SIGPOWER����ֵ�����������dBWΪ��λ���ź�ǿ�ȣ����SIGPOWERΪ'measured'���������ڼ�������֮ǰ�ⶨ�ź�ǿ�ȡ�

    %01:Without Cooperation,Source node transmit the signal to Destination node directly��û��Э��������£�Դ�ڵ�ֱ����Ŀ�ĵؽڵ㷢���ź�
        y_SD = demodulate(modem.pskdemod(M),H_sd'*y_sd);
        err_num_SD = err_num_SD + Act_ber(x,y_SD);   % wrong number of bits without Cooperation   
    
    %03:With Fixed Decode-and-Forward relaying protocol�̶�����ת���м�Э�� 
        x_DF = DF(M,y_sr,x);
        y_rd = awgn( sqrt(POW_DIV2)*H_rd * x_DF, SNR_dB, 'measured');
        y_combine_DF = Mrc( H_sd,H_rd,POW_S2,POW_N2,POW_S2,POW_N2,y_sd,y_rd);
        y_DF = demodulate(modem.pskdemod(M),y_combine_DF);
        err_num_DF = err_num_DF + Act_ber(x,y_DF);   % wrong number of bits with DF
    end;% for tries=0:Monte_MAX
    
    % Calculated the actual BER for each SNR %ͨ��ͳ�����ؿ��޵�����������ȫ��������Ŀ���Ա�
	ber_SD(snrcount) = err_num_SD/(N*Monte_MAX);	
	ber_DF(snrcount) = err_num_DF/(N*Monte_MAX);
    % Calculated the theoretical BER for each SNR %�����Զ��庯���õ�
    theo_ber_SD(snrcount) = Theo_ber(SNR_dB);
    theo_ber_DF(snrcount) = Theo_ber(H_sd,H_rd,POW_S1,POW_N1,POW_S2,POW_N2);
        
end;    % for SNR_dB=MIN_SNR_dB:INTERVAL:MAX_SNR_dB

%% draw BER curves 
SNR_dB = MIN_SNR_dB:INTERVAL:MAX_SNR_dB;

end

