function newdemodData=newdemod(demodData,bl)
% demodData=demodData{i};
% bl=4;
if bl==1
    newdemodData=demodData;
else
DemodData=demodData.';%进行转置，方便后面运算
dim=size(DemodData);
r=dim(1,1);%行
c=dim(1,2);%列
newr=r/bl;
newdemodData=zeros(newr,c);
for i=1:newr
    newdemodData(i,:)=mean(DemodData((i-1)*bl+1:i*bl,:));
end
newdemodData=newdemodData.';
end
end