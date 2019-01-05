 function outputA = Method_MLI(inputA,k1,k2,K)
% inputA=cW;
% k1=5;
% k2=5;
% bl=4;

 dimA=size(inputA);
 %所需要的迭代层数m
 if K==2
     m=log2(dimA(1,1));
 else 
     m=log2(dimA(1,1))/2;
 end
%  k=log2(bl);
 itmatrix=cell(1,m+1);%待求逆矩阵
 itmatrixinv=cell(1,m+1);%待求逆矩阵的逆矩阵
 for i=1:m+1 %第i层迭代
     itmatrix{1,i}=cell(1,K^(i-1)); %第i层迭代中有K^(i-1)个待求逆矩阵
     itmatrixinv{1,i}=cell(1,K^(i-1)); 
end
   
 %对itmatrix赋值
 for i=1:m+1
     for j=1:K^(i-1)
         itmatrix{1,i}{1,j}=inputA(K^(m-i+1)*(j-1)+1:K^(m-i+1)*j,K^(m-i+1)*(j-1)+1:K^(m-i+1)*j);
     end
 end
 
 %先对itmatrixinv{1,K^(m+1)}赋值，即对第m+1层迭代赋值
 for j=1:K^(m)
     itmatrixinv{1,m+1}{1,j}=itmatrix{1,m+1}{1,j}^(-1);
 end
 
 %对前m层迭代itmatrixinv初始化
 for i=1:m
     for j=1:K^(i-1)
         itmatrixinv{1,i}{1,j}=zeros(K^(m-i+1));
     end
 end
 
 %通过BDneumann迭代求itmatrixinv
 for i=m:-1:1
     %在第i层迭代中
     %先设置过渡矩阵，主要作用为blkdiag
     itmatrixtemp1=cell(1,K^(i-1));%存储该层迭代对角阵，即D
     itmatrixtemp2=cell(1,K^(i-1));%存储该层迭代非对角阵，即E
     itmatrixtemp3=cell(1,K^(i-1));%存储该层迭代对角阵逆，即D^(-1)
     for j=1:K^(i-1)
         itmatrixtemp1{1,j}=blkdiag(itmatrix{1,i+1}{1,(j-1)*K+1:j*K});
         itmatrixtemp2{1,j}=itmatrix{1,i}{1,j}-itmatrixtemp1{1,j};
         itmatrixtemp3{1,j}=blkdiag(itmatrixinv{1,i+1}{1,(j-1)*K+1:j*K});
         %迭代开始
         if i==1
             for it=1:k1
                 itmatrixinv{1,i}{1,j}=itmatrixinv{1,i}{1,j}+(-itmatrixtemp3{1,j}*itmatrixtemp2{1,j})^(it-1)*itmatrixtemp3{1,j};
             end
         else
         for it=1:k2
             itmatrixinv{1,i}{1,j}=itmatrixinv{1,i}{1,j}+(-itmatrixtemp3{1,j}*itmatrixtemp2{1,j})^(it-1)*itmatrixtemp3{1,j};
         end
         end
     end
 end
 
 outputA=itmatrixinv{1,1}{1,1};