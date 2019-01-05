function func = objE( variable,lamda,Nsi,Nid,N,Nsd,M )
%多基站天线，多中继数的等功率分配函数
%   Detailed explanation goes here
E=zeros(1,M);
sum1=zeros(1,M);
func1=ones(1,1);
sum2=zeros(1,1);
for k=1:M
    E(1,k)=exp(-lamda/(variable*Nsi(k)))*exp(-lamda/((1-variable)*Nid(k)));
  
    for i=0:(N-1)
        sum1(1,k)=((lamda/((1-variable)*Nid(k)))^i)/jc(i)+sum1(1,k);
    end
end
%func1=1;
for m=1:M
    func1(1,1)=func1(1,1)*(1-E(1,m)*sum1(1,m));
end

%-------SD链路中断概率--------------------%
    for i=0:(N-1)
        sum2=((lamda/(variable*Nsd))^i)/jc(i)+sum2;
    end
    E1=exp(-lamda/(variable*Nsd));
    func2=1-E1*sum2;

    func=func2*func1;
end