function PL=PL_logdist_or_norm1(ht,hr,d,d0,n,sigma)
%对数距离或对数阴影衰落路径损耗的两径模型
%输入
%    ht：发射天线的有效高度
%    hr：接收天线的有效高度
%    d：发射机和接收机之间的距离[m]
%    d0：参考距离[m]
%    n：路径损耗指数
%    sigma：方差[dB]
%输出
%    PL：路径损耗[dB]
PL=-20*log10((ht*hr)./(d.*d))+10*n*log10(d/d0);%式(1.4)
if nargin>5
    PL=PL+sigma*randn(size(d));%式(1.5)
end