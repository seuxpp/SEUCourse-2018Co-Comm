%主程序 
random_signal_len=10000;   
ts=clock; 

%用户随机信号生成
user_1st_send = user_send(random_signal_len); 
user_2nd_send = user_send(random_signal_len);

%用户m序列生成
user_1st_register = [0 1 0 1]; 
user_2nd_register = [1 0 1 0];              
user_1st_seq_m = sequence_m(user_1st_register,random_signal_len); 
user_2nd_seq_m = sequence_m(user_2nd_register,random_signal_len); 

%直接序列扩频
user_1st_dsss = dsss(user_1st_send,user_1st_seq_m); 
user_2nd_dsss = dsss(user_2nd_send,user_2nd_seq_m);  
 
%BPSK调制
user_1st_bpsk = bpsk(user_1st_dsss); 
user_2nd_bpsk = bpsk(user_2nd_dsss); 
users_send = user_1st_bpsk + user_2nd_bpsk; 

%BPSK频谱图
fs = 10000;    
Nf = 80000;    
y = fft(users_send,Nf);    
mag = abs(y);              
f =(0:length(y)-1)'*fs/length(y);   
figure(1); 
plot(f,mag);      
xlabel('频率'); 
ylabel('幅值'); 
title('BPSK信号的频谱分析图'); 
grid; 

%AWGN信道(高斯白噪声)
N=random_signal_len*80;  
L=10;          
M=N/L;       
Ts=0.5;      
dt=Ts/L;        
df=1/(N*dt);    
T=N*dt;            
Bs=N*df/2;       
t=[-T/2+dt/2:dt:T/2]; 
for SNR=-10:10; 
eb_n0=10^(SNR/10); 
Eb=1;    
n0=Eb/eb_n0;    
Pow=n0*Bs;      
noise = sqrt(Pow)*randn(size(t));   
users_send_noise  = users_send + noise; 

%BPSK解调部分
users_demod = demodulate(users_send_noise); 

%直接序列扩频解调部分
user_1st_received = despread(users_demod,user_1st_seq_m); 
user_2nd_received = despread(users_demod,user_2nd_seq_m); 

%误码计算
user_1st_error = abs(user_1st_send - user_1st_received); 
user_2nd_error = abs(user_2nd_send - user_2nd_received); 
all_error = sum(user_1st_error) + sum(user_2nd_error); 
out(SNR+11) = {[num2str((all_error/(random_signal_len*2))*100),'%']}; 
BER(SNR+11) = all_error; 
end 
dB = [-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 ]; 
for i=1:21 
dBtext(i) = {[num2str(dB(i)),'dB']}; 
end 
output = [dBtext;out];  

%误码率绘图
n=1:21; 
r=[]; 
E=[]; 
for m=1:21 
    r(m)=10^[(m-11)/10]; 
    E(m)=1/2*erfc(sqrt(r(m))); 
end 
figure(2); 
semilogy(dB(n),BER(n)/(random_signal_len*2),'b-*',dB(n),E(n),'r'); 
xlabel('信噪比(dB)'); 
ylabel('误码率(%)'); 
title('误码率与信噪比'); 
legend('实际值','理论值'); 
axis([-10,10,10^-5,10]); 
grid; 