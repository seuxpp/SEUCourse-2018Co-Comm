%open source from Dr. Wu
function PL=PL_logdist_or_norm(fc,d,d0,n,sigma)
%对数距离或对数阴影衰落路径损耗模型
%输入
%    fc：载波频率[Hz]
%    d：基站和移动台之间的距离[m]
%    d0：参考距离[m]
%    n：路径损耗指数
%    sigma：方差[dB]
%输出
%    PL：路径损耗[dB]
lamda=3e8/fc;
PL=-20*log10(lamda/(4*pi*d0))+10*n*log10(d/d0);%式(1.4)
if nargin>4
    PL=PL+sigma*randn(size(d));%式(1.5)
end