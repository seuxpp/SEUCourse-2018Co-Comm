function theoretical_BER = Theo_ber( varargin )
    CH_sd = varargin{1};
    CH_sr = varargin{2};
    CH_rd = varargin{3};
    POW_S_sd = varargin{4};
    POW_N_sd = varargin{5};
    POW_S_rd = varargin{6};
    POW_N_rd = varargin{7};    
% for AF SNR
    gamma_sd = ( POW_S_sd * (abs(CH_sd))^2 ) / POW_N_sd;
    
    numerator = (POW_S_rd)^2  *  (abs(CH_sr))^2  *  (abs(CH_rd))^2;
    denominator = ( POW_S_rd*(abs(CH_sr))^2+ POW_S_rd*(abs(CH_rd))^2+POW_N_rd ) * POW_N_rd;
    gamma_rd = numerator / denominator;


%% output SNR
gamma = gamma_sd + gamma_rd; 

%%  output bpsk system's approximate theoretical BER
theoretical_BER = 1 / ( 2 * sqrt(pi*gamma) * exp(gamma) );  % Approximation under high BER 
