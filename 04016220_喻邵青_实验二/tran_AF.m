% AF协作
% H_sr瑞利衰减矩阵
% pow_S源信号功率，pow_n噪声功率
function [beta,signal_AF] = tran_AF(H_sr,POW_S,POW_N,signal_sr)
beta = sqrt( POW_S)/POW_S*((abs(H_sr))^2 + POW_N ); % 放大系数beta 保证中继节点功率受限
signal_AF = beta * signal_sr;	% 中继放大后的信号
end