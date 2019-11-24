function PathLost = PathLoss_free(fc,distance,Gt,Gr)
%���ɿռ�·�����ģ��
%����
%    fc���ز�Ƶ��[Hz]
%    distance����վ���ƶ�̨֮��ľ���[m]
%    Gt���������������
%    Gr�����ջ���������
%���
%    PL��·�����[dB]
lamda=3e8/fc;
tmp=lamda./(4*pi*distance);
if nargin>2,tmp=tmp*sqrt(Gt);end  
if nargin>3,tmp=tmp*sqrt(Gr);end
PathLost=-20*log10(tmp);%ʽ(1.2)/(1.3)