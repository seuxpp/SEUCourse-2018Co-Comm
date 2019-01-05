% M-QAM Modulation with Gray Mapping
% [Parameters]
% encod2 - bits 
% M - modulations schemes, 16 or 64
% scaling - for normalizing
% [Changes]
% 2016/4/3 - Created by Zhizhen Wu
function [qam_sig]=Mod_QAM(encod2,M,scaling) 

NN=length(encod2); 

if scaling==1
    d=sqrt(3/(2*(M-1)));%to normalize the energy of the QAM symbol 
else
    d=1;
end

if M==16
    k=4;
    ConsI=[-3*d -d d d*3]; 
    ConsQ=[-3*d -d d d*3]; 
    I=[0 0;0 1;1 1;1 0]; 
    Q=[0 0;0 1;1 1;1 0]; 
elseif M==64
    k=6;
    ConsI=[-7*d -5*d -3*d -d d d*3 5*d 7*d]; 
    ConsQ=[-7*d -5*d -3*d -d d d*3 5*d 7*d]; 
    I=[0 0 0;0 0 1;0 1 1;0 1 0;1 1 0;1 1 1;1 0 1;1 0 0]; 
    Q=[0 0 0;0 0 1;0 1 1;0 1 0;1 1 0;1 1 1;1 0 1;1 0 0]; 
end        

 
for i1=0:k:NN-1 
   % encode bit map  
   if M==16
       nu1=[encod2(i1+1) encod2(i1+2)]; 
       nu2=[encod2(i1+3) encod2(i1+4)]; 
   elseif M==64
       nu1=[encod2(i1+1) encod2(i1+2) encod2(i1+3)]; 
       nu2=[encod2(i1+4) encod2(i1+5) encod2(i1+6)]; 
   end
   
   for j=1:sqrt(M) 
      eu1(j)=(nu1-I(j,:))*(nu1-I(j,:))'; 
      eu2(j)=(nu2-Q(j,:))*(nu2-Q(j,:))'; 
   end 
   [~,index1]=min(eu1); 
   [~,index2]=min(eu2); 
  
   qam_sig(i1/k+1)=(ConsI(index1)+1i*ConsQ(index2)); 
end;