clear all
clf
clc
d=0:0.1:500;
a0=d.*d
ht=100;
hr=10;
a1=(ht*hr)./a0;
a1=a1.*a1;
gt=1;
gr=1;
a2=gt*gr;
y=10*(log10(a1*a2));
figure(1);plot(d,y), xlabel('接收机与发射机间的距离d'), ylabel('路径损耗（dB）'), title('接收功率与距离间的关系');

clear all
clf
clc
d=1000;
ht=1:0.1:100;
hr=10;
a1=(ht*hr)/(d*d);
a1=a1.*a1;
gt=1;
gr=1;
a2=gt*gr;
y=10*(log10(a1*a2));
figure(2);plot(ht,y), xlabel('发射天线高度'), ylabel('路径损耗（dB）'), title('接收功率与发射天线高度的关系');

clear all
clf
clc
d=1000;
ht=100;
hr=1:0.1:10
a1=(ht*hr)/(d*d);
a1=a1.*a1;
gt=1;
gr=1;
a2=gt*gr;
y=10*(log10(a1*a2));
figure(3);plot(hr,y), xlabel('接收天线高度'), ylabel('路径损耗（dB）'), title('接收功率与接收机天线高度的关系');

clear all
clf
clc
d=1000;
ht=100;
hr=10;
a1=(ht*hr)/(d*d);
a1=a1.*a1;
gt=1:0.1:10;
gr=1;
a2=gt*gr;
y=10*(log10(a1*a2));
figure(4);plot(gt,y), xlabel('发射机机天线增益'), ylabel('路径损耗（dB）'), title('接收功率与发射机天线增益的关系');

clear all
clf
clc
d=1000;
ht=100;
hr=10;
a1=(ht*hr)/(d*d);
a1=a1.*a1;
gr=1:0.1:10;
gt=1;
a2=gt*gr;
y=10*(log10(a1*a2));
figure(5);plot(gr,y), xlabel('接收机机天线增益'), ylabel('路径损耗（dB）'), title('接收功率与接收机天线增益的关系');


