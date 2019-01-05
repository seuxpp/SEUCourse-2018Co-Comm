 function NCM = cal_subNCM(A,B,M)
 NCM=0;
 for i=1:M
     for j=1:M
         for k=1:M
             if A(i,k)~=0&&B(k,j)~=0
                 NCM=NCM+1;
             end
         end
     end
 end