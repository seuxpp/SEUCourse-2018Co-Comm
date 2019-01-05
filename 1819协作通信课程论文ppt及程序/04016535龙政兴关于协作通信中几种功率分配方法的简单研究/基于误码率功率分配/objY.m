function func = objY( variable,lamda,Nsi,Nid,N )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
E=exp(-lamda./(variable.*Nsi)).*exp(-lamda./((1-variable).*Nid));
sum=0;
for i=0:(N-1)
    sum=((lamda./((1-variable).*Nid)).^i)./jc(i)+sum;
end
func=1-E.*sum;
