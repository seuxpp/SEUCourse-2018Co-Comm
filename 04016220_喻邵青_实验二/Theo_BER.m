% 函数表示AF协作理论上的误比特率
function the_BER = Theo_BER( H_sd,CH_sr, H_rd ,POW_S_sd ,POW_N_sd ,POW_S_rd,POW_N_rd)
    y_sd = ( POW_S_sd * (abs(H_sd))^2 ) / POW_N_sd;  
    numerator = (POW_S_rd)^2  *  (abs(CH_sr))^2 *(abs(H_rd))^2;
    denominator = ( POW_S_rd*(abs(CH_sr))^2+ POW_S_rd*(abs(H_rd))^2+POW_N_rd ) * POW_N_rd;
    y_rd = numerator / denominator;
    y = y_sd + y_rd; 
    the_BER = 1 / ( 2 * sqrt(pi*y))* exp(-y) ;  % 近似值   公式1-3-7
end

