%% function of the Rayleigh Fading Channel 

%========================================================================== 
% Description:  
% Usage:  H = RayleighCH(sigma) 
% Inputs: 
%         sigma2: variance(σ^2) 
% Outputs: 
%         H: 1×n Fading coefficient matrix  
% ========================================================================= 
function H = RayleighCH(sigma2) 
 
mu = 0;	% average value(0) 
sigma = sqrt(sigma2); % Standard deviation(σ) 
H = normrnd(mu,sigma)+j*normrnd(mu,sigma);	 
% normrnd的格式是:normrnd(MU,SIGNA,m,n),产生参数为MU,SIGMA的正态分布随机数 
 
%% ++++++++++++++++++++++++ Another Method ++++++++++++++++++++++++ 
% another method (n: bit number) 
% function H = RayleighCH(n) 
% H = randn(1,n)+j*randn(1,n); 
% randn()产生均值为0，方差 σ^2 = 1，标准差σ = 1的正态分布的随机数或矩阵的函数 
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 