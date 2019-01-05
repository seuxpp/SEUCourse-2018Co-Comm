function bitsOut = Calc_Hard_Decision(L)
[M,N] = size(L);
bitsOut = zeros(M,N);
for n = 1:N
    for m = 1:M
        if L(m,n)>0
            bitsOut((n-1)*M+m)=1;
        else
            bitsOut((n-1)*M+m)=0;
        end
    end
end

end