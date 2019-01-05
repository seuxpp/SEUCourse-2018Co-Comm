function outputA = Method_Neumann(inputA,ka)
D=diag(diag(inputA));
E=inputA-D;
outputA=zeros(size(inputA));

for ia=0:ka-1
    outputA=outputA+(-D^(-1)*E)^ia*D^(-1);
end

end