% hard detection, BER

clc;clear all;close all;

% 定义循环次数
targetErrors = 500;
maxNumTransmissions = 5e7;

% 调制方式
M = 64;
k = log2(M);

% 天线配置
nRx = 512;
nTx = 16;
bl=1;%用户端天线数

% 信噪比定义
Es = 1;
% SNRdB = 4:2:16;
% SNRdB = 8:2:20;
SNRdB = 4:0.2:16;
EsN0dB = SNRdB - 10*log10(nTx);
%Eb = Es/k;
%EbN0dB = EsN0dB - 10*log10(k);
%EbN0 = 10.^(EbN0dB/10);                  
EsN0 = 10.^(EsN0dB/10);
N0 = Es./EsN0; 

% 发送矩阵参数
scaling = 1; % 星座图能量归一化
% frameLength = 2^6; 
frameLength = 2^5; 
% 初始化
%BERNum = 9;
BERNum = 7;
[hErrorCalc, BERVec] =  Generator_BERVec(SNRdB, BERNum);
cSHat = cell(BERNum, 1);
demodData = cell(BERNum, 1);
decLLRMat = cell(BERNum, 1);
decBit = cell(BERNum, 1);
modData = zeros(frameLength, nTx);
cLegend = cell(BERNum, 1);
for n=1:length(SNRdB)
    for i = 1:BERNum
        reset(hErrorCalc{i});
    end
%     while (BERVec{7}(2,n) < targetErrors) && (BERVec{7}(3,n) < maxNumTransmissions) 
        data = randi([0 1], frameLength*nTx*k, 1);
        dataMat = reshape(data, frameLength*k, nTx);
        % 对每个数据流编码、调制
        for istream = 1:nTx 
            modData(:,istream) = Mod_QAM(dataMat(:,istream),M,scaling);
        end
        frmSymbol = modData.';
        ch = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Es/No)','EsNo',EsN0dB(n));  
        % 发送frameLength次符号向量
        for itx = 1:frameLength
            TxSymbol = frmSymbol(:,itx);
%             cH = Channel_Corr(nRx,nTx,0.3,0.3);
            cH =  newchennel(nRx,nTx,0.3,0.1,bl);
            cB = cH*TxSymbol;     
            cY = step(ch,cB);
            cG = cH'*cH;
            cW = cG + eye(nTx)*N0(n);       
            cWinv = cW^(-1);
            cYBar = cH'*cY;
            %cYBarScaled = cYBar/nRx;
            cD = diag(diag(cW));
            cDinv = cD^(-1);
           
            itStart = 2;
%             cWinvNeum1 = Method_dmmBDNeumann(cW,4,5,bl);
%             cWinvNeum2 = Method_mmBDNeumann(cW,5,bl);
%             cWinvNeum3 = Method_mBDNeumann(cW,5,bl);
%             cWinvNeum4 = Method_BDNeumann(cW,5,bl);
            cWinvNeum1 = Method_mmBDNeumann(cW,3,bl);
            cWinvNeum2 = Method_dmmBDNeumann(cW,4,3,bl);
            cWinvNeum3 = Method_mBDNeumann(cW,3,bl);
            cWinvNeum4 = Method_BDNeumann(cW,6,bl);
            
            cSHat{1} = cWinv*cYBar;         
            cSHat{2} = cWinvNeum1*cYBar;        
            cSHat{3} = cWinvNeum2*cYBar;
            cSHat{4} = cWinvNeum3*cYBar;
            cSHat{5} = cWinvNeum4*cYBar;
%             cSHat{6} = Method_CG(cW,cYBar,itStart);
%             cSHat{7} = Method_CG(cW,cYBar,itStart+1);
            cSHat{6} = Method_PreconditionedGS(cW,cYBar,itStart); 
            cSHat{7} = Method_PreconditionedGS(cW,cYBar,itStart+1); 

            matE1 = cWinv*cG;
            [mu1,rho1] = Calc_SINR_Appr(matE1,ones(nTx,1));

            % 计算LLR
            for i = 1:BERNum
                demodData{i} = Calc_LLR_Appr(rho1,cSHat{i},M,1);
                decLLRMat{i}(k*(itx-1)+1:k*itx,:) = demodData{i};
            end
        end
        for i = 1:BERNum
            % 硬判决
            decBit{i}=Calc_Hard_Decision(decLLRMat{i});
            % 累积错误比特数，计算误码率
            BERVec{i}(:,n) = step(hErrorCalc{i}, dataMat(:), decBit{i}(:));
        end
