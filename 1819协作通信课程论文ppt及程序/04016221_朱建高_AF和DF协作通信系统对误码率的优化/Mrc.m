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



