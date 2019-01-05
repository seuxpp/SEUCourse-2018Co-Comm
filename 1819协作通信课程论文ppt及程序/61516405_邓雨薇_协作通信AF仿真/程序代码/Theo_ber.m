%% function of theoretical BER
%**************************************************************************
%本程序有版权可随意使用发布，但请保留原版信息Copyleft
%Author: 11/06/2010 Davy
%2010.06.11 由 Davy 以账号 yuema1086 发布于 www.CSDN.com
%**************************************************************************
%==========================================================================
% Description: Approach in the relay node with AF
% Usage:  H = RayleighCH(mu,sigma)
% Inputs:
%         SNR_SD: SNR without cooperation
%         CH_sd,CH_sr,CH_rd 
%         : Rayleigh Fading coefficient of Channel S_in_R 
%         POW_S_sd,POW_N_sd,POW_S_rd,POW_N_rd
%         : Signal and Noise Power of Channels S_to_D S_to_R and R_to_D
% Outputs:
%         theoretical_BER: BER approximation theory
% =========================================================================

function theoretical_BER = Theo_ber( varargin )
%% According to the numbers of input parameter to determine AF or DF model,than calculate the SNR
if nargin == 1  % SD
    SNR_SD = varargin{1};
% for SD SNR
    gamma_sd = SNR_SD;
    gamma_rd = 0; 

elseif nargin == 6  % DF
    CH_sd = varargin{1};
    CH_rd = varargin{2};
    POW_S_sd = varargin{3};
    POW_N_sd = varargin{4};
    POW_S_rd = varargin{5};
    POW_N_rd = varargin{6};   
% for DF SNR
    gamma_sd = ( POW_S_sd * (abs(CH_sd))^2 ) / POW_N_sd;
    gamma_rd = ( POW_S_rd * (abs(CH_rd))^2 ) / POW_N_rd;  

elseif nargin == 7  % AF
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

end

%% output SNR
gamma = gamma_sd + gamma_rd; 

%%  output bpsk system's approximate theoretical BER
theoretical_BER = 1 / ( 2 * sqrt(pi*gamma) * exp(gamma) );  % Approximation under high BER
% theoretical_BER = erfc( sqrt(gamma) ) / 2;    % Actual value
