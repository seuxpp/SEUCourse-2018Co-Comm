%% function of the Rayleigh Fading Channel
%**************************************************************************
%本程序有版权，仅供教学使用
%Author: 29/09/2013 wuguilu
%2013.09.29 
%**************************************************************************
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

