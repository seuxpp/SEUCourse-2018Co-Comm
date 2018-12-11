%计算产生信号x和y的差异的数量
function num_err_bit = cal_err_bit(signal_x,signal_y)
[number,~] = biterr(signal_x,signal_y);
num_err_bit = number;
end