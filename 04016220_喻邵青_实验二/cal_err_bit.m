%��������ź�x��y�Ĳ��������
function num_err_bit = cal_err_bit(signal_x,signal_y)
[number,~] = biterr(signal_x,signal_y);
num_err_bit = number;
end