function H = RayleighCH(sigma2)

mu = 0;	% average value(0)
sigma = sqrt(sigma2); % Standard deviation(σ)
H = normrnd(mu,sigma)+j*normrnd(mu,sigma);	
% normrnd的格式是:normrnd(MU,SIGNA,m,n),产生参数为MU,SIGMA的正态分布随机数