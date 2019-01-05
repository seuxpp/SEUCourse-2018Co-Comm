%% function of AF
%**************************************************************************
%本程序有版权可随意使用发布，但请保留原版信息Copyleft
%Author: 11/06/2010 Davy
%2010.06.11 由 Davy 以账号 yuema1086 发布于 www.CSDN.com
%**************************************************************************
%==========================================================================
% Description: Approach in the relay node with AF
% Usage:  H = RayleighCH(mu,sigma)
% Inputs:
%         CH_sr: Rayleigh Fading coefficient of Channel S_in_R 
%         POW_S: Signal power
%         POW_N: Noise power
%         signal_sr:  Relay received the signal 'signal_sr' from Source
% Outputs:
%         beta: amplification factor
%         signal_AF: signal after AF,it'll be transmitted from Relay to Destination
% =========================================================================
function [beta,signal_AF] = AF(CH_sr,POW_S,POW_N,signal_sr)

beta = sqrt( POW_S) / ( (abs(CH_sr))^2 * POW_S + POW_N ); % amplification factor

signal_AF = beta * signal_sr;	% Relay transmit the AF signal 'signal_AF'