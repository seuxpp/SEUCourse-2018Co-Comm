%% function of the BER
%**************************************************************************
%本程序有版权,仅供教学使用
%Author: 29/09/2013 wuguilu
%2013.09.29 
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