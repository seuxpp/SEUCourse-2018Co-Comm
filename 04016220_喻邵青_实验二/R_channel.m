%����Ŀ���ǲ���һ�������������Ϊ˥��
%����Ϊ����Ҫ�ķ���
function atten=R_channel(sigma)
   mean=0;          %��ֵΪ0
   sta_deviation=sqrt(sigma);
   atten=normrnd(mean,sta_deviation)+j*normrnd(mean,sta_deviation);        %��ֵΪ0������Ϊsigma����̬�ֲ������

end
