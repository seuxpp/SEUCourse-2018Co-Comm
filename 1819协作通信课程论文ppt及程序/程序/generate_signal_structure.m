function [signal_structure]=generate_signal_structure();
%创建表示所有信号的结构体

signal_structure=struct(...
'nr_of_bits',{},...        %传输的比特数
'nr_of_symbols',{},...     %传输的字符数
'bits_per_symbol',{},...   %每个字符包含的比特数Qpsk(2bit/symbol),Bpsk(1bit/symbol)
'modulation_type',{},...   %调制方式 'Qpsk'或'Bpsk'
'bit_sequence',{},...      %信号的比特序列
'symbol_seguence',{},...   %信号的字符序列
'received_bit_sequence',{},...%传输完毕后的比特序列
'position_x',{},...%信号源方所处位置的横坐标
'position_y',{});%信号源方所处位置的纵坐标