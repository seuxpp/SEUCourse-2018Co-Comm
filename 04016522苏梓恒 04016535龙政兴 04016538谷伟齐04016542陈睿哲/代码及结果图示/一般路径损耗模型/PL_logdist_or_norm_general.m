function PL=PL_logdist_or_norm2(K,d,d0,n,sigma)
%对数距离或对数阴影衰落路径损耗的两径模型
%输入
%    K：一个与天线增益和平均信道衰减相关的常数，从参考距离 d0 处接触功率的经验平均获得
%    d：发射机和接收机之间的距离[m]
%    d0：参考距离[m]
%    n：路径损耗指数
%    sigma：方差[dB]
%输出
%    PL：路径损耗[dB]
PL=10*log10(K)-10*n*log10(d/d0);%式(1.3)
if nargin>4
    PL=PL+sigma*randn(size(d));%式(1.4)
end