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


    