function signal_combine = Mrc( varargin )
    
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
    
    a_sd = CH_sd' * sqrt(POW_S_sd) / POW_N_sd;
    a_rd = (beta * sqrt(POW_S_rd) * CH_sr' * CH_rd') / ( (beta^2*(abs(CH_rd))^2+1) * POW_N_rd ); 
    
    signal_combine = a_sd*signal_sd + a_rd*signal_rd; 



