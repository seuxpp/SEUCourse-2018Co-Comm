%Guilu Wu
%National Mobile Communications Research Laboratory * Southeast University
%2018.10.11
%plot_PL_general.m
clear all
clf
clc
fc=9e9;
% ht=50;
% hr=2;
K=0.99;
a=2;
d0=100;
sigma=3;
distance=[1:2:31].^2;
% Gt=[1 1 0.5];
% Gr=[1 0.5 0.5];
Exp=[2 3 6];
for k=1:3
    y_Free(k,:)=PL_common(K,distance,d0,a);
    y_logdist(k,:)=PL_common_logdist_or_norm(K,distance,d0,Exp(k));
    y_lognorm(k,:)=PL_common_logdist_or_norm(K,distance,d0,Exp(1),sigma);
end
%subplot(131)
figure(1)
semilogx(distance,y_Free(1,:),'k-o',distance,y_Free(2,:),'k-^',distance,y_Free(3,:),'k-s')
grid on,
% axis([1 1000 40 110])
title(['Free PL-loss Model,f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'),ylabel('Path loss[dB]')
legend('G_t=1,G_r=1','G_t=1,G_r=0.5','G_t=0.5,G_r=0.5')
hold on
%subplot(132)
figure(2)
semilogx(distance,y_logdist(1,:),'k-o',distance,y_logdist(2,:),'k-^',distance,y_logdist(3,:),'k-s')
grid on,
% axis([1 1000 40 110])
title(['Log-distance Path-loss Model,f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'),ylabel('Path loss[dB]')
legend('n=2','n=3','n=6')
hold on
%subplot(133)
figure(3)
semilogx(distance,y_lognorm(1,:),'k-o',distance,y_lognorm(2,:),'k-^',distance,y_lognorm(3,:),'k-s')
grid on,
% axis([1 1000 40 110])
title(['Log-normal Path-loss Model,f_c=',num2str(fc/1e6),'MHz,','\sigma=',num2str(sigma),'dB'])
xlabel('Distance[m]'),ylabel('Path loss[dB]')
legend('path 1','path 2','path 3')