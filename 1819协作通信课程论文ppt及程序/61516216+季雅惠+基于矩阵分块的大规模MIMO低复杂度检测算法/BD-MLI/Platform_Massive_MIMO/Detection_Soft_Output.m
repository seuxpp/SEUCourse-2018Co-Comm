% soft-output detection, LDPC, BER

clc;clear all;close all;

% 定义循环次数
targetErrors = 500;
maxNumTransmissions = 5e6;

% 调制方式
M = 64;
k = log2(M);

% 天线配置
nRx = 128;
nTx = 16;       

% 信噪比定义
Es = 1;
SNRdB = 4:4:20;
EsN0dB = SNRdB - 10*log10(nTx);
%Eb = Es/k;
%EbN0dB = EsN0dB - 10*log10(k);
%EbN0 = 10.^(EbN0dB/10);                  
EsN0 = 10.^(EsN0dB/10);
N0 = Es./EsN0; 

% 定义编解码器
hEnc = comm.LDPCEncoder;
hDec = comm.LDPCDecoder('DecisionMethod','Soft decision');
rate = 1/2;

% 发送矩阵参数
scaling = 1; % 星座图能量归一化
q = 32400/k; 
frameLength = 32400/rate/k; 

% 初始化
BERNum = 9;
[hErrorCalc, BERVec] =  Generator_BERVec(SNRdB, BERNum);
cSHat = cell(BERNum, 1);
demodData = cell(BERNum, 1);
decLLRMat = cell(BERNum, 1);
decBit = cell(BERNum, 1);
%modData = zeros(frameLength, nTx);
cLegend = cell(BERNum, 1);
encodedData = zeros(32400/rate, nTx);
modData = zeros(frameLength, nTx);
decodedBit = cell(BERNum, 1);
deciBit = cell(BERNum, 1);


for n=1:length(SNRdB)
    for i = 1:BERNum
        reset(hErrorCalc{i});
    end
%     while (BERVec{7}(2,n) < targetErrors) && (BERVec{7}(3,n) < maxNumTransmissions) 
        data = randi([0 1], q*nTx*k, 1);
        dataMat = reshape(data, q*k, nTx);
        % 对每个数据流编码、调制
        for istream = 1:nTx 
            encodedData(:,istream) = step(hEnc, dataMat(:,istream));
            modData(:,istream) = Mod_QAM(encodedData(:,istream),M,scaling);
        end          
        frmSymbol = modData.';
        ch = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Es/No)','EsNo',EsN0dB(n));  
        % 发送frameLength次符号向量
        for itx = 1:frameLength
            TxSymbol = frmSymbol(:,itx);
            cH = Channel_iid(nRx,nTx);
            cB = cH*TxSymbol;     
            cY = step(ch,cB);
            cG = cH'*cH;     
            cW = cG + eye(nTx)*N0(n);       
            cWinv = cW^(-1);     
            cYBar = cH'*cY;
            %cYBarScaled = cYBar/nRx;
            cD = diag(diag(cW));
            cDinv = cD^(-1);
            
            itStart = 3;
            cWinvNeum1 = Method_Neumann(cW,itStart);
            cWinvNeum2 = Method_Neumann(cW,itStart+1);
            
            cSHat{1} = cWinv*cYBar;         
            cSHat{2} = cWinvNeum1*cYBar;        
            cSHat{3} = cWinvNeum2*cYBar;        
            cSHat{4} = Method_CG(cWinv,cYBar,itStart);
            cSHat{5} = Method_CG(cWinv,cYBar,itStart+1);
            cSHat{6} = Method_GS(cWinv,cYBar,itStart,0);
            cSHat{7} = Method_GS(cWinv,cYBar,itStart+1,0);
            cSHat{8} = Method_PreconditionedGS(cWinv,cYBar,itStart); 
            cSHat{9} = Method_PreconditionedGS(cWinv,cYBar,itStart+1); 
  
   
            matE1 = cWinv*cG;
            [mu1,rho1] = Calc_SINR_Appr(matE1,ones(nTx,1));

            % 计算LLR
            for i = 1:BERNum 
                demodData{i} = Calc_LLR_Appr(rho1,cSHat{i},M,1);
                decLLRMat{i}(k*(itx-1)+1:k*itx,:) = demodData{i};
            end
        end
        for i = 1:BERNum
            % 解码
            for iiTx = 1:nTx
                reset(hDec);
                decodedBit{i}(:,iiTx) = step(hDec, decLLRMat{i}(:,iiTx));
            end
            % 硬判决
            deciBit{i}=Calc_Hard_Decision(decodedBit{i});
            % 累积错误比特数，计算误码率
            BERVec{i}(:,n) = step(hErrorCalc{i}, dataMat(:), deciBit{i}(:));
%         end
    end   
    disp(['SNR=',num2str(SNRdB(n)),'; BER=',num2str(BERVec{1}(1,n))]);
end

%%
%dataName = ['data\Soft_BER_',num2str(nRx),'x',num2str(nTx)];
%save(dataName,'M','BERNum','BERVec','SNRdB','itStart')
%%
figure(1)

semiplot = semilogy(...
SNRdB,BERVec{1}(1,:),'b-',...
SNRdB,BERVec{2}(1,:),'--',...
SNRdB,BERVec{3}(1,:),'.-',...
SNRdB,BERVec{4}(1,:),'--',...
SNRdB,BERVec{5}(1,:),'.-',...
SNRdB,BERVec{6}(1,:),'--',...
SNRdB,BERVec{7}(1,:),'.-',...
SNRdB,BERVec{8}(1,:),'--',...
SNRdB,BERVec{9}(1,:),'.-',...
'LineWidth',1, 'MarkerSize',20.0);

set(semiplot(1),'Color',[0 0 0]);
set(semiplot(2),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
set(semiplot(3),'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
set(semiplot(4),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
set(semiplot(5),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
set(semiplot(6),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);
set(semiplot(7),'Color',[0.494117647409439 0.184313729405403 0.556862771511078]);
set(semiplot(8),'Color',[32, 88, 103]/256);
set(semiplot(9),'Color',[32, 88, 103]/256);
grid on;
strLegend = {'MMSE',...
'Neumann, $K=3$','Neumann, $K=4$',...
'CG, $K=3$','CG, $K=4$',...
'GS, $K=3$','GS, $K=4$',...
'PGS, $K=3$','PGS, $K=4$'};
legend_handle = legend(strLegend);
set(legend_handle,'Interpreter','latex')
xlabel ('SNR [dB]'); ylabel ('BER');
