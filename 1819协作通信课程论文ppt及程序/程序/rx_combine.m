function [symbol_sequence,bit_sequence]=rx_combine(rx,channel,use_relay,Ps);
%在接收端合并两路信号,并判决出发送信号序列

global signal;
global relay;

values2analyse=rx.signal2analyse;
if (use_relay==1)&(relay.magic_genie==1)
    switch relay.mode
        case 'DAF'
            values2analyse(2,:)=(relay.symbol_sequence==signal.symbol_sequence).*values2analyse(2,:);
        otherwise
            error(['Magic genie work only with DAF'])
    end
end

switch rx.combining_type
    case 'MRC'
        switch relay.mode
            case 'DAF'
                if (use_relay==0)
                    h=conj(channel(1).attenuation.h);%h为其复共轭
                else
                    h=conj([channel(1).attenuation.h;channel(3).attenuation.h]);
                end
                bit_sequence=(mean(symbol2bit(h.*values2analyse),1)>=0)*2-1;
            case 'AAF'
                if (use_relay==0)
                    h=conj(channel(1).attenuation.h);
                else
                    
                    h=conj([channel(1).attenuation.h;channel(3).attenuation.h.*channel(2).attenuation.h]);
                end
                bit_sequence=(mean(symbol2bit(h.*values2analyse),1)>=0)*2-1;     
            otherwise
                error(['error!']);
        end
    case{'ERC','FRC','SNRC','ESNRC'}
        values2analyse=symbol2bit(values2analyse);
        switch rx.combining_type
            case 'ERC'
                bit_sequence=(mean(values2analyse,1)>=0)*2-1;
            case 'FRC'
                if (use_relay==0)
                    bit_sequence=(mean(values2analyse,1)>=0)*2-1;
                else
                    bit_sequence=(mean([rx.sd_weight;1]*ones(1,size(values2analyse,2)).*values2analyse)>=0)*2-1;
                end
            case {'SNRC','ESNRC'}
                if (use_relay==0)
                    bit_sequence=(mean(values2analyse,1)>=0)*2-1;
                else
                    SNR_direct=estimate_direct_channel_SNR(channel(1),signal.modulation_type,Ps);%直传信道的信噪比估计
                    SNR_via=estimate_via_channel_SNR(channel(2),channel(3),relay.mode,Ps);%估计via路的信噪比
                    if (signal.modulation_type=='QPSK')
                        SNR_via=[SNR_via,SNR_via];
                    end
                    switch rx.combining_type
                        case 'SNRC'
                            bit_sequence=(mean([SNR_direct;SNR_via].*values2analyse,1)>=0)*2-1;
                        case 'ESNRC'
                            use_direct=SNR_direct./SNR_via>10;
                            use_via=SNR_direct./SNR_via<0.1;
                            use_equal_ratio=not(use_direct+use_via);
                            bit_sequence_equal_ratio=(mean(values2analyse,1)>=0)*2-1;
                            bit_sequence_direct=(values2analyse(1,:)>=0)*2-1;
                            bit_sequence_via=(values2analyse(2,:)>=0)*2-1;
                            bit_sequence=use_equal_ratio.*bit_sequence_equal_ratio+use_direct.*bit_sequence_direct+use_via.*bit_sequence_via;
                    end
                end
            otherwise
            error(['Combining-type unkonwn:',rx.combining_type])
        end
end

symbol_sequence=bit2symbol(bit_sequence);

        
                 
                    
                    
                
                
        
        
                    
