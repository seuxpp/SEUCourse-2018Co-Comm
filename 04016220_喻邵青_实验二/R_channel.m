%函数目的是产生一个复数随机数作为衰减
%参数为所需要的方差
function atten=R_channel(sigma)
   mean=0;          %均值为0
   sta_deviation=sqrt(sigma);
   atten=normrnd(mean,sta_deviation)+j*normrnd(mean,sta_deviation);        %均值为0，方差为sigma的正态分布随机数

end
