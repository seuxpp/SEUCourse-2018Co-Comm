%Yu Shaoqing,Li Chengming,Zhu jiangao
%Southeast University
%2018.10.22
%plot_PathLost_general.m
clear all
clf
clc
fc=3e9;
d0=1000;       %参考距离
sigma=3;              
distance=[1:2:99].^2;
Gt=[2 2 1];
Gr=[2 1 1];
Exp=[2 3 5];                %用于路径损耗指数，三次依次为2 3 5
for k=1:3
    y_Free(k,:)=PathLoss_free(fc,distance,Gt(k),Gr(k));
    y_logdist(k,:)=PathLost_logdist_or_norm(fc,distance,d0,Exp(k));
    y_lognorm(k,:)=PathLost_logdist_or_norm(fc,distance,d0,Exp(1),sigma);
end
%subplot(131)
figure(1)
semilogx(distance,y_Free(1,:),'k-o',distance,y_Free(2,:),'r-^',distance,y_Free(3,:),'b-s')
grid on,axis([1 10000 40 140])
title(['Free PL-loss Model,f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'),ylabel('Path loss[dB]')
legend('G_t=2,G_r=2','G_t=2,G_r=1','G_t=1,G_r=1')
hold on
%subplot(132)
figure(2)
semilogx(distance,y_logdist(1,:),'k-o',distance,y_logdist(2,:),'r-^',distance,y_logdist(3,:),'b-s')
grid on,axis([1 10000 40 140])
title(['Log-distance Path-loss Model,f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'),ylabel('Path loss[dB]')
legend('n=2','n=3','n=5')
hold on
%subplot(133)
figure(3)
semilogx(distance,y_lognorm(1,:),'k-o',distance,y_lognorm(2,:),'r-^',distance,y_lognorm(3,:),'b-s')
grid on,axis([1 10000 40 140])
title(['Log-normal Path-loss Model,f_c=',num2str(fc/1e6),'MHz,','\sigma=',num2str(sigma),'dB'])
xlabel('Distance[m]'),ylabel('Path loss[dB]')
legend('path 1','path 2','path 3')