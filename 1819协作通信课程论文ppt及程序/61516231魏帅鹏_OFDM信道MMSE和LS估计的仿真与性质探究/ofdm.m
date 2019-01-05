clc;clear all;close all;echo off;tic;
% -------------------------------------------------------------------
%                      参数定义
% --------------------------------------------------------------
Fd    = 1;             % symbol rate (1Hz)
Fs    = 1*Fd;          % number of sample per symbol
M     = 4;             % kind(range) of symbol (0,1,2,3)
Ndata = 1024;          % all transmitted data symbol 
Sdata = 64;            % 64 data symbol per frame to ifft
Slen  = 128;           % 128 length symbol for IFFT 
Nsym  = Ndata/Sdata;   % number of frames -> Nsym frame
GIlen = 144;           % symbol with GI insertion  GIlen = Slen + GI
GI    = 16;            % guard interval length
% ----------------------------------------------------------------
%                        向量初始化
% ----------------------------------------------------------------
X  = zeros(Ndata,1);
Y1 = zeros(Ndata,1);
Y2 = zeros(Ndata,1);
Y3 = zeros(Slen,1);
z0 = zeros(Slen,1);
z1 = zeros(Ndata/Sdata*Slen,1);
g  = zeros(GIlen,1);
z2 = zeros(GIlen*Nsym,1);
z3 = zeros(GIlen*Nsym,1);
% random integer generation by M kinds 
X = randint(Ndata, 1, M);
% digital symbol mapped as analog symbol
% Y1 is a Ndata-by-2 matrix, is changed into Y2 by "amodce"
Y1 = modmap(X, Fd, Fs, 'qask', M);
% covert to complex number
Y2 = amodce(Y1,1,'qam');
% figure(1);
% scatterplot(Y2,length(Y2),0,'bo');grid on;
scatterplot(Y2,Fd,0,'bo');grid on;
title('4-QAM 星座图');
Tx_spectrum = zeros(size(Y3));
for j=1:Nsym;
    for i=1:Sdata;
        Y3(i+Slen/2-Sdata/2,1)=Y2(i+(j-1)*Sdata,1);
        Tx_spectrum = Tx_spectrum + abs(Y3);
    end
    z0=ifft(Y3);
    
    for i=1:Slen;    % generate time-domain vector, z1, without GI
        z1(((j-1)*Slen)+i)=z0(i,1);
    end
    %
    for i=1:Slen;
        g(i+16)=z0(i,1);
    end
    
    for i=1:GI;
        g(i)=z0(i+Slen-GI,1);    
    end
    for i=1:GIlen;  % generate time-domain vector, z2, with GI
        z2(((j-1)*GIlen)+i)=g(i,1);
    end
    
end

Y4 = fft(z1);  % FFT operation, at receiver
% if Y4 is under 0.01 Y4=0.001
for j=1:Ndata/Sdata*Slen;
if abs(Y4(j)) < 0.01
    Y4(j)=0.01;
end
end
Y4 = 10*log10(abs(Y4));  %  Y4 is used for spectrum display.
% 频域图

figure(2);
f = linspace(-Sdata,Sdata,length(Y3));
plot(f,abs(Y3),'b-','LineWidth',6);grid on;
axis([-Slen/2 Slen/2 -2 2]);
title('发送的信号图谱');
figure(3);
f = linspace(-Sdata,Sdata,length(Y4));
plot(f,Y4);grid on;
axis([-Slen/2 Slen/2 -20 20]);
title('接收的信号图谱');
simulation_time = toc
