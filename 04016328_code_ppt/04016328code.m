%非频率选择性慢衰落信道
test1 = randn(1000,1);
delay=[0 1e-5 ];     %各径时延
Ts=1e-5;
db=[0 -30];          %各径衰减
fd=1;                %多普勒频移小
RLchannel=rayleighchan(Ts,fd,delay,db);
RLchannel.StorePathGains=1;
RLchannel.StoreHistory=1;
r=filter(RLchannel,test1);
plot(RLchannel);

%非频率选择性快衰落信道
test1 = randn(1000,1);
delay=[0 1e-5 ];     %各径时延
Ts=1e-5;
db=[0 -30];          %各径衰减
fd=200;                %多普勒频移大
RLchannel=rayleighchan(Ts,fd,delay,db);
RLchannel.StorePathGains=1;
RLchannel.StoreHistory=1;
r=filter(RLchannel,test1);
plot(RLchannel);

%频率选择性慢衰落信道
test1 = randn(1000,1);
delay=[0 1e-5 2e-5];     %各径时延
Ts=1e-5;
db=[0 -5 -10];          %各径衰减
fd=1;                %多普勒频移小
RLchannel=rayleighchan(Ts,fd,delay,db);
RLchannel.StorePathGains=1;
RLchannel.StoreHistory=1;
r=filter(RLchannel,test1);
plot(RLchannel);

%频率选择性快衰落信道
test1 = randn(1000,1);
delay=[0 1e-5 2e-5];     %各径时延
Ts=1e-5;
db=[0 -5 -10];          %各径衰减
fd=200;                %多普勒频移大
RLchannel=rayleighchan(Ts,fd,delay,db);
RLchannel.StorePathGains=1;
RLchannel.StoreHistory=1;
r=filter(RLchannel,test1);
plot(RLchannel);