function PL=PL_free(fc,dist,Gt,Gr)
%自由空间路径损耗模型
%输入
%      fc：载波频率[Hz]
%    dist：基站和移动台之间的距离[m]
%      Gt：发射机天线增益
%      Gr：接收机天线增益
%输出
%      PL：路径损耗[dB]
lamda=3e8/fc;
tmp=lamda./(4*pi*dist);
if nargin>2,tmp=tmp*sqrt(Gt);end
if nargin>3,tmp=tmp*sqrt(Gr);end
PL=-20*log10(tmp);