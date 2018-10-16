syms x1 z1;
L1=def(1)+def(2)*z1+def(3)*z1^2;
L2=ab(1)+ab(2)*x1;
L3=x1-250;
L=L1*L2*L3-z1;
dx1=diff(L,x1)
dz1=diff(L,z1)
[xm,zm]=solve(dx1,dz1);
xm=double(xm)
zm=double(zm)
A=diff(L,x1,2)
B=diff(diff(L,x1),z1)
C=diff(L,z1,2)