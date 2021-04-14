%参数说明
%Rb：码元速率
%fc： 载波频率
%fs:   采样速率
%k：  为码元个数
%A：  幅值
function bpsk = BPSK(Rb,fc,fs,k,A)
code = randi(1,k);                                         
N = k/Rb*fs;			
Npc = 1/Rb*fs;												
l = 0;
bpsk = zeros(1,N);
for i=1:k
   for j = l:l+Npc-1
       if code(1,i)==0
         bpsk(1,j+1) = A*cos(2*pi*fc*j/fs);
       elseif code(1,i)==1
         bpsk(1,j+1) = A*cos(2*pi*fc*j/fs + pi);
       end
   end
   l = l+Npc;
end