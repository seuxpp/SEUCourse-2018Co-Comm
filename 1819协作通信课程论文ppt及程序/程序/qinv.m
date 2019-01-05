function [y]=qinv(x);

y=erfcinv(x*2)*sqrt(2);