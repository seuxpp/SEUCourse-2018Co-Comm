 function outputA = Method_MLI2(inputA,k1,k2,K)
% inputA=cW;
% k1=5;
% k2=5;
bl=4;

%双层迭代

dimA=size(inputA);
dimD1bl=dimA(1,1)/K;%第一层迭代子矩阵维度

%最小分块矩阵及逆矩阵的存储
bln=dimA(1,1)/bl;%最小分块矩阵数目
D2bl=cell(1,bln);%存储最小分块矩阵
for i=1:bln
    D2bl{1,i}=inputA(bl*(i-1)+1:bl*i,bl*(i-1)+1:bl*i);%矩阵赋值
end
D2blinv=cell(1,bln);%存储最小分块矩阵的逆矩阵
for i=1:bln
    D2blinv{1,i}=Method_Neumann(D2bl{1,i},k2);%bl阶矩阵求逆
end

D3=cell(1,K);
for i=1:K
    D3{1,i}=inputA((i-1)*dimD1bl+1:i*dimD1bl,(i-1)*dimD1bl+1:i*dimD1bl);
end

D3bl=cell(1,K);
for i=1:K
    D3bl{1,i}=blkdiag(D2bl{1,(i-1)*bln/K+1:i*bln/K});
end

D3blinv=cell(1,K);
for i=1:K
    D3blinv{1,i}=blkdiag(D2blinv{1,(i-1)*bln/K+1:i*bln/K});
end

D3inv=cell(1,K);
for i=1:K
    D3inv{1,i}=zeros(dimD1bl);
end
%第二层迭代
for i=1:K
    for ia1=0:k2-1
        D3inv{1,i}=D3inv{1,i}+(-D3blinv{1,i}*(D3{1,i}-D3bl{1,i}))^(ia1)*D3blinv{1,i};
    end
end

D1=inputA;
D1bl=blkdiag(D3{1,1:K});
D1blinv=blkdiag(D3inv{1,1:K});
D1inv=zeros(dimA);
%第一层迭代
for ia1=0:k1-1
    D1inv=D1inv+(-D1blinv*(D1-D1bl))^(ia1)*D1blinv;
end

outputA=D1inv;