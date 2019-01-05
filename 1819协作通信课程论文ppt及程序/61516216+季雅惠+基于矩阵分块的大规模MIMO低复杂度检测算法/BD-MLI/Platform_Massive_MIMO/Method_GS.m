function x = Method_GS(A,b,k,initial)
% Gauss-Seidel method
% initial: 0 - zero-vector initial solution
E = -tril(A,-1);
D = diag(diag(A));
F = -triu(A,1);
m = size(A,2);
n = size(b,2);

%% Start the Iterative method
x = initial*b;
invM = eye(m) / (D-E);
G = invM*F;
% invM =inv(D-E);
for i = 1:k
    x = G*x+invM*b;
end