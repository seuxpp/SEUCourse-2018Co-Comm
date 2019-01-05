function theoretical_BER = Theo_ber( varargin )
%% According to the numbers of input parameter to determine AF or DF model,than calculate the SNR
if nargin == 1  % SD
    SNR_SD = varargin{1};
% for SD SNR
    gamma_sd = SNR_SD;
    gamma_rd = 0; 

elseif nargin == 6  % DF
    CH_sd = varargin{1};%��ȡ����ĵ�1������
    CH_rd = varargin{2};%��ȡ����ĵ�2������
    POW_S_sd = varargin{3};%��ȡ����ĵ�3������
    POW_N_sd = varargin{4};%��ȡ����ĵ�4������
    POW_S_rd = varargin{5};%��ȡ����ĵ�5������
    POW_N_rd = varargin{6};%��ȡ����ĵ�6������   
% for DF SNR
    gamma_sd = ( POW_S_sd * (abs(CH_sd))^2 ) / POW_N_sd;
    gamma_rd = ( POW_S_rd * (abs(CH_rd))^2 ) / POW_N_rd;  

elseif nargin == 7  % AF
    CH_sd = varargin{1};%����ͬ��
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

end

%% output SNR
gamma = gamma_sd + gamma_rd; 

%%  output bpsk system's approximate theoretical BER
theoretical_BER = 1 / ( 2 * sqrt(pi*gamma) * exp(gamma) );  % Approximation under high BER 
% theoretical_BER = erfc( sqrt(gamma) ) / 2;    % Actual value
