%改进的相关MIMO信道
%参考“Parametrization Based Limited Feedback Design for Correlated MIMO
%Channels Using New Statistical Models”
%单径
function hh = newchennel(RS,TS,ratio1,ratio2,ratio3,bl)
% RS=128;TS=16;ratio1=0;ratio2=0;bl=1;
% 输入：
%       RS：接收天线数
%       TS：发射天线数
%       ratio： 信道相关系数，0-1
%       phase:论文信道模型中的一个系数
% 输出：
%       hh: BSxMS相关信道
h = sqrt(1/2)*(randn(RS,TS)+1i*randn(RS,TS));
% if nargin<3        %输出不相关瑞利信道矩阵
%     hh=h;
%     return;
% end
%%---------------------------------------------------
if ratio1~=0
R=eye(RS);
%用户相关矩阵形成,R(p,q)
for p = 1:RS
    for q=(p+1):RS           %q>p
        R(p,q) = (exp(1i*rand*pi/2)*ratio1)^(q-p);
    end
end
R = R + R';       %共轭对称
R = R - eye(RS);
C = Cholesky(R);   
% C = chol(R);  
else
    C=eye(RS);
end%%cholesky分解得到上三角矩阵
%%--------------------------------------------------------
%用户相关矩阵形成,R(p,q)
%%-----------------------------------------------------
T=eye(TS);
for p = 1:TS
    for q=(p+1):TS           %q>p
        T(p,q) = (exp(1i*rand*pi/2)*ratio2)^(q-p);
    end
end

% 后加
for bln=1:(TS/bl)
   for p=bl*(bln-1)+1:bl*bln
       for q=(p+1):bl*bln
%          T(p,q) = (exp(1i*rand*pi/2)*2*ratio2)^(q-p);
           T(p,q) = (exp(1i*rand*pi/2)*ratio3)^(q-p);
       end
    end
end

T = T + T';       %共轭对称
T = T - eye(TS);
% L = chol(T);  
L=Cholesky(T);
% else
%     L=eye(TS);
% end%%cholesky分解得到上三角矩阵
%%----------------------------------------------------
%对信道矩阵相关性
   hh = C*h*L;
%    if(ratio1==0&&ratio2==0)
%        hh=h;
%    end
end
   %hh=h;
