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
figure(1);plot(d,y), xlabel('���ջ��뷢�����ľ���d'), ylabel('·����ģ�dB��'), title('���չ���������Ĺ�ϵ');

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
figure(2);plot(ht,y), xlabel('�������߸߶�'), ylabel('·����ģ�dB��'), title('���չ����뷢�����߸߶ȵĹ�ϵ');

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
figure(3);plot(hr,y), xlabel('�������߸߶�'), ylabel('·����ģ�dB��'), title('���չ�������ջ����߸߶ȵĹ�ϵ');

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
figure(4);plot(gt,y), xlabel('���������������'), ylabel('·����ģ�dB��'), title('���չ����뷢�����������Ĺ�ϵ');

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
figure(5);plot(gr,y), xlabel('���ջ�����������'), ylabel('·����ģ�dB��'), title('���չ�������ջ���������Ĺ�ϵ');


