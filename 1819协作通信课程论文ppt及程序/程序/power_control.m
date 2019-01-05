function [signal_sequence]=power_control(Ps,signal_sequence);
%用一定的发送功率Ps发送信号
signal_sequence=signal_sequence*sqrt(Ps);
