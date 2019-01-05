function [mu,rho] = Calc_SINR_Appr(mat_U,E)
mu = real(diag(mat_U));
rho = mu ./(1-E.*mu);
end