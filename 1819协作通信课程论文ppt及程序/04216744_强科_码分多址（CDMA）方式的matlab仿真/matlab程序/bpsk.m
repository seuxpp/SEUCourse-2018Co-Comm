%BPSK调制部分 
function output_bpsk = bpsk(input_signal) 
car_freq = 1000;         
sam_point = 10;             
sam_freq = car_freq*sam_point;    
i_s_len = length(input_signal); 
t = 0:(1/sam_freq):((sam_point-1)/sam_freq); 
Carrier = sin(2*pi*car_freq*t);       
Carrier = repmat(Carrier,1,i_s_len);     
input_signal = input_signal'; 
sample = ones(1,sam_point); 
input_signal = input_signal*sample; 
input_signal = input_signal'; 
input_signal = reshape(input_signal,1,i_s_len*sam_point);  
output_bpsk = Carrier.*input_signal;   