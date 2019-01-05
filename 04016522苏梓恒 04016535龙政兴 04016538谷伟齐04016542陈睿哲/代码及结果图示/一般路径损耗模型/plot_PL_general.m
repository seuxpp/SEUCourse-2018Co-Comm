
clear all
clf
clc
d0=100;
sigma=3;
distance=[1:2:31].^2;
Exp=[2 3 6];
K=2000;
for k=1:3
    y_logdist(k,:)=PL_logdist_or_norm_general(K,distance,d0,Exp(k));
    y_lognorm(k,:)=PL_logdist_or_norm_general(K,distance,d0,Exp(1),sigma);
end
%subplot(132)
figure(1)
semilogx(distance,y_logdist(1,:),'k-o',distance,y_logdist(2,:),'k-^',distance,y_logdist(3,:),'k-s')
grid on,axis([0 1000 0 200])
title(['General Log-distance Path-loss Model,K = 2000'])
xlabel('Distance[m]'),ylabel('Path loss[dB]')
legend('n=2','n=3','n=6')
hold on
%subplot(133)
figure(2)
semilogx(distance,y_lognorm(1,:),'k-o',distance,y_lognorm(2,:),'k-^',distance,y_lognorm(3,:),'k-s')
grid on,axis([0 1000 0 200])
title(['General Log-normal Path-loss Model,K = 2000','\sigma=',num2str(sigma),'dB'])
xlabel('Distance[m]'),ylabel('Path loss[dB]')
legend('path 1','path 2','path 3')