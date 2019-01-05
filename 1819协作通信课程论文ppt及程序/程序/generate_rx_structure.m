function [rx_structure]=generate_rx_structure();
%为接收参数创建结构体
rx_structure=struct(...
'combining_type',{},...%'ERC','FRC','SNRC','ESNRC','MRC'
'sd_weight',{},...%'FRC'下使用,relay路加权值为1
'received_signal',{},...%原始接收到.的信号
'signal2analyse',{});%用来分析判决的信号,每一路接收到的信号占一行

