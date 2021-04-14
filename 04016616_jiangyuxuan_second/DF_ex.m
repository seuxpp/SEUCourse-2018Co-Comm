%��Ե��м�DFЭ��ͨ��ϵͳ��������ͬ���ʷ���ʱ��ϵͳ���������ܵ�Ӱ��
clear all;%%��������еı���������ȫ�ֱ���global
datestr(now)%����ָ����ʽ�����ں�ʱ�䣬now����ǰ����
n=1;
for i=0.1:0.2:0.9
[SNR_dB,ber_DF,theo_ber_DF]=main_DF(i);
a(n,:)=SNR_dB;
b(n,:)=ber_DF;
c(n,:)=theo_ber_DF;
n=n+1;
end

figure(1)  % the actual BER of DF 
semilogy(a(1,:),b(1,:),a(2,:),b(2,:),a(3,:),b(3,:),a(4,:),b(4,:),a(5,:),b(5,:));%semilogx�ð���������ͼ,x����log10��y�����Եģ�semilogy�ð���������ͼ,y����log10��x�����Ե�
legend('POW-DIV=0.1:0.9','POW-DIV=0.3:0.7','POW-DIV=0.5:0.5','POW-DIV=0.7:0.3','POW-DIV=0.9:0.1');              
grid on; %��������
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the actual BER of DF');
axis([0,12,10^(-5),1]);

figure(2)  % the theoretical BER of DF 
semilogy(a(1,:),c(1,:),a(2,:),c(2,:),a(3,:),c(3,:),a(4,:),c(4,:),a(5,:),c(5,:));
legend('POW-DIV=0.1:0.9','POW-DIV=0.3:0.7','POW-DIV=0.5:0.5','POW-DIV=0.7:0.3','POW-DIV=0.9:0.1');    
grid on;
ylabel('The AVERAGE BER');
xlabel('SNR(dB)');
title('the theoretical BER of DF');
axis([0,12,10^(-5),1]);
