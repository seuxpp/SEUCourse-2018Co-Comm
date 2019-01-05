function W=create_W(N,M,ratio1,ratio2,ratio3,mUE)
n=10;
Es = 1;
SNRdB = 10;
EsN0dB = SNRdB - 10*log10(M);
EsN0 = 10.^(EsN0dB/10);
N0 = Es./EsN0;
cWcell=cell(n,1);
for i=1:n
cH =  newchennel(N,M,ratio1,ratio2,ratio3,mUE);
cG = cH'*cH;
cW = cG + eye(M)*N0(1);
% W=abs(cW)./max(max(abs(cW)));
cWcell{i}=abs(cW);
end
W=zeros(M);
for i=1:n
    W=W+cWcell{i};
end
W=W./n;