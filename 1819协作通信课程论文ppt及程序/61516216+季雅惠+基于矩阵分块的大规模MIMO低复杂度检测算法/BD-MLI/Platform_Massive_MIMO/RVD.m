function realA = RVD(complexA)
% real value decomposition

[x,y] = size(complexA);

if isvector(complexA)
    realA = zeros(2*x,y);
    realA(1:2:2*x-1,:) = real(complexA);
    realA(2:2:2*x,:) = imag(complexA);
else
    realA = zeros(2*x,2*y);
    for n = 1:x
        for m = 1:y
            realA(2*n-1,2*m-1) = real(complexA(n,m));
            realA(2*n-1,2*m) = -imag(complexA(n,m));
            realA(2*n,2*m-1) = imag(complexA(n,m));
            realA(2*n,2*m) = real(complexA(n,m));
        end
    end
end