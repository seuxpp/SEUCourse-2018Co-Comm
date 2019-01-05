function N0=reshapeN0(Y,B,dim)
N=Y-B;
newN=zeros(dim-1,1);
for i=2:dim
    newN(i-1,:)=N(i,:)-N(i-1,:);
end
N0=mean(abs(newN));
end