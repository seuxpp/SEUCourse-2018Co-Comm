% AFЭ��
% H_sr����˥������
% pow_SԴ�źŹ��ʣ�pow_n��������
function [beta,signal_AF] = tran_AF(H_sr,POW_S,POW_N,signal_sr)
beta = sqrt( POW_S)/POW_S*((abs(H_sr))^2 + POW_N ); % �Ŵ�ϵ��beta ��֤�м̽ڵ㹦������
signal_AF = beta * signal_sr;	% �м̷Ŵ����ź�
end