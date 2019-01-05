function func = objP( variable,lamda,Nsi,Nid,Nsd,M,SNR )
%多基站，多中继的适用于遗传算法的目标函数
%   Detailed explanation goes here
%-------SR,RD链路中断概率(链路2通)--------------------%
a=zeros(1,M);
b=zeros(1,M);
E=zeros(1,M);
E_sd=zeros(1,1);
E_sr=zeros(1,M);
%sum1=zeros(40,M);
func=ones(1,1);
func_1=ones(1,1);
func_sr=ones(1,1);
%sum2=zeros(40,1);
for k=1:M
    a(1,k)=(1./(variable.*SNR.*Nsd-(1-variable).*SNR.*Nid(k)));
    b(1,k)=(variable.*SNR.*Nsd.*exp(-lamda./(variable.*Nsd))-(1-variable).*SNR.*Nid(k).*exp(-lamda./((1-variable).*Nid(k))));
    E(1,k)=exp(-lamda./(variable.*Nsi(k)));
    %sum1=0;
    %sum2=0;
%     for i=0:(N-1)
%         sum1(:,k)=((lamda./((1-variable).*Nid(k))).^i)./jc(i)+sum1(:,k);
%     end
end
%func1=1;
for m=1:M
    func_1(1,1)=func_1(1,1).*(1-a(1,m).*b(1,m).*E(1,m));
   % func1(:,1)=func1(:,1).*(1-E(:,m).*sum1(:,m));
end

%-------SD链路中断概率--------------------%

    E_sd(1,1)=1-exp(-lamda./(variable.*Nsd));
%-------SR链路中断概率--------------------%    
for i=1:M
    E_sr(1,k)=1-exp(-lamda./(variable.*Nsi(i)));
end
for m=1:M
    func_sr(1,1)=func_sr(:,1).*E_sr(:,m);
   % func1(:,1)=func1(:,1).*(1-E(:,m).*sum1(:,m));
end

%-------总中断概率--------------------%    

     func=func_sr.*E_sd+func_1;
%     for i=0:(N-1)
%         sum2=((lamda./(variable.*Nsd)).^i)./jc(i)+sum2;
%     end
%     E1=exp(-lamda./(variable.*Nsd));
%     func2=1-E1.*sum2;
% 
%     func=func2.*func1;
end