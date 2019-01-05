%% function of the BER
%**************************************************************************
%本程序有版权可随意使用发布，但请保留原版信息Copyleft
%Author: 11/06/2010 Davy
%2010.06.11 由 Davy 以账号 yuema1086 发布于 www.CSDN.com
%**************************************************************************
%==========================================================================
% Description: Obtain the actual BER
% Usage:  number_of_errbits = Ber(x,y)
% Inputs:
%         signal_x: The right signals, is used to refer to
%         signal_y: signal which needs to be calculated error rate
% Outputs:
%         number_of_errbits: number of errbits of the signal "signal_y"
% =========================================================================
function number_of_errbits = Act_ber(signal_x,signal_y)

[number,ratio] = biterr(signal_x,signal_y);
number_of_errbits = number;