%两个等同发送者(接收端等增益合并)的实际性能曲线和理论曲线的比较,及与单链路的比较，若等同发送者每个
%的功率为p。则单链路发送者的功率为2p
tic
nr_of_iterations=100; %循环次数
SNR=[-13:2.5:12];%dB形式
global signal;%发送信号的全局变量
signal=generate_signal_structure;%发送信号结构体，包括传输比特数、传输字符数、每个字符包含的比特数、信号的调制方式、发送信号的比特序列、
                                 %发送信号的字符序列,传输完毕后接收到的比特序列,用来求误码率.
signal(1).modulation_type='QPSK'
signal.nr_of_bits=2^5;
calculate_signal_parameter;%发送信号准备完毕

channel=generate_channel_structure;
channel(1).attenuation(1).pattern='Rayleigh';
channel.attenuation(1).block_length=1;
channel(2)=channel(1);
channel(3)=channel(1);
channel(1).attenuation.distance=1;
channel(2).attenuation.distance=1;
channel(3).attenuation.distance=1;%for single link

rx=generate_rx_structure;
rx(1).combining_type='FRC';
rx.sd_weight=1;
rx(2)=rx(1);

h = waitbar(0,'Please wait...');
BER_2sender=zeros(size(SNR));
BER_1sender=zeros(size(SNR));
for iSNR=1:size(SNR,2)
    waitbar(iSNR/size(SNR,2));
    channel(1).noise(1).SNR=SNR(iSNR);
    channel(2).noise(1).SNR=SNR(iSNR);
    channel(3).noise(1).SNR=3+SNR(iSNR);
     for it=1:nr_of_iterations
          rx(1)=rx_reset(rx(1));
          [channel(1),rx(1)]=add_channel_effect(channel(1),rx(1),signal.symbol_sequence);
          rx(1)=rx_correct_phaseshift(rx(1),channel(1).attenuation.phi);
          [channel(2),rx(1)]=add_channel_effect(channel(2),rx(1),signal.symbol_sequence);
          rx(1)=rx_correct_phaseshift(rx(1),channel(2).attenuation.phi);
          rx(2)=rx_reset(rx(2));
          [channel(3),rx(2)]=add_channel_effect(channel(3),rx(2),signal.symbol_sequence);
          rx(2)=rx_correct_phaseshift(rx(2),channel(3).attenuation.phi);
          %接收端
          %%%%%%%%%%%%%%%%%%两个等同独立发送端%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          [received_symbol,signal.received_bit_sequence]=rx_combine(rx(1),channel,1); 
          BER_2sender(iSNR)=BER_2sender(iSNR)+sum(not(signal.received_bit_sequence==signal.bit_sequence));
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
          %%%%%%%%%%%%%%%%%%%单链路%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          [received_single_symbol,single_received_bit_sequence]=rx_combine(rx(2),channel,0);
          BER_1sender(iSNR)=BER_1sender(iSNR)+sum(not(single_received_bit_sequence==signal.bit_sequence));
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      end%end of iteration
   BER_2sender(iSNR)=BER_2sender(iSNR)./it./signal.nr_of_bits;
   BER_1sender(iSNR)=BER_1sender(iSNR)./it./signal.nr_of_bits;
    %计算两个等同发送者的理论ber 
    SNR_avg(iSNR)=10^(SNR(iSNR)/10);
    theo_ber(iSNR)=ber_2_sender(SNR_avg(iSNR),signal.modulation_type);
    single_link_theo_ber(iSNR)=ber(2*SNR_avg(iSNR),'QPSK','Rayleigh');
end
close(h);
%画出实际和理论误码率图
figure,semilogy(3+SNR,BER_2sender,'r-o',3+SNR,theo_ber,'k-',3+SNR,BER_1sender,'g-^',3+SNR,single_link_theo_ber,'b-')
legend('simulation 2sender','theory 2sender','simulation 1sender','theory single link');
xlabel('Eb/No (dB)');
ylabel('BER');
grid on;
hold on;



          
          
          
          
          
          
          
          