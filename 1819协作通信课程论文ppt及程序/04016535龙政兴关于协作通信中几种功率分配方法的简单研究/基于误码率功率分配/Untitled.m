clear all;
close all;
clc;

N=1;%基站天线数
M=3;% 一个中继
S=1;%一个源节点
Nsi=rand(1,M)*2+1;%源节点到中继的噪声方差 1-3的随机数
Nid=rand(1,M)*2;%中继节点到目的节点的噪声方差 0-2的随机数
R=1;%速率限制,用于判断中断概率 单位是bit/是/Hz
Nsd=0.7;

   %e_v=(1/2).*ones(40,1);
co=1;
for SNR=0:3:30  %信噪比
SNR_power=10^(SNR/10);
    lamda_E=(2^(2*R)-1)/SNR_power;
% figure(1);
% fplot('variable.*sin(10*pi*variable)+2.0',[-1,2]);   %画出函数曲线
%定义遗传算法参数
NIND=40;        %个体数目(Number of individuals)
MAXGEN=50;      %最大遗传代数(Maximum number of generations)
PRECI=20;       %变量的二进制位数(Precision of variables)
GGAP=0.9;       %代沟(Generation gap)
trace=zeros(2, MAXGEN);                        %寻优结果的初始值
FieldD=[20;0;1;1;0;1;1];                      %区域描述器(Build field descriptor)
Chrom=crtbp(NIND, PRECI);                      %初始种群
gen=0;                                         %代计数器
variable=bs2rv(Chrom, FieldD);                 %计算初始种群的十进制转换
ObjV=obj(variable,lamda_E,Nsi,Nid,Nsd,M,SNR_power);        %计算目标函数值
while gen<MAXGEN
   FitnV=ranking(ObjV);                                 %分配适应度值(Assign fitness values)         
   SelCh=select('sus', Chrom, FitnV, GGAP);               %选择
   SelCh=recombin('xovsp', SelCh, 0.7);                   %重组
   SelCh=mut(SelCh);                                      %变异
   variable=bs2rv(SelCh, FieldD);                         %子代个体的十进制转换
   ObjVSel=variable.*sin(10*pi*variable)+2.0;             %计算子代的目标函数值
   [Chrom ObjV]=reins(Chrom, SelCh, 1, 1, ObjV, ObjVSel); %重插入子代的新种群
   variable=bs2rv(Chrom, FieldD);
   gen=gen+1;                                             %代计数器增加
   %输出最优解及其序号，并在目标函数图像中标出，Y为最优解,I为种群的序号
   [Y, I]=min(ObjV);
   OP=variable(I)
   hold on;
   Popt(co)=Y;
   %e_v=(1/2).*ones(40,1);
   Pnor(co)=objP(0.5,lamda_E,Nsi,Nid,Nsd,M,SNR_power);
   %Py(SNR+1)=objY(OP,lamda_E,Nsi,Nid,N);
   %figure (2)
  % plot(variable(I), Y, 'bo');
%    trace(1, gen)=max(ObjV);                               %遗传算法性能跟踪
%    trace(2, gen)=sum(ObjV)/length(ObjV);
end
co=co+1
end
Popt
Pnor
%SNR=1:1:25;
S=0:3:30;
xlabe=S;
ylabe=Popt;
ylabe1=Pnor;
axis([0 25 0 1]);
semilogy(xlabe,ylabe,'-r*');
hold on;
semilogy(xlabe,ylabe1,'-ko')
legend('Adaptive PA','Uniform PA')
xlabel('P/N0(dB)'),ylabel('Outage probability')
% hold on;
% semilogy(S,Py,'-ko')
grid on;
% variable=bs2rv(Chrom, FieldD)                            %最优个体的十进制转换
% hold on, grid;
% plot(variable,ObjV,'b*');
% figure(2);
% plot(trace(1,:));
% hold on;
% plot(trace(2,:),'-.');grid
% legend('解的变化','种群均值的变化')
    