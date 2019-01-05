%简单main函数，用来测试基本的协同过程
tic
nr_of_iterations=1000; %循环次数
SNR=[-10:2.5:15];%dB形式
use_direct_link=1;%直接传输
use_relay=1;%通过伙伴传输
P=2;%总功率为2


global signal;%发送信号的全局变量
signal=generate_signal_structure;%发送信号结构体，包括传输比特数、传输字符数、每个字符包含的比特数、信号的调制方式、发送信号的比特序列、
                                 %发送信号的字符序列,传输完毕后接收到的比特序列,用来求误码率.
signal(1).modulation_type='QPSK';%信号调制类型
signal.nr_of_bits=2^10;%传输比特数
signal.position_x=-1;%信号源所处位置横坐标
signal.position_y=0;%信号源所处位置纵坐标
calculate_signal_parameter;%发送信号准备完毕

channel=generate_channel_structure;
channel(1).attenuation(1).pattern='Rayleigh'; %'no','Rayleigh'
channel.attenuation(1).block_length=1;%块长(bit/block)
channel(2)=channel(1);
channel(3)=channel(1);%三信道模式相同
channel(1).attenuation.distance=1; %信号传输距离
channel(2).attenuation.distance=0.75;
channel(3).attenuation.distance=0.25;

rx=generate_rx_structure;%为接收参数创建结构体
rx(1).combining_type='ESNRC';%'ERC','FRC','SNRC','ESNRC','MRC'合并方案
rx.rx_position_x=1;
rx.rx_position_y=0;%位置
rx.sd_weight=2;%加权值为2
rx(2)=rx(1);%负责没有协同情况下的接收


global relay;
relay=generate_relay_structure;%为relay创建结构体
relay(1).mode='AAF';       
relay.magic_genie=0;
relay.rx=rx(1); %relay的接收部分为rx（1）
h = waitbar(0,'Please wait...');%打开或更新等待条对话框
BER=zeros(size(SNR));%比特出错概率初始化
BER_1sender=zeros(size(SNR));
for iSNR=1:size(SNR,2)
    waitbar(iSNR/size(SNR,2));
    channel(1).noise(1).SNR=SNR(iSNR);
    channel(2).noise(1).SNR=SNR(iSNR);
    channel(3).noise(1).SNR=SNR(iSNR); %生成不同信噪比的channel 
    for it=1:nr_of_iterations
        %Reset receiver
        rx(1)=rx_reset(rx(1));%每次循环开始，将rx（1）置0
        rx(2)=rx_reset(rx(2));%负责非协同情况
        relay.rx=rx_reset(relay.rx);
        
        [channel(1)]=get_channel_muti_parameter(channel(1),signal.symbol_sequence,1);%获得信道乘性噪声
        [noise_vector_sd,channel(1),asd]=get_channel_white_noise(channel(1),signal.symbol_sequence);%获得信道加性高斯白噪声，并且得到的a值用来进行功率分配
        
        [channel(2)]=get_channel_muti_parameter(channel(2),signal.symbol_sequence,1);
        [noise_vector_sr,channel(2),asr]=get_channel_white_noise(channel(2),signal.symbol_sequence);
        
        [channel(3)]=get_channel_muti_parameter(channel(3),signal.symbol_sequence,1);
        [noise_vector_rd,channel(3),ard]=get_channel_white_noise(channel(3),signal.symbol_sequence);
        
        %功率分配
        [Ps,Pr]=power_allocate(P,asd,asr,ard,'FRC','Best','AAF',rx(1).sd_weight);
        
        %direct link
        if(use_direct_link==1)
        [rx(1)]=add_PA_and_channel_effect(channel(1),signal.symbol_sequence,rx(1),Ps,noise_vector_sd);
        rx(1)=rx_correct_phaseshift(rx(1),channel(1).attenuation.phi);
        end
        
        
        %Multi-hop
        if (use_relay==1)
            %sender to relay
            [relay.rx]=add_PA_and_channel_effect(channel(2),signal.symbol_sequence,relay.rx,Ps,noise_vector_sr);%ps
            relay=prepare_relay2send(relay,channel(2),Ps,Pr);%relay接收信号，为转发做准备
            %relay to destination 转发
            [rx(1)]=add_PA_and_channel_effect(channel(3),relay.signal2send,rx(1),Pr,noise_vector_rd);%pr
            switch relay.mode
                case 'AAF'
                    rx(1)=rx_correct_phaseshift(rx(1),channel(2).attenuation.phi+channel(3).attenuation.phi);
                case 'DAF'
                    rx(1)=rx_correct_phaseshift(rx(1),channel(3).attenuation.phi);
                otherwise
                    error(['Relay-mode unknown:',relay.mode]);
            end
        end
      
        
        %receiver
        [received_symbol,signal.received_bit_sequence]=rx_combine(rx(1),channel,use_relay,Ps);
        
        BER(iSNR)=BER(iSNR)+sum(not(signal.received_bit_sequence==signal.bit_sequence));
        
        %不协同情况，只有一条单链路
        [rx(2)]=add_PA_and_channel_effect(channel(1),signal.symbol_sequence,rx(2),P,noise_vector_sd);
        rx(2)=rx_correct_phaseshift(rx(2),channel(1).attenuation.phi);
        [received_single_symbol,single_received_bit_sequence]=rx_combine(rx(2),channel,0,P);
        BER_1sender(iSNR)=BER_1sender(iSNR)+sum(not(single_received_bit_sequence==signal.bit_sequence));
    end%end of iteration
    
    BER(iSNR)=BER(iSNR)./it./signal.nr_of_bits; %误码率算法
    BER_1sender(iSNR)=BER_1sender(iSNR)./it./signal.nr_of_bits;
    %计算只有单链路的理论ber
    SNR_avg(iSNR)=10^(SNR(iSNR)/10);
    single_link_theo_ber(iSNR)=ber(SNR_avg(iSNR),'QPSK','Rayleigh');
end; 
close(h);
%画出实际和理论误码率图
%figure,
%semilogy(SNR,single_link_theo_ber,'g-^');
semilogy(SNR,BER,'r-+');
%semilogy(SNR,BER,'g-+',SNR,BER_1sender,'r->');%SNR,single_link_theo_ber,'k-');
legend('Combining type MRC QPSK Rayleign','Combining type EGC QPSK Rayleign','Combining type SC QPSK Rayleign');
xlabel('Eb/No (dB)');
ylabel('BER');
grid on;
hold on;












