function [beta,signal_AF] = AF(CH_sr,POW_S,POW_N,signal_sr)

beta = sqrt( POW_S) / ( (abs(CH_sr))^2 * POW_S + POW_N ); % amplification factor保证中继节点功率受限

signal_AF = beta * signal_sr;	% Relay transmit the AF signal 'signal_AF'