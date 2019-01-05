function PathLost = PathLoss_free(fc,distance)
%自由空间路径损耗模型
%输入
%    fc：载波频率[Hz]
%    distance：基站和移动台之间的距离[m]

%输出
%    PL：路径损耗[dB]
lamda=3e8/fc;
tmp=lamda./(4*pi*distance);
PathLost=-20*log10(tmp);%式(1.2)/(1.3)