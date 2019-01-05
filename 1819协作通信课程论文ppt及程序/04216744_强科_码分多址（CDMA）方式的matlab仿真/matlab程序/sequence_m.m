%M序列产生器（产生任意长度m序列 ）
function output_m = sequence_m(register,user_signal_len) 
out_m_len = user_signal_len*8; 
repeat_times = floor(out_m_len/15); 
for i=1:15 
    seq_m_signal_cycle(i) = register(4); 
    register = [xor(register(4),register(3)),register(1),register(2),register(3)]; 
end 
output_m_A_part = repmat(seq_m_signal_cycle,1,repeat_times);  
  
rem = mod(out_m_len,15);       
if rem == 0 
   output_m = output_m_A_part;  
else                   
   for i=1:rem   
        output_m_B_part(i) = register(4); 
        register = [xor(register(4),register(3)),register(1),register(2),register(3)]; 
   end 
   output_m = [output_m_A_part,output_m_B_part]; 
end 
output_m = 2*output_m - 1;