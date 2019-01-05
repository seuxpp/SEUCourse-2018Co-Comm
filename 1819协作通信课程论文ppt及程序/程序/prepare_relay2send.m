function [relay]=prepare_relay2send(relay,channel,ps,pr);
%relay接收信号，为转发做准备

global signal;
switch relay.mode
    case 'AAF'
        relay.amplification=sqrt(pr./(ps.*channel.attenuation.h_mag.^2+2.*channel.noise.sigma.^2));
        relay.signal2send=relay.rx.received_signal.*relay.amplification;
    case 'DAF'
        relay.rx=rx_correct_phaseshift(relay.rx,channel.attenuation.phi);
        relay.symbol_sequence=rx_combine(relay.rx,channel,0);
        relay.signal2send=relay.symbol_sequence;
    otherwise
        error(['Unknown relay-type:',relay.mode]);
end
        
