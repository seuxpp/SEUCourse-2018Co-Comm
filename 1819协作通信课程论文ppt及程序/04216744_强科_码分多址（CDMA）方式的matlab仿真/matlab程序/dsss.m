%直接序列扩频部分
function output_dsss = dsss(input_signal,seq_m) 
i_s_len = length(input_signal); 
input_signal = repmat(input_signal,1,8); 
input_signal = reshape(input_signal,i_s_len,8); 
input_signal = input_signal'; 
input_signal = reshape(input_signal,1,i_s_len*8); 
input_signal = 2*input_signal - 1;      
output_dsss = input_signal.*seq_m;    