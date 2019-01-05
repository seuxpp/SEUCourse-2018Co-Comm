 function outputA = Method_BDNeumann(inputA,ka1,bl)
% inputA=cW;
% ka1=1;
% bl=32;

%矩阵分块
dimA=size(inputA);
bln=dimA(1,1)/bl;%分块矩阵数目
D2=cell(1,bln);%存储分块矩阵
D2inv=cell(1,bln);%存储分块矩阵的逆矩阵
for i=1:bln
    D2inv{1,i}=zeros(bl);%分块矩阵逆矩阵初始化
end
outputA=zeros(dimA);%输出矩阵初始化

%D1,D2,D3的生成
for i=1:bln
    D2{1,i}=inputA(bl*(i-1)+1:bl*i,bl*(i-1)+1:bl*i);
end

D1=blkdiag(D2{1,1:bln});


for i=1:bln
    D2inv{1,i}=D2{1,i}^(-1);
end

D1inv=blkdiag(D2inv{1,1:bln});

for ia1=0:ka1-1
    outputA=outputA+(-D1inv*(inputA-D1))^ia1*D1inv;
end
 end



    
