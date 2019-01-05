function power_r=power_receive(fc,pt,d)

   den= (4*pi) * (d*1e3)^2;
       power_r=pt*(fc^2/den);
end