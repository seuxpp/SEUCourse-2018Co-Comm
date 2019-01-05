function cWinv = Method_TMA(cW,k)
Dtri=tridiagonal(cW);
Dtriinv=tridiagonal(Dtri^(-1));
E=cW-Dtri;
cWinv=zeros(size(cW));

for ia=0:k-1
    cWinv=cWinv+(-Dtriinv*E)^ia*Dtriinv;
end

end

%  dimA=size(cW);
%  M=dimA(1,1);
%  cWinv=zeros(M);
%  Dtri=tridiagonal(cW);
%  E=cW-Dtri;
%  Dtriinv=tridiagonal(Dtri^(-1));
%  P=Dtriinv*E; %PÎªÂúÕó
%  cWinvpart=cell(k,1);
%  cWinvpart{1}=Dtriinv;
%  cWinvpart{2}=P*Dtriinv;
%  Q=cWinvpart{2};
% %  Q=tridiagonal(cWinvpart{2});
%  for i=3:k
%      cWinvpart{i}=P*Q;
%      Q=cWinvpart{i};
% %      Q=tridiagonal(cWinvpart{i});
%  end
%  for i=1:k
%      cWinv=cWinv+(-1)^(i-1)*cWinvpart{i};
%  end
     