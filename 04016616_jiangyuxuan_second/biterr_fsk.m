%%2fsk�����ʵļ���
clear;clc;
Eb=2;%ÿ��������
N=100000;%��Ԫ��Ŀ
SNR0=-5;
SNR1=15;
for j=SNR0:SNR1
snr=j;
snr1=10^(snr/10);%������ȵ�ֵ��dBת��Ϊ��ֵ
source=round(rand(1,N)); %����Դ�ź�% 
tb=0.001; %��Ԫ����%
ts=tb/10; %��������%
t=0:ts:(N*tb-2*ts);
fc1=8/tb; %�ز�1��Ƶ��% 
fc2=4/tb; %�ز�2��Ƶ��%
for csc=1:length(t)
 source_t(csc)=source(floor(csc/10)+1); %���������ź�% 
end
%----����----------
carrier1=cos(2*pi*fc1*t); %�ز�1%
carrier2=cos(2*pi*fc2*t); %�ز�2%
fmoded1=source_t.*carrier1;
fmoded2=(1-source_t).*carrier2;
fmoded=fmoded1+fmoded2; %����%
noise=randn(1,(10*N-1))*(sqrt(Eb/snr1));
s_t=fmoded+noise; %���Ÿ�˹������%
%----��ɽ�����˲�----------
fs_t1=s_t.*carrier1;
fs_t2=s_t.*carrier2;
fP=(1/tb-500)/5000; %ͨƵ%
fS=(1/tb+500)/5000; %��Ƶ%
[n,w]=buttord(fP,fS,1,20);
[b,a] = butter(n,w); %LPF����%
fdemoded1=filter(b,a,fs_t1); %�˲�1%
fdemoded2=filter(b,a,fs_t2); %�˲�2%
%----�����о�----------
fdemoded=fdemoded1-fdemoded2; %�Ƚ�1,2%
for i=1:N
y(i)=fdemoded(i*10-2);
if y(i)>=0;
signal(i)=1;
else signal(i)=0;
end
end
%%%%%%%%%%%%%%%%%����������%%%%%%%%%%%%% 
a1=find((signal-source)~=0);
error1=length(a1);
err1(snr-SNR0+1)=error1/N; %����������
err11(snr-SNR0+1)=erfc(sqrt(snr1/2))/2; %����������
end
%----��ͼ----------
x=[SNR0:SNR1];
figure(1);
semilogy(x,err1,'-*g',x,err11,'-.ob')
title('2FSK���������������������ʱȽ�')
legend('2FSK����������','2FPSK����������')
xlabel('���������(dB)');
ylabel('�������/�������');
grid on;
