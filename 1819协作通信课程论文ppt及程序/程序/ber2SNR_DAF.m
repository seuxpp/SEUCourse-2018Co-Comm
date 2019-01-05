function [SNR]=ber2SNR_DAF(ber_srd,modulation_type,fading_type);
%used for calculating SNR of DAF 

switch fading_type
    case 'no'
        switch modulation_type
            case 'BPSK'
                SNR=((qinv(ber_srd)).^2)./2;
            case 'QPSK'
                SNR=qinv(ber_srd).^2;
            otherwise
                error(['Modulation type unkonwn:',modulation_type])
        end
    case 'Rayleigh'         
        switch modulation_type
            case 'BPSK'
                SNR=(1-2.*ber_srd).^2./((ber_srd-ber_srd.^2).*8);
            case 'QPSK'
                SNR=(1-2.*ber_srd).^2./((ber_srd-ber_srd.^2).*4);
            otherwise
                error(['Modulation type unkonwn:',modulation_type])
        end
    otherwise
        error(['Fading type unknown:',fading_type])
end

                
                

