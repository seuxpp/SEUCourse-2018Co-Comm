%解调BPSK部分 
function output_demodulate_sam = demodulate(input_signal) 
car_freq = 1000;          
point = 10;            
sam_freq = car_freq*point;     
len = length(input_signal); 
t=0:(1/sam_freq):((point-1)/sam_freq);            
carrier = sin(2*pi*car_freq*t);                      
carrier = repmat(carrier,1,len/10); 
output_demodulate = input_signal.*carrier;         
x = reshape(output_demodulate,10,len/10); 
output_demodulate_sam = sum(x); 