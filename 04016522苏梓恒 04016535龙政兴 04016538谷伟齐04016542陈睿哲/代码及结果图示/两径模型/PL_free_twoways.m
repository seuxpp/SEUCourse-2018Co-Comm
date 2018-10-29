function PL=PL_free1(ht,hr,dist,Gt,Gr)
%两径模型
%输入
%    ht：发射天线的有效高度
%    hr：接收天线的有效高度
%    dist：发射机和接收机之间的距离[m]
%    Gt：发射机天线增益
%    Gr：接收机天线增益
%输出
%    PL：路径损耗[dB]
tmp=(ht*hr)./(dist.*dist);
if nargin>2,tmp=tmp*sqrt(Gt);end % nargin_输入参数的个数
if nargin>3,tmp=tmp*sqrt(Gr);end
PL=-20*log10(tmp);%式(1.2)/(1.3)