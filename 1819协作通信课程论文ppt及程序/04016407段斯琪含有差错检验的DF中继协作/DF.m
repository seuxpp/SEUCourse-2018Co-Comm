N=100;
L=65;    %一帧长度
BerSnrTable=zeros(20,5);
for snr=0:25
    BerSnrTable(snr+1,1) = snr;      %将dB转化为十进制数值
    sig=1/sqrt(10^(snr/10));
    temp=0;
    temp1=0;
    for i=1:N
        BitsTx = floor(rand(1,L)*2);            %向下取整；BitsTx为初始输入信号
        BitsTxcrc=CrcEncode(BitsTx);            %循环检测编码；BitsTxcrc为循环编码后的信号
        BitsTxcnv=cnv(BitsTxcrc);               %二进制卷积编码
        Mod8Tx=mod_8psk(BitsTxcnv);             %8PSK编码
        M=length(Mod8Tx);                        %8PSK编码后的序列长度
        
        %以下为假设信道模型和噪声模型，由于本次仿真重点不在于此，所以做以下简化
        H1d=RayleighCH();                       %用户1和目的节点之间的信道
        H12=RayleighCH();                       %用户1和用户2之间的信道
        H2d=RayleighCH();                       %用户2和目的节点之间的信道   
        Z1d=randn(1,M)+1i*randn(1,M);           %用户1和目的节点之间的噪声
        Z12=randn(1,M)+1i*randn(1,M);           %用户1和用户2之间的噪声
        Z2d=randn(1,M)+1i*randn(1,M);           %用户2和目的节点之间的噪声
        % 目的节点接收到用户1即源节点的功率
        Y1d=H1d.*Mod8Tx+sig*Z1d;                %目的节点接收到的用户1的信号功率和噪声功率之和
        %user2接收并解码
        Y12=H12.*Mod8Tx+sig*Z12;                %用户2接收用户1的信号功率和噪声功率之和
        R12=conj(H12).*Y12;                     %conj为取共轭
        BitR12=demod_8psk(R12);                 %8PSK方式解码，BitRsr为解码后的码
        BitR12viterbi=viterbi(BitR12);          %最优路径****************不懂viterbi函数具体干嘛的
        BitR12viterbi=BitR12viterbi(1:length(BitR12viterbi)-1);
        [BitR12decrc,error]=CrcDecode(BitR12viterbi);    %BitRsrdecrc为中继解码后的码；error为1则有错，为0则无错
         %error=0,正确解码   error=1，错误解码
         %非协作情况
        if(error==1)
            R1d=conj(H1d).*Y1d; 
            BitR1d=demod_8psk(R1d);           %目的节点接收到的用户1的8PSK解码
            BitR1dviterbi=viterbi(BitR1d);    %viterbi译码
            BitR1dviterbi=BitR1dviterbi(1:length(BitR1dviterbi)-1);
            BitR1ddecrc=CrcDecode(BitR1dviterbi);  %循环解码，BitR1ddecrc为循环解码得到的码
            [Num,Ber] = symerr(BitR1ddecrc,BitsTx);         %symerr函数用来计算错误符号的个数和误符号率
                                                             %Num指出了两组数据集相比不同符号的个数；Ber为误码率，它等于Num除以总符号数
            BerSnrTable(snr+1,2)=BerSnrTable(snr+1,2)+Num;
        end
         %协作情况
        if(error==0)
            Bits2d=BitR12decrc;                %用户2解码后准备发送至目的节点的码  
            Bits2dcrc=CrcEncode(Bits2d);       %对解码后的码进行循环编码
            Bits2dcnv=cnv(Bits2dcrc);          %二进制卷积编码
            Mod8_2d=mod_8psk(Bits2dcnv);       %对编码后的码进行8PSK调制
            Y2d=H2d.*Mod8_2d+sig*Z2d;          %目的节点接收到的用户2的功率
            %最大合并比在此处的简化形式
            Rd=conj(H2d).*Y2d+conj(H1d).*Y1d; %目的节点收到的用户1和用户2的信号之和
            BitRd=demod_8psk(Rd);               %目的节点对接收到的总信号的码进行8PSK方式解码
            BitRdviterbi=viterbi(BitRd);        %viterbi译码
            BitRdviterbi=BitRdviterbi(1:length(BitRdviterbi)-1);
            BitRddecrc=CrcDecode(BitRdviterbi);  %循环解码
            [Num,Ber] = symerr(BitRddecrc,BitsTx);   %symerr函数用来计算错误符号的个数和误符号率
                                                       %Num指出了两组数据集相比不同符号的个数；Ber为误码率，它等于Num除以总符号数
            BerSnrTable(snr+1,2)=BerSnrTable(snr+1,2)+Num;
            temp=temp+1;
        end   
    end
    BerSnrTable(snr+1,3)=BerSnrTable(snr+1,2)/(L*N);  %此处将M改成N
    BerSnrTable(snr+1,4)=temp;
end   
semilogy(BerSnrTable(:,1),BerSnrTable(:,3),'r*-');
grid on;
figure
semilogy(BerSnrTable(:,1),BerSnrTable(:,4),'g*-');
grid on;
time_of_sim = toc; %记录程序完成时间
echo on;