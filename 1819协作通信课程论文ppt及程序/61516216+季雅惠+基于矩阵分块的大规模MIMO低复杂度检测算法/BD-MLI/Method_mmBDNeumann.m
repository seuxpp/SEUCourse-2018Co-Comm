 function outputA = Method_mmBDNeumann(inputA,ka,bl)
% inputA=cW;
% ka=4;
% bl=4;

 dimA=size(inputA);
 m=log2(dimA(1,1));
 k=log2(bl);
 itmatrix=cell(1,m-k+1);%待求逆矩阵
 itmatrixinv=cell(1,m-k+1);%待求逆矩阵的逆矩阵
 for i=1:m-k+1
     itmatrix{1,i}=cell(1,2^(i-1));
     itmatrixinv{1,i}=cell(1,2^(i-1));
end
   
 %对itmatrix赋值
 for i=1:m-k+1
     for j=1:2^(i-1)
         itmatrix{1,i}{1,j}=inputA(2^(m-i+1)*(j-1)+1:2^(m-i+1)*j,2^(m-i+1)*(j-1)+1:2^(m-i+1)*j);
     end
 end
 
 %先对itmatrixinv{1,2^(m-k+1)}赋值
 for j=1:2^(m-k)
     itmatrixinv{1,m-k+1}{1,j}=itmatrix{1,m-k+1}{1,j}^(-1);
 end
 
 %对itmatrixinv初始化
 for i=1:m-k
     for j=1:2^(i-1)
         itmatrixinv{1,i}{1,j}=zeros(2^(m-i+1));
     end
 end
 
 %通过BDneumann迭代求itmatrixinv
 for i=m-k:-1:1
     %在第i层迭代中
     %先设置过渡矩阵，主要作用为blkdiag
     itmatrixtemp1=cell(1,2^(i-1));%存储该层迭代对角阵，即D
     itmatrixtemp2=cell(1,2^(i-1));%存储该层迭代非对角阵，即E
     itmatrixtemp3=cell(1,2^(i-1));%c存储该层迭代对角阵逆，即D^(-1)
     for j=1:2^(i-1)
         itmatrixtemp1{1,j}=blkdiag(itmatrix{1,i+1}{1,(j-1)*2+1:j*2});
         itmatrixtemp2{1,j}=itmatrix{1,i}{1,j}-itmatrixtemp1{1,j};
         itmatrixtemp3{1,j}=blkdiag(itmatrixinv{1,i+1}{1,(j-1)*2+1:j*2});
         %迭代开始
         for it=1:ka
             itmatrixinv{1,i}{1,j}=itmatrixinv{1,i}{1,j}+(-itmatrixtemp3{1,j}*itmatrixtemp2{1,j})^(it-1)*itmatrixtemp3{1,j};
         end
     end
 end
 
 outputA=itmatrixinv{1,1}{1,1};
 end
     
 
 
 
 
 
 
 
 
