function CY=reshapecY(Y,dim)
CY=zeros(dim-1,1);
for i=2:dim
    CY(i-1,:)=Y(i,:)-Y(i-1,:);
end
end