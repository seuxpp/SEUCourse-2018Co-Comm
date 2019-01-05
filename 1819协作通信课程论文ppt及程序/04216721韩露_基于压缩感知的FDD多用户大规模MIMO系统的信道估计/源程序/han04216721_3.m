wr=2*10000*tan(2*pi*2000/(2*10000));
wt=2*10000*tan(2*pi*1200/(2*10000));
%J-OMP
[N1, wn1]=buttord(wt,wr,0.5,40,'s')
[B1, A1]=butter(N1,wn1,'low','s');
[num1, den1]=bilinear(B1,A1,10000);
[h1, w]=freqz(num1,den1);
%M-OMP
[N2, wn2]=cheb1ord(wt,wr,0.5,40,'s')
[B2, A2]=cheby1(N2,0.5,wn2,'low','s');
[num2 ,den2]=bilinear(B2,A2,10000);
[h2, w]=freqz(num2,den2);
%Genie-aided LS
[N3, wn3]=ellipord(wt,wr,0.5,40,'s')
[B3 ,A3]=ellip(N3,0.5,40,wn3,'low','s');
[num3 ,den3]=bilinear(B3,A3,10000);
[h3 ,w]=freqz(num3,den3);
f=w/(2*pi)*10000;
plot(f,20*log10(abs(h1)),f,20*log10(abs(h2)),f,20*log10(abs(h3)));
axis([0 4000 -100 10]);grid;
xlabel('K');ylabel('NMSE');
title('不同算法下NMSE随用户数变化性能比较');