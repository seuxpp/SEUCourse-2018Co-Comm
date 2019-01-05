

function theoretical_BER = Theo_ber( varargin )

if nargin == 6  % DF  K=1
    CH_sd = varargin{1};%获取传入的第1个参数
    CH_rd1 = varargin{2};%获取传入的第2个参数
    POW_S_sd = varargin{3};%获取传入的第3个参数
    POW_N_sd = varargin{4};%获取传入的第4个参数
    POW_S_rd = varargin{5};%获取传入的第5个参数
    POW_N_rd = varargin{6};%获取传入的第6个参数   

    gamma_sd = ( POW_S_sd * (abs(CH_sd))^2 ) / POW_N_sd;
    gamma_rd1 = ( POW_S_rd * (abs(CH_rd1))^2 ) / POW_N_rd;  
gamma1 = gamma_sd + gamma_rd1; 
 M=10;
   syms x ;
   y=exp(-gamma1*(sin(pi/M))^2/(sin(x))^2)*1 / ( 2 * sqrt(pi*gamma1) * exp(gamma1) );
   a=int(y,x,0,(M-1)/M*pi);
  theoretical_BER =vpa(a);
elseif nargin == 8  % DF  K=3
    CH_sd = varargin{1};
    CH_rd1 = varargin{2};
    CH_rd2 = varargin{3};
    CH_rd3 = varargin{4};
    POW_S_sd = varargin{5};
    POW_N_sd = varargin{6};
    POW_S_rd = varargin{7};
    POW_N_rd = varargin{8};

    gamma_sd = ( POW_S_sd * (abs(CH_sd))^2 ) / POW_N_sd;
    gamma_rd3 = ( POW_S_rd * (abs(CH_rd1))^2 ) / POW_N_rd+( POW_S_rd * (abs(CH_rd2))^2 ) / POW_N_rd+( POW_S_rd * (abs(CH_rd3))^2 ) / POW_N_rd;  
gamma3= gamma_sd + gamma_rd3; 
 M=10;
   syms x ;
   y=exp(-gamma3*(sin(pi/M))^2/(sin(x))^2)*1 / ( 2 * sqrt(pi*gamma3) * exp(gamma3) );
 a=int(y,x,0,(M-1)/M*pi);
   theoretical_BER =vpa(a);
elseif nargin == 10 % DF  K=5
    CH_sd = varargin{1};
    CH_rd1 = varargin{2};
        CH_rd2 = varargin{3};
    CH_rd3 = varargin{4};
        CH_rd4 = varargin{5};
    CH_rd5 = varargin{6};
    POW_S_sd = varargin{7};
    POW_N_sd = varargin{8};
    POW_S_rd = varargin{9};
    POW_N_rd = varargin{10}; 

    gamma_sd = ( POW_S_sd * (abs(CH_sd))^2 ) / POW_N_sd;
    gamma_rd5 = ( POW_S_rd * (abs(CH_rd1))^2 ) / POW_N_rd+( POW_S_rd * (abs(CH_rd2))^2 ) / POW_N_rd+( POW_S_rd * (abs(CH_rd3))^2 ) / POW_N_rd+( POW_S_rd * (abs(CH_rd4))^2 ) / POW_N_rd+( POW_S_rd * (abs(CH_rd5))^2 ) / POW_N_rd ;
gamma5 = gamma_sd + gamma_rd5; 
 M=10;
   syms  x ;
   y=exp(-gamma5*(sin(pi/M))^2/(sin(x))^2)*1 / ( 2 * sqrt(pi*gamma5) * exp(gamma5) );
 a=int(y,x,0,(M-1)/M*pi);
   theoretical_BER =vpa(a);
elseif nargin == 7  % AF  K=1
    CH_sd = varargin{1};
    CH_sr1 = varargin{2};
    CH_rd1 = varargin{3};
    POW_S_sd = varargin{4};
    POW_N_sd = varargin{5};
    POW_S_rd1 = varargin{6};
    POW_N_rd1 = varargin{7};    
    gamma_sd = ( POW_S_sd * (abs(CH_sd))^2 ) / POW_N_sd;
    
    numerator1 = (POW_S_rd1)^2  *  (abs(CH_sr1))^2  *  (abs(CH_rd1))^2;
    denominator1 = ( POW_S_rd1*(abs(CH_sr1))^2+ POW_S_rd1*(abs(CH_rd1))^2+POW_N_rd1 ) * POW_N_rd1;
    gamma_rd1 = numerator1 / denominator1;
    gamma1 = gamma_sd + gamma_rd1;
 M=10;
   syms x ;
   y=exp(-gamma1*(sin(pi/M))^2/(sin(x))^2)*1 / ( 2 * sqrt(pi*gamma1) * exp(gamma1) );
 a=int(y,x,0,(M-1)/M*pi);
   theoretical_BER =vpa(a);
