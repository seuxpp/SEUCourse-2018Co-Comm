function H = RayleighCH(sigma2)

mu = 0;	% average value(0)
sigma = sqrt(sigma2); % Standard deviation(��)
H = normrnd(mu,sigma)+j*normrnd(mu,sigma);	
% normrnd�ĸ�ʽ��:normrnd(MU,SIGNA,m,n),��������ΪMU,SIGMA����̬�ֲ������