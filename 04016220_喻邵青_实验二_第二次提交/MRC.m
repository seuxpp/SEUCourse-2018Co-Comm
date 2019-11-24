function sig_all = MRC(beta,H_sd,CH_sr,H_rd,POW_S_sd,POW_N_sd,POW_S_rd,POW_N_rd,signal_sd,signal_rd)   
  a1 = H_sd'* sqrt(POW_S_sd) / POW_N_sd;  %Ŀ�Ľڵ�����Դ�ļ�Ȩϵ��
  a2 = (beta * sqrt(POW_S_rd) * CH_sr' * H_rd') / ( (beta^2*(abs(H_rd))^2+1) * POW_N_rd );   %�����м��źŵļ�Ȩϵ��
  sig_all = a1*signal_sd + a2*signal_rd;
end