close all;
clear all;
rand('state',sum(100*clock));%Initialize RAND
randn('state',sum(100*clock));%Initialize RANDN
 
QPSK_C=[1+j,-1+j,-1-j,1-j]; %Signal set
QPSK_B=[0 0; 0 1;1 1;1 0]; %Binary mapping
 
SizeOfSignalSet=size(QPSK_B,1);%The size of the signal set
BitsPerSymbol=size(QPSK_B,2); %number of bits carried by one symbol
Es=sum(QPSK_C.*conj(QPSK_C))/length(QPSK_C); %Average symbol energy
 
Eb=Es/BitsPerSymbol; %bit energy
 
% TX2, RX1, directly diversity
recIndex=1;
for EbN0=0:2:44
    N0=Eb*10^(-EbN0/10); %get the noise power
    testCount=0;
    errCount=0;
    while(1)
        h0=(randn(1)+j*randn(1))/sqrt(2);%Generate the channel (Complex gaussian, Rayleigh apmlitude)
 
        h1=(randn(1)+j*randn(1))/sqrt(2);%Generate the channel (Complex gaussian, Rayleigh apmlitude)
        
        %Randomly generate a source symbol
        SrcIndex=floor(rand(1)*SizeOfSignalSet)+1;
        x=QPSK_C(SrcIndex); %get the signal symbol
        a=x/sqrt(2);
        b=x/sqrt(2);
        
        %Generate the noise
        n=(randn(1)+j*randn(1))/sqrt(2);
        n=n*sqrt(N0); %control the noise power, N0
 
        %The channel with noise
        r=h0*a+h1*b+n;
        
 
        %Detect the signal
        h=h0+h1;
        y=sqrt(2)*r/h;
 
        %Decision
        Error=(y-QPSK_C);
        Dist=Error.*conj(Error);
        [minVlaue DecIndex]=min(Dist);
 
        if(DecIndex ~= SrcIndex)
            errBinary=mod(QPSK_B(SrcIndex,:)+QPSK_B(DecIndex,:),2);
            errCount=errCount+sum(errBinary);
        end
        testCount=testCount+1;
        testLength=testCount*BitsPerSymbol;%Get the binary length
 
        %stop control
        if(testLength<100000) %test length lower bound 
            continue;
        end
        BER=errCount/testLength;
        if(BER<1e-10)
            continue;
        end
 
        testLevel=200.0/BER; %confidence level
        if(testLength>testLevel)
            break;
        end
    end
    BER_rec1(recIndex)=BER;%record the test result
    EbN0_rec1(recIndex)=EbN0;
    recIndex=recIndex+1;
    
    %Display the results
    BER_rec1
    EbN0_rec1
end
 
semilogy(EbN0_rec1,BER_rec1,'+-');
hold on
 
 
%Alamouti
% A Simple Transmit Diversity Technique for Wireless Communications, IEEE 
%IEEE JOURNAL ON SELECT AREAS IN COMMUNICATIONS, VOL. 16, NO. 8, OCTOBER 1998
 
% TX2, RX1, directly diversity
 
%Totally transmit 4 channel symbols for 2 source symbols
Eb=(4.0*Es)/(2*BitsPerSymbol);
recIndex=1;
for EbN0=0:2:26
    N0=Eb*10^(-EbN0/10); %get the noise power
    testCount=0;
    errCount=0;
    while(1)
        h0=(randn(1)+j*randn(1))/sqrt(2);%Generate the channel (Complex gaussian, Rayleigh apmlitude)
 
        h1=(randn(1)+j*randn(1))/sqrt(2);%Generate the channel (Complex gaussian, Rayleigh apmlitude)
        
        %Randomly generate two source symbols, S0 and S1
        SrcIndex0=floor(rand(1)*SizeOfSignalSet)+1;
        S0=QPSK_C(SrcIndex0); %get the signal symbol
        SrcIndex1=floor(rand(1)*SizeOfSignalSet)+1;
        S1=QPSK_C(SrcIndex1); %get the signal symbol
        
        
        %Generate the noise
        n0=(randn(1)+j*randn(1))/sqrt(2);
        n0=n0*sqrt(N0); %control the noise power, N0
        
        n1=(randn(1)+j*randn(1))/sqrt(2);
        n1=n1*sqrt(N0); %control the noise power, N0
 
        %The channel with noise
        r0=h0*S0+h1*S1+n0;
        r1=-h0*conj(S1)+h1*conj(S0)+n1;
        
 
        %Detect the signal
        Amp=real(h0*conj(h0)+h1*conj(h1));
        S0_wave=conj(h0)*r0+h1*conj(r1);
        S1_wave=conj(h1)*r0-h0*conj(r1);
        S0_wave=S0_wave/Amp;
        S1_wave=S1_wave/Amp;
        
        %Decision
        Error0=(S0_wave-QPSK_C);
        Dist0=Error0.*conj(Error0);
        [minVlaue0 DecIndex0]=min(Dist0);
        
        Error1=(S1_wave-QPSK_C);
        Dist1=Error1.*conj(Error1);
        [minVlaue1 DecIndex1]=min(Dist1);
 
        if(DecIndex0 ~= SrcIndex0)
            errBinary=mod(QPSK_B(SrcIndex0,:)+QPSK_B(DecIndex0,:),2);
            errCount=errCount+sum(errBinary);
        end
        
        if(DecIndex1 ~= SrcIndex1)
            errBinary=mod(QPSK_B(SrcIndex1,:)+QPSK_B(DecIndex1,:),2);
            errCount=errCount+sum(errBinary);
        end
        
        testCount=testCount+1;
        testLength=testCount*BitsPerSymbol*2;%Get the binary length
 
        %stop control
        if(testLength<100000) %test length lower bound 
            continue;
        end
        BER=errCount/testLength;
        if(BER<1e-10)
            continue;
        end
 
        testLevel=200.0/BER; %confidence level
        if(testLength>testLevel)
            break;
        end
    end
    BER_rec2(recIndex)=BER;%record the test result
    EbN0_rec2(recIndex)=EbN0;
    recIndex=recIndex+1;
    
    %Display the results
    BER_rec2
    EbN0_rec2
