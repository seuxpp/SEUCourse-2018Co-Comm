clc;clear all;
load('data\Test_WinGS_4x4.mat');
rA = RVD(A);
rb = RVD(b);
x1gs = Method_GS(A,b,1,0);
x2gs = Method_GS(A,b,2,0);

Aquan = floor(A.*2^12);
bquan = floor(b.*2^12);
x1gsquan = floor(x1gs.*2^12);
x2gsquan = floor(x2gs.*2^12)


