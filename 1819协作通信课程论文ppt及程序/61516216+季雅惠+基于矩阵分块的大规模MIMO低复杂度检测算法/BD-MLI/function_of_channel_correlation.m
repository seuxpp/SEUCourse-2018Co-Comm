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
bl=4;%每个用户端天线数
ratio=0:0.1:1;

% 信噪比定义
Es = 1;
SNRdB = 16;
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
frameLength = 2^12; 

% 初始化
BERNum = 4;%测试算法数
[hErrorCalc, BERVec] =  Generator_BERVec(SNRdB, BERNum);
cSHat = cell(BERNum, 1);
demodData = cell(BERNum, 1);
decLLRMat = cell(BERNum, 1);
decBit = cell(BERNum, 1);
modData = zeros(frameLength, nTx);
cLegend = cell(BERNum, 1);
for n=1:length(ratio)
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
        ch = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Es/No)','EsNo',EsN0dB(1));
        % 发送frameLength次符号向量
        for itx = 1:frameLength
            TxSymbol = frmSymbol(:,itx);
            cH =  newchennel(nRx,nTx,0.2,0,ratio(n),bl);
            cB = cH*TxSymbol;
            cY = step(ch,cB);
            cG = cH'*cH;
            cW = cG + eye(nTx)*N0(1);
            cWinv = cW^(-1);
            cYBar = cH'*cY;
            cD = diag(diag(cW));
            cDinv = cD^(-1);
           
            cWinvNeum1 = Method_dmmBDNeumann(cW,6,7,bl);
%             cWinvNeum2 = Method_MLI(cW,5,7,2);
            cWinvNeum2 = Method_TLI(cW,8,10,2);
%             cWinvNeum4 = Method_TLI(cW,7,10,2);
            
            cSHat{1} = cWinv*cYBar;
            cSHat{2} = cWinvNeum1*cYBar;
            cSHat{3} = cWinvNeum2*cYBar;
            cSHat{4} = Method_CG(cW,cYBar,6);
%             cSHat{5} = cWinvNeum4*cYBar;
%             cSHat{6} = Method_CG(cW,cYBar,6);
%             cSHat{7} = Method_CG(cW,cYBar,5);

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
    disp(['ratio=',num2str(ratio(n))])
end

%%
%dataName = ['data\Hard_BER_Corr_',num2str(nRx),'x',num2str(nTx)];
%save(dataName,'M','BERNum','BERVec','SNRdB','itStart')
%%
figure(1)
%load(dataName);
semiplot = semilogy(...
ratio,BERVec{1}(1,:),'-',...
ratio,BERVec{2}(1,:),'--',...
ratio,BERVec{3}(1,:),'--',...
ratio,BERVec{4}(1,:),'--',...
'LineWidth',2.5, 'MarkerSize',18);
set(semiplot(1),'Color',[0 0 0]);
set(semiplot(2),'Color',[61, 89, 171]/256);%蓝色
% set(semiplot(3),'Color',[61, 89, 171]/256);%蓝色
set(semiplot(3),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);%橙色
% set(semiplot(5),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);%橙色
set(semiplot(4),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);%黄色
% set(semiplot(7),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);%黄色
grid on;
strLegend = {'MMSE',...
'$BD-MLI,K_F=6,K_N=7$'...
'$BM,K_F=8,K_S=10$'...   
'$CG,K_F=6$'};
legend_handle = legend(strLegend);
set(legend_handle,'Interpreter','latex')
xlabel ('\zeta_t'); ylabel ('BER');