clc;
clear all;close all;

% 天线配置
nRx = 256;%基站天线数
nTx = 64;%用户数
bl=1;%每个用户端天线数
itcounts=4;%迭代次数

% 信噪比定义
Es = 1;
% SNRdB = 4:2:16;
SNRdB = 10;
EsN0dB = SNRdB - 10*log10(nTx);
% EsN0dB = SNRdB - 10*log10(nTx);
%Eb = Es/k;
%EbN0dB = EsN0dB - 10*log10(k);
%EbN0 = 10.^(EbN0dB/10);
EsN0 = 10.^(EsN0dB/10);
N0 = Es./EsN0;
n=1;

K=[2 4 8 16 32 64];%子矩阵个数
K1=log2(K);
L=length(K);
resultarr=zeros(1,L);

for i=1:L
cH =  newchennel(nRx,nTx,0.2,0,0,bl);
cG = cH'*cH;
cW = cG + eye(nTx)*N0(n);
resultarr(i)=calNCM_TLI(cW,8,10,K(i));
end

figure(1)
replot = plot(...
K1,resultarr,'.-',...
'LineWidth',2.5, 'MarkerSize',20);
set(replot(1),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
% grid on;
% strLegend = {...
% '$K_F=4,K_n=5$'};
% legend_handle = legend(strLegend);
% set(legend_handle,'Interpreter','latex')
xlabel ('\itK'); ylabel ('number of complex-valued multiplications');

