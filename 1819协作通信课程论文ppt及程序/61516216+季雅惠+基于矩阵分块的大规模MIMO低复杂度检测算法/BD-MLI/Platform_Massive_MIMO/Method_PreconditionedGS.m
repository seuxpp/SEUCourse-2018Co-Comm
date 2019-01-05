function [x,s_r] = Method_PreconditionedGS(B,b,k)
% Gauss-Seidel method
% initial: 0 - zero-vector initial solution
%  B = cW;
%   b = cYBar;
%   k = 3;
D = diag(diag(B));
Dinv = D^(-1);
A = Dinv*B;
b = Dinv*b;
S = triu(A,2)-triu(A,1);
L = -tril(A,-1);
U = -triu(A,1);
n = size(A,2);
I = eye(n);
%% Start the Iterative method
x = zeros(n,1);
invM = (I-S*L-L)^(-1);
N = U-S+S*U;
bs = (I+S)*b;
T = invM*N;
s_r = max(abs(eig(T)));
% invM =inv(D-E);
for i = 1:k
    x = T*x+invM*bs;
end