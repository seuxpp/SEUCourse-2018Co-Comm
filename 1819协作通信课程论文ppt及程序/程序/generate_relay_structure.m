function [relay_structure]=generate_relay_structure();
%为relay创建结构体

rx_structure=generate_rx_structure;

relay_structure=struct(...
'mode',{},...                %'AAF','DAF'
'magic_genie',{},...         %'Magic Genie'
'amplification',{},...       %AAF模式下使用
'symbol_sequence',{},...     %DAF模式下使用
'signal2send',{},...         %要转发的信号
'rx',rx_structure);   %relay的接收部分