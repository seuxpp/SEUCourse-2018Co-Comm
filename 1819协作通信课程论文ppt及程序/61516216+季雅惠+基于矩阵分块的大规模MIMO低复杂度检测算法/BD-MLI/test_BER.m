% hard detection, BER

clc;
clear all;close all;

% 定义循环次数
targetErrors = 500;
maxNumTransmissions = 5e7;

% 调制方式
M = 16;
k = log2(M);

% 天线配置
nRx = 256;%基站天线数
nTx = 64;%用户数
bl=1;%每个用户端天线数

% 信噪比定义
Es = 1;
SNRdB = 4:2:14;
EsN0dB = SNRdB - 10*log10(nTx);
% EsN0dB = SNRdB - 10*log10(nTx);
%Eb = Es/k;
%EbN0dB = EsN0dB - 10*log10(k);
%EbN0 = 10.^(EbN0dB/10);
EsN0 = 10.^(EsN0dB/10);
N0 = Es./EsN0;

% 发送矩阵参数
scaling = 1; % 星座图能量归一化
% frameLength = 2^6;
frameLength = 2^9; 

% 初始化
BERNum = 10;%测试算法数
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
            cH =  newchennel(nRx,nTx,0.2,0,0,bl);
            cB = cH*TxSymbol;
            cY = step(ch,cB);
            cG = cH'*cH;
            cW = cG + eye(nTx)*N0(n);
            cWinv = cW^(-1);
            cYBar = cH'*cY;
            cD = diag(diag(cW));
            cDinv = cD^(-1);
           
            cWinvNeum1 = Method_MLI(cW,6,7,2);
            cWinvNeum2 = Method_TLI(cW,8,10,2);
            cWinvNeum3 = Method_MLI(cW,17,17,4);
            cWinvNeum4 = Method_TLI(cW,15,15,4);
            cWinvNeum5 = Method_MLI2(cW,22,22,8);
            cWinvNeum6 = Method_TLI(cW,20,20,8);
            cWinvNeum7 = Method_TLI(cW,25,25,16);
            cWinvNeum8 = Method_TLI(cW,30,30,32);
            cWinvNeum9 = Method_Neumann(cW,35);
            
            cSHat{1} = cWinv*cYBar;
            cSHat{2} = cWinvNeum1*cYBar;
            cSHat{3} = cWinvNeum2*cYBar;
            cSHat{4} = cWinvNeum3*cYBar;
            cSHat{5} = cWinvNeum4*cYBar;
            cSHat{6} = cWinvNeum5*cYBar;
            cSHat{7} = cWinvNeum6*cYBar;
            cSHat{8} = cWinvNeum7*cYBar;
            cSHat{9} = cWinvNeum8*cYBar;
            cSHat{10} = cWinvNeum9*cYBar;

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
figure(1)
%load(dataName);
semiplot = semilogy(...
SNRdB,BERVec{1}(1,:),'-',...
SNRdB,BERVec{2}(1,:),'.-',...
SNRdB,BERVec{3}(1,:),'.-',...
SNRdB,BERVec{4}(1,:),'.-',...
SNRdB,BERVec{5}(1,:),'.-',...
SNRdB,BERVec{6}(1,:),'.-',...
SNRdB,BERVec{7}(1,:),'.-',...
SNRdB,BERVec{8}(1,:),'.-',...
SNRdB,BERVec{9}(1,:),'.-',...
SNRdB,BERVec{10}(1,:),'.-',...
'LineWidth',1.5, 'MarkerSize',18);
set(semiplot(1),'Color',[0 0 0]);
set(semiplot(2),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);%橙色
set(semiplot(3),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);%黄色
set(semiplot(4),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);%紫色
set(semiplot(5),'Color',[32, 88, 103]/256);%绿色
set(semiplot(6),'Color',[61, 89, 171]/256);%蓝色
set(semiplot(7),'Color',[115, 74, 18]/256);%棕色
set(semiplot(8),'Color',[227, 23, 13]/256);%红色
set(semiplot(9),'Color',[0 199 140]/256);%青色
set(semiplot(10),'Color',[218 112 214]/256);%淡紫色
grid on;
strLegend = {'MMSE',...
'$K=2,MLI,K_F=6,K_n=7$'...
'$K=2,TLI,K_F=8,K_n=10$'...
'$K=4,MLI,K_F=17,K_n=17$'...
'$K=4,TLI,K_F=15,K_n=15$'...
'$K=8,MLI,K_F=22,K_n=22$'...
'$K=8,TLI,K_F=20,K_n=20$'...
'$K=16,TLI,K_F=25,K_n=25$'...
'$K=32,TLI,K_F=30,K_n=30$'...
'$K=64,Neumann,K_F=35$'};
legend_handle = legend(strLegend,3);
set(legend_handle,'Interpreter','latex')
xlabel ('SNR [dB]'); ylabel ('BER');