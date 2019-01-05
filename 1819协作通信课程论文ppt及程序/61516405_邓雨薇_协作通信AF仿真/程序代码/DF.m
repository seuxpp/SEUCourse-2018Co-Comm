%% function of DF
%**************************************************************************
%本程序有版权可随意使用发布，但请保留原版信息Copyleft
%Author: 11/06/2010 Davy
%2010.06.11 由 Davy 以账号 yuema1086 发布于 www.CSDN.com
%**************************************************************************
%==========================================================================
% Description: Approach in the relay node with DF
% Usage:  H = RayleighCH(mu,sigma)
% Inputs:
%         M: numbers of symbol
%         signal_sr: The signal 's_r' Relay node received from Source node
%         signal_x:  Random binary data stream,It was modulated in the Source node
% Outputs:
%         signal_DF: signal after DF,it'll be transmit from Relay to Destination
% ========================================================================= 
function signal_DF = DF(M,signal_sr,signal_x)
    
% fisrt: demodulate the signal 's_r'
	signal_demod = demodulate(modem.pskdemod(M),signal_sr);

% second: decode r_d_1',And determine whether decoding correct
%++++++++++++++If use a fixed DF,forced to set 'tx_coop' '1'+++++++++++++++
	tx_coop = 1;	 % a sign, indicates whether forwarding 
%	if (sum(signal_x ~= signal_demod)>0) 
%        tx_coop = 0;      
%    end   % if the relay decoding error, not forward
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% third: modulate the signal 'signal_demod'
    if tx_coop == 0
        disp('Fail in DF,Source should transmit the signal to Destination directly Without Cooperation');
    elseif tx_coop == 1
      % As the force decoding is correct, so 'signal_demod' is equivalent to 'signal_x'
        signal_DF = modulate(modem.pskmod(M),signal_x); 
        % signal_DF = modulate(modem.pskmod(M),signal_demod); 
    end
    
%% +++++++++ In fact,the DF process simplified equal to +++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%function signal_DF = DF(M, signal_x)
%signal_DF = modulate(modem.pskmod(M), signal_x);
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    