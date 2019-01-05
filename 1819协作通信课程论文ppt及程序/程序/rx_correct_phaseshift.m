function [rx]=rx_correct_phaseshift(rx,phi);
%修正相移
switch rx.combining_type
    case 'MRC'%对收到的原始信号,不需要修正相移,这个过程在两个信号合并时就进行了
        rx.signal2analyse=[rx.signal2analyse;rx.received_signal];
    otherwise
        rx.signal2analyse=[rx.signal2analyse;rx.received_signal.*exp(j*phi)];
end

