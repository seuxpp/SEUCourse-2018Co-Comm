x=[250 260 270 280 290 300 310 320]';
y=[200 190 176 150 139 125 110 100]';
r=[ones(8,1),x];
ab=lsqlin(r,y)
x0=250:0.1:320;
y0=ab(1)+ab(2)*x0;
title('水泥预期销售量与售价的关系')
xlabel('单价（元/吨）')
ylabel('售量（万吨）')
hold on
plot(x,y,'o',x0,y0,'r')

figure(2)
format long
z=[0 60 120 180 240 300 360 420]';
k=[1 1.4 1.7 1.85 1.95 2 1.95 1.8]';
r=[ones(8,1),z,z.^2];
def=lsqlin(r,k)
z0=0:0.1:420;
k0=def(1)+def(2)*z0+def(3)*z0.^2;
title('售量提高因子k与广告费的关系')
xlabel('广告费（万元）')
ylabel('提高因子k')
hold on
plot(z,k,'o',z0,k0,'r')