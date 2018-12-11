%Author: Shaoqing Yu
%AF����ϵͳ���ܵ��о�
clear,clf;
datestr(now)
    min_SNR = 0;          %���ñ߽�ֵ
    max_SNR= 12;
    interval_plot = 0.5;	
    pow_division = 1/2;  %��Դ��Ŀ�ĺ��м̷�50%����                      
    Monte=10;      % ���ؿ���ѭ���Ĵ���
  
    H_sd = R_channel(1);     %Դ��Ŀ��֮�������˥����ѡȡ����Ϊ1
    H_sr = R_channel(1);  	% Դ���м�֮�������˥��
    H_rd = R_channel(1);     % �м̺�Ŀ��֮�������˥��
     
    M = 2;N = 10000;   % �������ͱ�����
    %%
    x = randi(M,1,N)-1;                 %����һ��1*N�ľ��󣬾���������Ԫ��ȡֵ��ΧΪ[0,(M-1)]
    h = modem.pskmod(2);                  %����2psk������           ��ʱûѧ psk���ƣ���Щ�����
    x_s=modulate(h,x);                   %���Ʋ���Դ�ź�
  %%
    length= (max_SNR-min_SNR)/interval_plot+1;
    count = 0;
    %�����ֵ���������ٶ�
    ber_SD=zeros(1,	length);ber_AF=zeros(1,	length);
    theo_ber_SD=zeros(1,length);theo_ber_AF=zeros(1,length);
    
for SNR_dB=min_SNR:interval_plot:max_SNR   %��ѭ��
	count = count+1;    % ��Ϊ�±����
	err_num_SD = 0;  % ��������еĴ��������
	err_num_AF = 0;
    
    for nums=0:Monte        %��ѭ��
 
        real_sig = 10^(SNR_dB/10);  %����ʵ���ź�dbֵת��Ϊʮ������ֵ
        POW_S =  pow_division;      % �źŹ��ʣ��Ѿ�������Ϊ50%
        POW_N =  pow_division/real_sig;    % ��������
        
        %%
    % AWGN:��ĳһ�ź��м����˹����  
        y_sd = awgn( sqrt( pow_division)*H_sd * x_s, SNR_dB, 'measured');	% Destination received the signal 'y_sd' from Source %'measured'��ʾ�ⶨ�ź�ǿ��
        y_sr = awgn( sqrt( pow_division)*H_sr * x_s, SNR_dB, 'measured');	% Relay received the signal 'y_sr' from Source
      %y = awgn(x,SNR,SIGPOWER) ���SIGPOWER����ֵ�����������dBWΪ��λ���ź�ǿ�ȣ����SIGPOWERΪ'measured'���������ڼ�������֮ǰ�ⶨ�ź�ǿ�ȡ�
%%
     %ֱ��direct
        y_SD = demodulate(modem.pskdemod(M),H_sd'*y_sd);       %�Ƚ��
        err_num_SD = err_num_SD + cal_err_bit(x,y_SD);   % ֱ�������Ĵ�������
    
    %AF
        [beta,x_AF] = tran_AF(H_sr,POW_S,POW_N,y_sr);  %beta Ϊ�Ŵ�ϵ��
        y_rd = awgn( sqrt(POW_S)*H_rd * x_AF, SNR_dB, 'measured');	  %Ŀ���յ��������м̵ĺ���˹���������ź�     
        y_combine_AF = MRC( beta,H_sd,H_sr,H_rd,POW_S,POW_N,POW_S,POW_N,y_sd,y_rd);  % ���ն�MRC�ϲ�        
        y_AF = demodulate(modem.pskdemod(M),y_combine_AF); % BPSK���MRC�ϲ�����ź� 
        err_num_AF = err_num_AF + cal_err_bit(x,y_AF);   % AFЭ���������ܵ�������
   
    end;% for nums=0:Monte
    
    %ͨ��ͳ�����ؿ��޵�����������ȫ��������Ŀ���Աȣ�����ȫ��������
	ber_SD(count) = err_num_SD/(N*Monte);                 
	ber_AF(count) = err_num_AF/(N*Monte);

    % ��������������
    theo_ber_SD(count) = 1 / ( 2 * sqrt(pi*SNR_dB)) * exp(-SNR_dB);  
    theo_ber_AF(count) = Theo_BER(H_sd,H_sr,H_rd,POW_S,POW_N,POW_S,POW_N);
        
end;    %for SNR....

SNR_dB = min_SNR:interval_plot:max_SNR;

figure(1)  % Direct and AF��ʵ���������
semilogy(SNR_dB,ber_SD,'r-o',SNR_dB,ber_AF,'b-+');     %semilogx�ð���������ͼ,x����log10��y�����Եģ�semilogy�ð���������ͼ,y����log10��x�����Ե�
legend('ֱ��','AFЭ��');              
grid on; 
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('AF��ֱ����ʵ���������');
axis([min_SNR,max_SNR,10^(-5),1]);

figure(2)  % SD,AF ��������ʵ�����ֵ
semilogy(SNR_dB,theo_ber_SD,'r-o',SNR_dB,theo_ber_AF,'b-+');
legend('ֱ��','AF');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('ֱ����AF������������');
axis([min_SNR,max_SNR,10^(-5),1]);

figure(3)  %  AF and SD��ʵ��ֵ������ֵ��������ʵıȽ�
subplot(2,1,1)
semilogy(SNR_dB,theo_ber_AF,'r-o',SNR_dB,ber_AF,'b-+');
legend('�����������','ʵ���������');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('AFЭ����ƽ����ʵ�ʵ��������');
axis([min_SNR,max_SNR,10^(-5),1]);
subplot(2,1,2)
semilogy(SNR_dB,theo_ber_SD,'r-o',SNR_dB,ber_SD,'b-+');
legend('�����������','ʵ���������');
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('ֱ����ʵ�ʣ�����������ʱȽ�');
axis([min_SNR,max_SNR,10^(-5),1]);