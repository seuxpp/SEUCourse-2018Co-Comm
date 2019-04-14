function PL=PL_free(fc,dist,Gt,Gr)
%���ɿռ�·�����ģ��
%����
%      fc���ز�Ƶ��[Hz]
%    dist����վ���ƶ�̨֮��ľ���[m]
%      Gt���������������
%      Gr�����ջ���������
%���
%      PL��·�����[dB]
lamda=3e8/fc;
tmp=lamda./(4*pi*dist);
if nargin>2,tmp=tmp*sqrt(Gt);end
if nargin>3,tmp=tmp*sqrt(Gr);end
PL=-20*log10(tmp);