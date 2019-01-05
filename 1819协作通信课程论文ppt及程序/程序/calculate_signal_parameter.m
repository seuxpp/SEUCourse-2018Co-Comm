function calculate_signal_parameter
%计算额外的信号参数

global signal;%全局变量signal,在主函数中声明,是一个signal_structure类型的变量

%计算每个符号所包含的比特数
switch signal.modulation_type
    case 'BPSK'
        signal.bits_per_symbol=1;%每个字符的比特数
    case 'QPSK'
        signal.bits_per_symbol=2;
        if (signal.nr_of_bits/2~=ceil(signal.nr_of_bits/2))%ceil函数是向右取整
            error(['Using QPSK,number of bits must be a mutiple of 2'])
        end
    otherwise
        error(['Modulation type unknown:',signal.modulation_type])
end

%根据要传输的比特个数计算要传输的符号个数
signal.nr_of_symbols=signal.nr_of_bits/signal.bits_per_symbol;

%bit序列
signal.bit_sequence=floor(rand(1,signal.nr_of_bits)*2)*2-1;%floor函数是向左取整

%symbol序列
signal.symbol_sequence=bit2symbol(signal.bit_sequence);



