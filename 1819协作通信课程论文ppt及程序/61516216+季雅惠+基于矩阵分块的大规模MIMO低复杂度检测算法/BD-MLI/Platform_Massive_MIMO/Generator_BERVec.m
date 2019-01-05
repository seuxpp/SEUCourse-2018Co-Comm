function [commErr, BERVec] = Generator_BERVec(SNR, N)
len = length(SNR);
BERVec = cell(N, 1);
commErr = cell(N, 1);
for i = 1:N
   commErr{i} = comm.ErrorRate;
   BERVec{i} = zeros(3, len); 
end
end