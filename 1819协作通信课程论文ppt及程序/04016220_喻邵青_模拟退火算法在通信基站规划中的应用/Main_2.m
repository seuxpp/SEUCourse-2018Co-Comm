clear ;
clf;
clc;
fc=3e8;         %equal the light speed c
pt=1;      
i=7.5e3:0.1e3:8.5e3;
lost=PathLoss_free(fc,i);
[Asort,index]=sort(abs(lost(:)-100));
y=lost(index(1));
r=(7.5e3+0.1e3*(find(lost==y)-1) );         %find 100db attention r/m
global N;
N=30;      %number of station
l=100;        %size of map /km

dis=zeros(N,N);          %distance of stations
num_thru_zone=zeros(N,N);         %  between any two stations 

rand('state',sum(clock)); 
TEMPX_station=randperm(100); X_station=TEMPX_station(1:30);X_station=X_station(:);
TEMPY_station=randperm(100); Y_station=TEMPY_station(1:30);Y_station=Y_station(:);
temp_f=0; 
e=0.1^8;L=20000;at=0.999;T=1;            % the process of Annealing
for k=1:L
 c1=ceil(30*rand(1));  c2=ceil(100*rand(1));
 X_station(c1)=TEMPX_station(c2); Y_station(c1)=TEMPY_station(c2);  
for i=1:N
   for j=1:N
       dis(i,j)=cal_distance( X_station(i) ,Y_station(i),X_station(j),Y_station(j) );
       tmp3=0;  
       for p=1:N
           if (i==j)
               continue              
           elseif (p==i || p==j)
                continue
            else
              tmp3= tmp3+cal_thru_zone( X_station(i) ,Y_station(i),X_station(j),Y_station(j), X_station(p) ,Y_station(p) );
            end
            num_thru_zone(i,j)=tmp3;
       end     
   end   
end   
%% 
num_cov=0;
for n1=1:10000
    x1=randi(1e5) ;y1=randi(1e5);
for i=1:N  
        dd=cal_distance(x1,y1,X_station(i)*1e3,Y_station(i)*1e3);
        if(dd<r)
            num_cov=num_cov+1; break;
        else
            continue
        end
end
end
 F1=num_cov/10000;
 %% 
 deta= zeros(1,N);
 tmp1=0;
 for i=1:N
     tmp=0;
     for j=1:N
         if (i==j || num_thru_zone(i,j)==0 )
           continue
          else
               tmp=tmp + power_receive(fc,pt,dis(i,j)) / num_thru_zone(i,j) ;
         end   
     end
     deta(i)=tmp;
     tmp1=tmp1+deta(i);
 end
      F2=1/tmp1;         
      f=0.9*F1+0.1*F2*1e9;       %目标函数,适应度函数
      %%
      df=f-temp_f;
      if(df>0)     %accept the result
          temp_f=f;  T=T*at; 
          X_opt_station=X_station;
          Y_opt_station=Y_station;
      elseif exp(df/T) <=rand(1)
          temp_f=f; T=T*at; 
          X_opt_station=X_station;
          Y_opt_station=Y_station;
      end
      if T<e
          break;
      end       
end   
f=temp_f;
f
%%
figure(1);
plot(X_opt_station,Y_opt_station,'*r');
hold on;
title('模拟退火下的基站位置分配方案');
xlabel('/Km');ylabel('/Km');
axis([0 l 0 l]);
grid on;
alpha=0:pi/20:2*pi;%角度[0,2*pi]
R=8;%半径
for i=1:30
x=R*cos(alpha)+X_station(i);
y=R*sin(alpha)+Y_station(i);
plot(x,y);
hold on;
end