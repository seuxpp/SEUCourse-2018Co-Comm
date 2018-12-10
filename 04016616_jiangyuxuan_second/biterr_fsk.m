%%2fsk误码率的计算
clear;clc;
Eb=2;%每比特能量
N=100000;%码元数目
SNR0=-5;
SNR1=15;
for j=SNR0:SNR1
snr=j;
snr1=10^(snr/10);%将信噪比的值由dB转化为数值
source=round(rand(1,N)); %生成源信号% 
tb=0.001; %码元周期%
ts=tb/10; %抽样周期%
t=0:ts:(N*tb-2*ts);
fc1=8/tb; %载波1的频率% 
fc2=4/tb; %载波2的频率%
for csc=1:length(t)
 source_t(csc)=source(floor(csc/10)+1); %产生数字信号% 
end
%----调制----------
carrier1=cos(2*pi*fc1*t); %载波1%
carrier2=cos(2*pi*fc2*t); %载波2%
fmoded1=source_t.*carrier1;
fmoded2=(1-source_t).*carrier2;
fmoded=fmoded1+fmoded2; %调制%
noise=randn(1,(10*N-1))*(sqrt(Eb/snr1));
s_t=fmoded+noise; %加信高斯白噪声%
%----相干解调及滤波----------
fs_t1=s_t.*carrier1;
fs_t2=s_t.*carrier2;
fP=(1/tb-500)/5000; %通频%
fS=(1/tb+500)/5000; %阻频%
[n,w]=buttord(fP,fS,1,20);
[b,a] = butter(n,w); %LPF参数%
fdemoded1=filter(b,a,fs_t1); %滤波1%
fdemoded2=filter(b,a,fs_t2); %滤波2%
%----抽样判决----------
fdemoded=fdemoded1-fdemoded2; %比较1,2%
for i=1:N
y(i)=fdemoded(i*10-2);
if y(i)>=0;
signal(i)=1;
else signal(i)=0;
end
end
%%%%%%%%%%%%%%%%%计算误码率%%%%%%%%%%%%% 
a1=find((signal-source)~=0);
error1=length(a1);
err1(snr-SNR0+1)=error1/N; %仿真误码率
err11(snr-SNR0+1)=erfc(sqrt(snr1/2))/2; %理论误码率
end
%----画图----------
x=[SNR0:SNR1];
figure(1);
semilogy(x,err1,'-*g',x,err11,'-.ob')
title('2FSK仿真误码率与理论误码率比较')
legend('2FSK仿真误码率','2FPSK理论误码率')
xlabel('符号信噪比(dB)');
ylabel('误符号率/误比特率');
grid on;