%     end   
    disp(['SNR=',num2str(SNRdB(n))])
end

%%
%dataName = ['data\Hard_BER_Corr_',num2str(nRx),'x',num2str(nTx)];
%save(dataName,'M','BERNum','BERVec','SNRdB','itStart')
%%
figure(2)
%load(dataName);
semiplot = semilogy(...
SNRdB,BERVec{1}(1,:),'-',...
SNRdB,BERVec{2}(1,:),'.-',...
SNRdB,BERVec{3}(1,:),'.-',...
SNRdB,BERVec{4}(1,:),'.-',...
SNRdB,BERVec{5}(1,:),'.-',...
SNRdB,BERVec{6}(1,:),'b--',...
SNRdB,BERVec{7}(1,:),'b.-',...
'LineWidth',1, 'MarkerSize',18);
% SNRdB,BERVec{8}(1,:),'--',...
% SNRdB,BERVec{9}(1,:),'.-',...
% 'LineWidth',5, 'MarkerSize',20);
% SNRdB,BERVec{2}(1,:),'r-pentagram',...
set(semiplot(1),'Color',[0 0 0]);
set(semiplot(2),'Color',[32, 88, 103]/256);
set(semiplot(3),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
set(semiplot(4),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);
set(semiplot(5),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
% set(semiplot(6),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);
% set(semiplot(7),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);
% set(semiplot(8),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
% set(semiplot(9),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
% set(semiplot(1),'Color',[0 0 0]);
% set(semiplot(2),'Color',[32, 88, 103]/256);
% set(semiplot(3),'Color',[32, 88, 103]/256);
% set(semiplot(4),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
% set(semiplot(5),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
% set(semiplot(6),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);
% set(semiplot(7),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);
% set(semiplot(8),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
% set(semiplot(9),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
grid on;
strLegend = {'MMSE',...
'more-level-BDNeumann,$K_F=3,K_n=3$','more-level-BDNeumann,$K_F=3,K_n=4$',...
'two-level-BDNeumann,$K_F=3,K_S=3$',...
'BDNeumann,$K=6$',...
'Method-PGS,$K=2$','Method-PGS,$K=3$'};
% 'PGS, $K=3$','PGS, $K=4$'};
legend_handle = legend(strLegend);
set(legend_handle,'Interpreter','latex')
title('N=512 M=64 \zeta_1=\zeta_2=0 m_U_E=1');
xlabel ('SNR [dB]'); ylabel ('BER');

figure(1)
%load(dataName);
semiplot = semilogy(...
SNRdB,berldpcfloat,'.-',...
SNRdB,berldpcfix,'.-',...
SNRdB,berpolarfloat,'.-',...
SNRdB,berpolarfix,'.-',...
'LineWidth',1, 'MarkerSize',18);
set(semiplot(1),'Color',[0 0 0]);
set(semiplot(2),'Color',[32, 88, 103]/256);
set(semiplot(3),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
set(semiplot(4),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);
grid on;
strLegend = {
'ldpc float',...
'ldpc fixed $(1,4,2)$',...
'polar float',...
'polar fixed $(1,4,2)$'};
legend_handle = legend(strLegend);
set(legend_handle,'Interpreter','latex')
xlabel ('E_b/N_0 (dB)'); ylabel ('BER');

berldpcfloat=[0.0964999999999995,0.0585000000000001,0.0325000000000000,0.0165000000000000,0.00514285714285715,0.00185714285714286,0.000285714285714286];
berldpcfix=[0.112857142857142,0.0710714285714285,0.0445000000000001,0.0238571428571429,0.00935714285714285,0.00457142857142857,0.00157142857142857];
berpolarfloat=[0.101875000000000,0.0637500000000000,0.0286250000000000,0.0213750000000000,0.00650000000000000,0.00212500000000000,0.000325000000000000];
berpolarfix=[0.114000000000000,0.0686250000000000,0.0332500000000000,0.0260000000000000,0.00887500000000000,0.00412500000000000,0.000625000000000000];
