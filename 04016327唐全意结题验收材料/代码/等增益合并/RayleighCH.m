%% function of the Rayleigh Fading Channel
%**************************************************************************
%�������а�Ȩ��������ѧʹ��
%Author: 29/09/2013 wuguilu
%2013.09.29 
%**************************************************************************
%==========================================================================
% Description: 
% Usage:  H = RayleighCH(sigma)
% Inputs:
%         sigma2: variance(��^2)
% Outputs:
%         H: 1��n Fading coefficient matrix 
% =========================================================================
function H = RayleighCH(sigma2)

mu = 0;	% average value(0)
sigma = sqrt(sigma2); % Standard deviation(��)
H = normrnd(mu,sigma)+j*normrnd(mu,sigma);	
% normrnd�ĸ�ʽ��:normrnd(MU,SIGNA,m,n),��������ΪMU,SIGMA����̬�ֲ������

%% ++++++++++++++++++++++++ Another Method ++++++++++++++++++++++++
% another method (n: bit number)
% function H = RayleighCH(n)
% H = randn(1,n)+j*randn(1,n);
% randn()������ֵΪ0������ ��^2 = 1����׼��� = 1����̬�ֲ�������������ĺ���
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++