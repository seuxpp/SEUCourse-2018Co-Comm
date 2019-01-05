function CH=reshapecH(H,dim1,dim2)
CH=zeros(dim1-1,dim2);
for i=2:dim1
    CH(i-1,:)=H(i,:)-H(i-1,:);
end
end