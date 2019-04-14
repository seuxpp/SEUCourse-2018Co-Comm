%% function of the MRC
%**************************************************************************
%本程序有版权,仅供教学使用
%Author: 29/09/2013 wuguilu
%2013.09.29 
%**************************************************************************
%==========================================================================
% Description: only suitable for the double receiving aerial
% Usage: 
%   AF: R_combine = Mrc(CH_sd,CH_sr,CH_rd,beta,POW_S_sd,POW_N_sd,POW_S_rd,POW_N_rd,signal_sd,signal_rd)
%   DF: R_combine = Mrc(CH_sd,CH_rd,POW_S_sd,POW_N_sd,POW_S_rd,POW_N_rd,signal_sd,signal_rd)
% Inputs:  
%         CH_sd,CH_sr,CH_rd
%         : Rayleigh Fading coefficient of Channels S_in_D S_in_R and R_in_D
%         POW_S_sd,POW_N_sd,POW_S_rd,POW_N_rd
%         : Signal and Noise Power of Channels S_to_D S_to_R and R_to_D
%         signal_sd,signal_rd
%         : Signal of Channels S_to_D and S_to_R R_to_D
%         beta: amplification factor
% Outputs:
%         R_combine: Signal after MRC 
% =========================================================================
function signal_combine = Mrc( varargin )

%% According to the numbers of input parameter to determine AF or DF model, than calculate the gain coefficient
if nargin == 8  % DF
    CH_sd = varargin{1};
    CH_rd = varargin{2};
    POW_S_sd = varargin{3};
    POW_N_sd = varargin{4};
    POW_S_rd = varargin{5};
    POW_N_rd = varargin{6};
    signal_sd = varargin{7};
    signal_rd = varargin{8};  
    
% a_sd and a_rd are determined such that the SNR of the MRC output is maximized
    a_sd = CH_sd' * sqrt(POW_S_sd) / POW_N_sd;
    a_rd = CH_rd' * sqrt(POW_S_rd) / POW_N_rd;  

elseif nargin == 10  % AF
    CH_sd = varargin{1};
    CH_sr = varargin{2};
    CH_rd = varargin{3};
    beta = varargin{4};
    POW_S_sd = varargin{5};
    POW_N_sd = varargin{6};
    POW_S_rd = varargin{7};
    POW_N_rd = varargin{8};
    signal_sd = varargin{9};
    signal_rd = varargin{10};
    
% a_sd and a_rd are determined such that the SNR of the MRC output is maximized
    a_sd = CH_sd' * sqrt(POW_S_sd) / POW_N_sd;
    a_rd = (beta * sqrt(POW_S_rd) * CH_sr' * CH_rd') / ( (beta^2*(abs(CH_rd))^2+1) * POW_N_rd ); 
end

%% output after MRC
signal_combine = a_sd*signal_sd + a_rd*signal_rd; 



