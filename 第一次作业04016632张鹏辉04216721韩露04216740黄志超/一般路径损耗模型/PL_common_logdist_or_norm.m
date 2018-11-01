function PL2=PL_common_logdist_or_norm(K,d,d0,a,sigma)
%对数距离或对数阴影衰落路径损耗模型
%输入
%    fc：载波频率[Hz]
%    d：基站和移动台之间的距离[m]
%    d0：参考距离[m]
%    n：路径损耗指数
%    sigma：方差[dB]
%输出
%    PL：路径损耗[dB]
tmp=d/d0;
PL2=-log10(K)+10*a*log10(tmp);%式(1.4)
if nargin>4
    PL2=PL2+sigma*randn(size(d));%式(1.5)
end