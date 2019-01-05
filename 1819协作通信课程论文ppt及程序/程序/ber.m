function [y]=ber(snr,modulation_type,fading_type);
%根据调制方式和衰落方式计算单链路ber

switch fading_type
    case 'Rayleigh'
        switch modulation_type
            case 'BPSK'
                y=(1-sqrt(snr./(1/2+snr)))/2;
            case 'QPSK'
                y=(1-sqrt(snr./(1+snr)))/2;
            otherwise
                error(['Modulation-type unkonwn:',modulation_type]);
        end
        
    case 'no'
        switch modulation_type
            case 'BPSK'
                y=q(sqrt(2*snr));
            case 'QPSK'
                y=q(sqrt(snr));
            otherwise
                error(['Modulation-type unkonwn:',modulation_type]);
        end
    otherwise
        error(['Fading-type unknown:',fading_type]);
end
                
              