function triW=tridiagonal(W)
 dimA=size(W);
 M=dimA(1,1);
 triW=zeros(dimA);
 for i=2:M-1
   for j=i-1:i+1
     triW(i,j)=W(i,j);
   end
 end
triW(1,1)=W(1,1);
triW(1,2)=W(1,2);
triW(M,M-1)=W(M,M-1);
triW(M,M)=W(M,M);
 
