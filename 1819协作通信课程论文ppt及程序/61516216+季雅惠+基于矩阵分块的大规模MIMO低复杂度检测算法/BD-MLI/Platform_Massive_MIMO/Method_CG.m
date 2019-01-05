function [ x ] = Method_CG( A,b,k )
%code via Yoko.XUE 2015.10
%A,b are the elements in "Ax=b",M is the precondition matrix£¬k is the
%iterative time
%
v=0;

b=b(:,1);
r1=b;%%-Aw;
p=r1;

%Eps=norm(v-xu);%the distance between the result and the target
%initialization===============================================

for i=1:1:k
   
c=A*p;
    a=dot(r1,r1)/dot(p,c);
    v=v+a*p;
    r2=r1-a*c;
    beta=dot(r2,r2)/dot(r1,r1);
    r1=r2;
    p=r1+beta*p;
    
   %{
    c=A*p(:,i);
    a=dot(p(:,i),r1)/dot(p(:,i),c);
    v=v+a*p(:,i);
    r2=r1-a*c;
    beta=-dot(r2,A*p(:,i))/dot(p(:,i),A*p(:,i));
    r1=r2;
    p(:,i+1)=r1+beta*p(:,i);
    %}
end

x=v;
%{
sum=0;
for l=1:1:k+1
    sum=sum+(p(1,l)*p(1,l))/dot(p(:,l),A*p(:,l));
end
%}

end


