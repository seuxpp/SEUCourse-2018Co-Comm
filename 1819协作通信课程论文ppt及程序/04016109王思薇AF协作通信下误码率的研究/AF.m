 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %12/17/2018     Wang Siwei
 %一个具有差错检测的AF仿真程序
 %并非原创，编解码部分有所借鉴（来自Pudn）
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo off;clear all;close all;clc;
tic
N=1000;
L=65;    %一帧长度
BerSnrTable=zeros(20,5);
for snr=0:25
    %snr = snrpot+snrpot;
    BerSnrTable(snr+1,1) = snr;
    sig=1/sqrt(10^(snr/10));
    %temp=0;%
    %temp1=0;%
    for i=1:N
        BitsTx = floor(rand(1,L)*2);
        P=mean(abs(BitsTx(:)).^2);
        %BitsTxcrc=CrcEncode(BitsTx);%
        BitsTxcnv=cnv( BitsTx);%确定二进制卷积编码器的输出序列
        Mod8Tx=mod_8psk(BitsTxcnv);%8PSK调制
        M=length(Mod8Tx);%M=36
        %以下为假设信道模型和噪声模型，由于本次仿真重点不在于此，所以做以下简化
        H1d=RayleighCH();%RayleighCH信道模型
        H12=RayleighCH();
        H2d=RayleighCH();
        Z1d=randn(1,M)+j*randn(1,M);
        Z12=randn(1,M)+j*randn(1,M);
        Z2d=randn(1,M)+j*randn(1,M);
        
        %user2接收并解码
        Y1d=H1d.*Mod8Tx+sig*Z1d;
        Y12=H12.*Mod8Tx+sig*Z12;
        R12=conj(H12).*Y12;
        BitR12=demod_8psk(R12);%8PSK解调
        BitR12viterbi=viterbi(BitR12);%硬判决译码和软判决译码，输出矩阵
        BitR12viterbi=BitR12viterbi(1:length(BitR12viterbi)-1);
        %[BitR12decrc,error]=CrcDecode(BitR12viterbi);%CrcDecode.m是网上找的开源代码，但是没用上
         %error=0,正确解码   error=1，错误解码
         %非协作情况
        %if(error==1)%
            R1d=conj(H1d).*Y1d; 
            BitR1d=demod_8psk(R1d);
            BitR1dviterbi=viterbi(BitR1d);
            BitR1dviterbi=BitR1dviterbi(1:length(BitR1dviterbi)-1);
            
            [Num1,Ber1] = symerr( BitR1dviterbi,BitsTx);
            BerSnrTable(snr+1,4)=BerSnrTable(snr+1,4)+Num1;
            
            %BitR1ddecrc=CrcDecode(BitR1dviterbi);%
            %[Num,Ber] = symerr(BitR1ddecrc,BitsTx);%
            %BerSnrTable(snr+1,2)=BerSnrTable(snr+1,2)+Num;%
        %end%
         %协作情况
        %if(error==0)%
            G=sqrt(P/(P*abs(H12).^2+2*sig*sig));
            Bits2d=BitR12viterbi;
            %Bits2dcrc=CrcEncode(Bits2d);%CRC编码输出
            Bits2dcnv=cnv(Bits2d);%确定二进制卷积编码器的输出序列
            Mod8_2d=mod_8psk(Bits2dcnv);
            Y2d=H2d.*G*(Mod8_2d+sig*Z12)+sig*Z2d;
            %最大合并比在此处的简化形式
            Rd=conj(H2d).*Y2d+conj(H1d).*Y1d;
            BitRd=demod_8psk(Rd);
            BitRdviterbi=viterbi(BitRd);
            BitRdviterbi=BitRdviterbi(1:length(BitRdviterbi)-1);
            %BitRddecrc=CrcDecode(BitRdviterbi);%%CRC编码输出
            [Num,Ber] = symerr( BitRdviterbi,BitsTx);%求得误比特率
            BerSnrTable(snr+1,2)=BerSnrTable(snr+1,2)+Num;%误码数累加
            %temp=temp+1;%
        %end   %
    end
    BerSnrTable(snr+1,3)=BerSnrTable(snr+1,2)/(L*N);
    BerSnrTable(snr+1,5)=BerSnrTable(snr+1,4)/(L*N);%求出误码率
    %BerSnrTable(snr+1,4)=temp;%
end   
semilogy(BerSnrTable(:,1),BerSnrTable(:,5),'bD-',BerSnrTable(:,1),BerSnrTable(:,3),'r*-');
xlabel('信噪比(SNR)');ylabel('误码率');title('AF下信噪比与误码率关系');
legend('协作模式','非协作模式')
%figure
%semilogy(BerSnrTable(:,1),BerSnrTable(:,4),'g*-');
time_of_sim = toc
echo on;


