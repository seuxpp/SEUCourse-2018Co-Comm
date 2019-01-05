clc;
clear all;close all;

NCM=cell(4,1);
for i=1:4
    NCM{i}=[];
end

nTx1=[16 32 64 128 256];
nTx1_pie=log2(nTx1);
for i=1:5
    
% 天线配置
nTx = nTx1(i);%用户数
nRx = 4*nTx;%基站天线数
bl=1;%每个用户端天线数

%生成cW
Es = 1;
SNRdB = 10;
EsN0dB = SNRdB - 10*log10(nTx);
EsN0 = 10.^(EsN0dB/10);
N0 = Es./EsN0;
n=1;
cH =  newchennel(nRx,nTx,0.2,0,0,bl);
cG = cH'*cH;
cW = cG + eye(nTx)*N0(n);

NCM{1}(i)=calNCM_MLI(cW,6,7,2);
NCM{2}(i)=calNCM_TLI(cW,8,10,2);
end

nTx2=[16 64 256];
nTx2_pie=log2(nTx2);
for i=1:3
% 天线配置
nTx = nTx2(i);%用户数
nRx = 4*nTx;%基站天线数
bl=1;%每个用户端天线数

%生成cW
Es = 1;
SNRdB = 10;
EsN0dB = SNRdB - 10*log10(nTx);
EsN0 = 10.^(EsN0dB/10);
N0 = Es./EsN0;
n=1;
cH =  newchennel(nRx,nTx,0.2,0,0,bl);
cG = cH'*cH;
cW = cG + eye(nTx)*N0(n);

NCM{3}(i)=calNCM_MLI(cW,17,17,4);
NCM{4}(i)=calNCM_TLI(cW,15,15,4);
end

figure(1)
replot = semilogy(...
nTx1_pie,NCM{1},'.-',...
nTx1_pie,NCM{2},'.-',...
nTx2_pie,NCM{3},'.-',...
nTx2_pie,NCM{4},'.-',...
'LineWidth',2.5, 'MarkerSize',20);
set(replot(1),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);%橙色
set(replot(2),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);%黄色
set(replot(3),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);%
set(replot(4),'Color',[32, 88, 103]/256);%
grid on;
strLegend = {...
'$K=2,MLI,K_F=6,K_n=7$'...
'$K=2,TLI,K_F=8,K_n=10$'...
'$K=4,MLI,K_F=17,K_n=17$'...
'$K=4,TLI,K_F=15,K_n=15$'};
legend_handle = legend(strLegend,2);
set(legend_handle,'Interpreter','latex')
xlabel ('number of users'); ylabel ('number of complex-valued multiplications');
% xlim([16 64]);