elseif nargin == 11  % AF  K=3
    CH_sd = varargin{1};
    CH_sr1 = varargin{2};
    CH_rd1 = varargin{3};
    CH_sr2 = varargin{4};
    CH_rd2 = varargin{5};
    CH_sr3 = varargin{6};
    CH_rd3 = varargin{7};
    POW_S_sd = varargin{8};
    POW_N_sd = varargin{9};
    POW_S_rd = varargin{10};
    POW_N_rd = varargin{11};    
% for AF SNR
    gamma_sd = ( POW_S_sd * (abs(CH_sd))^2 ) / POW_N_sd;
    
    numerator1 = (POW_S_rd)^2  *  (abs(CH_sr1))^2  *  (abs(CH_rd1))^2;
    numerator2 = (POW_S_rd)^2  *  (abs(CH_sr2))^2  *  (abs(CH_rd2))^2;
    numerator3 = (POW_S_rd)^2  *  (abs(CH_sr3))^2  *  (abs(CH_rd3))^2;
    denominator1 = ( POW_S_rd*(abs(CH_sr1))^2+ POW_S_rd*(abs(CH_rd1))^2+POW_N_rd ) * POW_N_rd;
    denominator2 = ( POW_S_rd*(abs(CH_sr2))^2+ POW_S_rd*(abs(CH_rd2))^2+POW_N_rd ) * POW_N_rd;
    denominator3 = ( POW_S_rd*(abs(CH_sr3))^2+ POW_S_rd*(abs(CH_rd3))^2+POW_N_rd ) * POW_N_rd;
    gamma_rd3 = numerator1/ denominator1+numerator2/denominator2+numerator3/ denominator3;
    gamma3 = gamma_sd + gamma_rd3;
     M=10;
   syms  x ;
   y=exp(-gamma3*(sin(pi/M))^2/(sin(x))^2)*1 / ( 2 * sqrt(pi*gamma3) * exp(gamma3) );
 a=int(y,x,0,(M-1)/M*pi);
   theoretical_BER =vpa(a);
    elseif nargin == 15  % AF  K=5
    CH_sd = varargin{1};
    CH_sr1 = varargin{2};
    CH_rd1 = varargin{3};
    CH_sr2 = varargin{4};
    CH_rd2 = varargin{5};
    CH_sr3 = varargin{6};
    CH_rd3 = varargin{7};
    CH_sr4 = varargin{8};
    CH_rd4 = varargin{9};
    CH_sr5 = varargin{10};
    CH_rd5 = varargin{11};
    POW_S_sd = varargin{12};
    POW_N_sd = varargin{13};
    POW_S_rd = varargin{14};
    POW_N_rd = varargin{15};    
    gamma_sd = ( POW_S_sd * (abs(CH_sd))^2 ) / POW_N_sd;
    numerator1 = (POW_S_rd)^2  *  (abs(CH_sr1))^2  *  (abs(CH_rd1))^2;
    numerator2 = (POW_S_rd)^2  *  (abs(CH_sr2))^2  *  (abs(CH_rd2))^2;
    numerator3 = (POW_S_rd)^2  *  (abs(CH_sr3))^2  *  (abs(CH_rd3))^2;   
    numerator4 = (POW_S_rd)^2  *  (abs(CH_sr4))^2  *  (abs(CH_rd4))^2;
    numerator5 = (POW_S_rd)^2  *  (abs(CH_sr5))^2  *  (abs(CH_rd5))^2;
    denominator1 = ( POW_S_rd*(abs(CH_sr1))^2+ POW_S_rd*(abs(CH_rd1))^2+POW_N_rd ) * POW_N_rd;
    denominator2 = ( POW_S_rd*(abs(CH_sr2))^2+ POW_S_rd*(abs(CH_rd2))^2+POW_N_rd ) * POW_N_rd;
    denominator3 = ( POW_S_rd*(abs(CH_sr3))^2+ POW_S_rd*(abs(CH_rd3))^2+POW_N_rd ) * POW_N_rd;
    denominator4 = ( POW_S_rd*(abs(CH_sr4))^2+ POW_S_rd*(abs(CH_rd4))^2+POW_N_rd ) * POW_N_rd;
    denominator5 = ( POW_S_rd*(abs(CH_sr5))^2+ POW_S_rd*(abs(CH_rd5))^2+POW_N_rd ) * POW_N_rd;
    gamma_rd5 = numerator1/ denominator1+numerator2/denominator2+numerator3/ denominator3+numerator4/denominator4+numerator5/ denominator5;
    gamma5 = gamma_sd + gamma_rd5;
    M=10;
   syms x  ;
   y=exp(-gamma5*(sin(pi/M))^2/(sin(x))^2)*1 / ( 2 * sqrt(pi*gamma5) * exp(gamma5) );
 a=int(y,x,0,(M-1)/M*pi);
   theoretical_BER =vpa(a);
   
end