end
 
semilogy(EbN0_rec2,BER_rec2,'x-');
 
 
Alamouti Solution 2
A Simple Transmit Diversity Technique for Wireless Communications, IEEE 
IEEE JOURNAL ON SELECT AREAS IN COMMUNICATIONS, VOL. 16, NO. 8, OCTOBER 1998
Set S1=0 when solve S0
And set S0=0 when slove S1
 
Eb=(4.0*Es)/(2*BitsPerSymbol);
recIndex=1;
for EbN0=0:2:26
    N0=Eb*10^(-EbN0/10); %get the noise power
    testCount=0;
    errCount=0;
    while(1)
        h0=(randn(1)+j*randn(1))/sqrt(2);%Generate the channel (Complex gaussian, Rayleigh apmlitude)
 
        h1=(randn(1)+j*randn(1))/sqrt(2);%Generate the channel (Complex gaussian, Rayleigh apmlitude)
        
        %Randomly generate two source symbols, S0 and S1
        SrcIndex0=floor(rand(1)*SizeOfSignalSet)+1;
        S0=QPSK_C(SrcIndex0); %get the signal symbol
        SrcIndex1=floor(rand(1)*SizeOfSignalSet)+1;
        S1=QPSK_C(SrcIndex1); %get the signal symbol
        
        
        %Generate the noise
        n0=(randn(1)+j*randn(1))/sqrt(2);
        n0=n0*sqrt(N0); %control the noise power, N0
        
        n1=(randn(1)+j*randn(1))/sqrt(2);
        n1=n1*sqrt(N0); %control the noise power, N0
 
        %The channel with noise
        r0=h0*S0+h1*S1+n0;
        r1=-h0*conj(S1)+h1*conj(S0)+n1;
        
 
        %Detect signals and decision
        tempA=r0-h0*QPSK_C;
        tempB=r1-h1*conj(QPSK_C);
        Dist0=tempA.*conj(tempA)+tempB.*conj(tempB);
        [minVlaue0 DecIndex0]=min(Dist0);
        
        tempA=r0-h1*QPSK_C;
        tempB=r1+h0*conj(QPSK_C);
        Dist1=tempA.*conj(tempA)+tempB.*conj(tempB);
        [minVlaue1 DecIndex1]=min(Dist1);
        
        if(DecIndex0 ~= SrcIndex0)
            errBinary=mod(QPSK_B(SrcIndex0,:)+QPSK_B(DecIndex0,:),2);
            errCount=errCount+sum(errBinary);
        end
        
        if(DecIndex1 ~= SrcIndex1)
            errBinary=mod(QPSK_B(SrcIndex1,:)+QPSK_B(DecIndex1,:),2);
            errCount=errCount+sum(errBinary);
        end
        
        testCount=testCount+1;
        testLength=testCount*BitsPerSymbol*2;%Get the binary length
 
        %stop control
        if(testLength<100000) %test length lower bound 
            continue;
        end
        BER=errCount/testLength;
        if(BER<1e-10)
            continue;
        end
 
        testLevel=200.0/BER; %confidence level
        if(testLength>testLevel)
            break;
        end
    end
    BER_rec3(recIndex)=BER;%record the test result
    EbN0_rec3(recIndex)=EbN0;
    recIndex=recIndex+1;
    
    %Display the results
    BER_rec3
    EbN0_rec3
end
 
semilogy(EbN0_rec3,BER_rec3,'r-');
xlabel('Eb/N0 in dB');
ylabel('Bit error rate');
 
legend('Tx 2, Rx 1, direct transmit diversity', 'Alamouti transmit diversity','Alamouti transmit diversity, solution 2');
grid
%%
 
save myResults




 



