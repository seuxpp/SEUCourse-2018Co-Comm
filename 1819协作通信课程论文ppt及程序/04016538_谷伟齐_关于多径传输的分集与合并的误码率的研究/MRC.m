clear all
L_frame=1000; N_packet=5000;
SNR_dBs=[0:30];
b=2;
for iter=1:4 %选择几分集
    if iter==1
        NT=1; NR=1; gs='--'; % 11
    elseif iter==2
        NT=1; NR=2; gs='-^'; % 12
    elseif iter==3
        NT=1; NR=4; gs='-o'; % 14
    elseif iter==4
        NT=1; NR=6; gs='-*'; % 16
    elseif iter==5
        NT=1; NR=8; gs='-.'; % 18
    else
        NT=1; NR=10; gs='-^'; % 110
    end
sq_NT=sqrt(NT);
for i_SNR=1:length(SNR_dBs)
    SNR_dB=SNR_dBs(i_SNR);
    sigma=sqrt(0.5/(10^(SNR_dB/10)));%瑞利分布参数，噪声标准差
    for i_packet=1:N_packet
        symbol_data=randi([0 1],L_frame*b,NT); %产生L_frame*2行NT列二进制信息
        [temp,sym_tab,P]=modulator(symbol_data.',b);
        X=temp.'; % frlg=length(X);
        Hr = (randn(L_frame,NR)+1i*randn(L_frame,NR))/sqrt(2);
        H = reshape(Hr,L_frame,NR);
        Habs = sum(abs(H).^2,2);
        Z=0;
        for i=1:NR
            R(:,i) = sum(H(:,i).*X,2)+sigma*(randn(L_frame,1)+j*randn(L_frame,1));%经过信道并加复高斯白噪声
            Z = Z + R(:,i).*conj(H(:,i));%MRC合并，合并系数为conj(H(:,i))
        end
    for m=1:4 %最大似然译码
        d1(:,m)=abs(sum(Z,2)-sym_tab(m)).^2+(-1+sum(Habs,2))*abs(sym_tab(m))^2;
    end
    [y1,i1] = min(d1,[],2);
    Xd=sym_tab(i1).';
    temp1 = X>0; temp2 = Xd>0;
    noeb_p(i_packet)=sum(sum(temp1~=temp2)); %累加错误比特
end
BER(iter,i_SNR) = sum(noeb_p)/(N_packet*L_frame*2); %计算误比特率
end% end of FOR loop for SNR
semilogy(SNR_dBs,BER(iter,:),gs), hold on, axis([SNR_dBs([1 end]) 1e-6 1e0])
end
title('BER perfoemancde of MRC'), xlabel('SNR / dB'), ylabel('BER')
grid on, set(gca,'fontsize',9)
legend('SISO(NT=1,NR=1)','MRC(NT=1,NR=2)','MRC(NT=1,NR=4)','SC(NT=1,NR=6)','SC(NT=1,NR=8)','SC(NT=1,NR=10)')
