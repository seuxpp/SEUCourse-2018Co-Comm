%½âÀ©²¿·Ö 
function output_despread_final = despread(input_signal,seq_m) 
o_d_len = length(input_signal)/8;  
output_despread = input_signal.*seq_m; 
register = reshape(output_despread,8,o_d_len); 
register_one = sum(register); 
output_despread_final = [register_one>0];   