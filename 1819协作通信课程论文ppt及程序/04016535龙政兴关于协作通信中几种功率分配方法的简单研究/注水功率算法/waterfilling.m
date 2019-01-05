function [shanonCapacity powerAllocated] = ofdmwaterfilling(...
    nSubChannel,totalPower,channelStateInformation,bandwidth,noiseDensity);
%==========================================================================
%采用注水算法是为了最大化频率选择性信道容量。将总带宽分解成N个子载波。
%将频率选择性信道分解成多个平坦衰落信道。
%注水算法将给条件好的信道分配更多的功率，给条件不好的信道（处于深衰落）不分配功率。
% =========================================================================
%                                参数定义
% =========================================================================
% 
% nSubChannel               : 子信道数(4,16,32,...,2^N)
% totalPower                : 可以分配给每个OFDM信号的总功率(p 瓦特)
% channelStateInformation   : 信道状态信息，由随机矩阵产生
%                             matrix "random('rayleigh',1,1,nSubChannel)"
% bandwidth                 : 可利用的总带宽(单位Hz)
% noiseDensity              : 单边噪声谱密度(w/Hz)

% =========================================================================
%                               参数举例
% =========================================================================
% nSubChannel             = 16;
% totalPower              = 1e-5;           %  -20 dBm
% channelStateInformation = random('rayleigh',1/0.6552,1,nSubChannel);
% bandwidth               = 1e6;            %  1 MHz
% noiseDensity            = 1e-11;          % -80 dBm
% [Capacity PowerAllocated] = ofdmwaterfilling(...
%    nSubChannel,totalPower,channelStateInformation,bandwidth,noiseDensity)



%< 参数计算 >
    
    subchannelNoise     = ...
        noiseDensity*bandwidth/nSubChannel;%子信道噪声
    carrierToNoiseRatio = ...
        channelStateInformation.^2/subchannelNoise;%载噪比
    
    initPowerAllo       = ...                   (公式 1)
        (totalPower + sum(1./carrierToNoiseRatio))...
        /nSubChannel - 1./carrierToNoiseRatio;%初始化功率分配   
%到这个部分，因为最优的公式1，有些子信道可能已经被分配了功率
%这些子载波在接下来的计算中排除，不再使用任何功率，对其他子载波重复算法，直到所有剩下的子载波
%被分配了功率。

% < 算法的迭代部分 >
    while(length( find(initPowerAllo < 0 )) > 0 )%找到初始化功率分配中没有分配功率的信道，
                                                  %计算其长度，当这种信道存在时计算下面的部分。
        negIndex       = find(initPowerAllo <= 0);%没有分配功率的信道
        posIndex       = find(initPowerAllo >  0);%分配了功率的信道
        nSubchannelRem = length(posIndex);%分配了功率的信道数
        initPowerAllo(negIndex) = 0;
        CnrRem         = carrierToNoiseRatio(posIndex);
        powerAlloTemp  = (totalPower + sum(1./CnrRem))...
            /nSubchannelRem - 1./CnrRem;
        initPowerAllo(posIndex) = powerAlloTemp;
    end

% < 输出估计 >

%每个子信道分配的功率
    powerAllocated = initPowerAllo';        
% 根据香农定理得到的信道容量
    shanonCapacity = bandwidth/nSubChannel * ...    
        sum(log2(1 + initPowerAllo.*carrierToNoiseRatio));

% <图形观察>
%通过观察图，很清楚的看到功率像水一样注入由噪声载波比或着信道状态信息所构成的容器中。
f1 = figure(1);
    clf;
    set(f1,'Color',[1 1 1]);%设置图形背景颜色
    bar((initPowerAllo + 1./carrierToNoiseRatio),1,'r')%功率分配与噪声载波比的关系
    hold on;%启动图形保持功能    
    bar(1./carrierToNoiseRatio,1);%1表示圆柱宽度
    xlabel('子信道划分');
    title('注水算法')
    
    legend('分配给每个子信道的功率',...
           '噪声与载波比')
    
    