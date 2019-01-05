function [SNR_via]=estimate_via_channel_SNR(channel_sr,channel_rd,mode,Ps);
%估计via路的信噪比
global relay
global signal
switch mode
    case 'AAF'    
        xi=abs(signal.symbol_sequence).^2;
        SNR_via=relay.amplification.^2.*channel_sr.attenuation.h_mag.^2.*channel_rd.attenuation.h_mag.^2.*xi.*Ps;
        SNR_via=SNR_via./(relay.amplification.^2.*channel_rd.attenuation.h_mag.^2.*2.*channel_sr.noise.sigma.^2+2.*channel_rd.noise.sigma.^2);
    case 'DAF'
        snr_sr=10^(channel_sr.noise.SNR/10)*ones(size(signal.symbol_sequence));
        snr_rd=10^(channel_rd.noise.SNR/10)*ones(size(signal.symbol_sequence));
        ber_sr=ber(snr_sr,signal.modulation_type,channel_sr.attenuation.pattern);
        ber_rd=ber(snr_rd,signal.modulation_type,channel_rd.attenuation.pattern);
        ber_srd=ber_sr.*(1-ber_rd)+(1-ber_sr).*ber_rd;
        SNR_via=ber2SNR_DAF(ber_srd,signal.modulation_type,channel_rd.attenuation.pattern);
    otherwise
        error(['mode unknown:',mode])
end

        
            
            
          
        