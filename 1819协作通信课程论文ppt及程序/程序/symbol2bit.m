function [bit_sequence]=symbol2bit(symbol_sequence);
%字符序列转换成bit序列

global signal;

switch signal.modulation_type
    case 'BPSK'
        bit_sequence=symbol_sequence;
    case 'QPSK'
        bit_sequence=[real(symbol_sequence),imag(symbol_sequence)];
    otherwise
        error(['Modulation type unknown:',signal.modulation_type])
end

