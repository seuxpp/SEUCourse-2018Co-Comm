x=[1 2 4 8];
SC=[0.05399 0.02484 0.009563 0.003304];
EGC=[0.05383 0.01961 0.002994 0.000101];
MRC=[0.05431 0.01644 0.001863 3.30E-05];
semilogy(x,SC,'-',x,EGC,'--',x,MRC,'-o');
axis([1 8 1e-6 1e0]);
xlabel('NR');
ylabel('BER');
title('BER perfoemancde,SNR = 5dB');
grid;
legend('SC','EGC','MRC');

