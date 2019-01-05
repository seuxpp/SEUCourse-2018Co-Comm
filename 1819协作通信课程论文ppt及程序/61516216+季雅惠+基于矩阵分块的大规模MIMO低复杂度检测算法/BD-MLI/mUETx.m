function newtx=mUETx(frm,bl)
dim=size(frm);
l=dim(1,1);
for i=1:l
    newtx(bl*(i-1)+1:bl*i,1)=frm(i,1);
end
end
