 function NCM = cal_NCM(inputA,K,itcounts)

 %预处理操作
 dimA=size(inputA);
 M=dimA(1,1);%待求逆矩阵的阶数
 O=M/K;%子矩阵的阶数
 submatrixarr=cell(1,K);
 NCM=0;
 
 %对子矩阵赋值
 for i=1:K
     submatrixarr{1,i}=inputA((i-1)*O+1:i*O,(i-1)*O+1:i*O);
 end
 mD=blkdiag(submatrixarr{1,1:K});
 mDinv=mD^(-1);
 mE=inputA-mD;
 
 %计算每次迭代的乘法次数
 tempout=mDinv;
 temp=-mDinv*mE;
 NCM=cal_subNCM(mDinv,mE,M);
 for i=1:itcounts-1
     NCM=NCM+cal_subNCM(tempout,temp,M);
%      cal_subNCM(tempout,temp,M)
     tempout=tempout*temp;
 end
 