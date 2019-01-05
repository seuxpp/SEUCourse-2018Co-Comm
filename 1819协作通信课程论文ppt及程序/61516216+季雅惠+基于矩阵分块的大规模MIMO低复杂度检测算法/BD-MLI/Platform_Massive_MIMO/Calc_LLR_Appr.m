% Simplified soft-output calculation of the MMSE detector
% [Parameters]
% L - LLRs, vector
% rho - SINR, vector
% z - complex symbols, vector
% mQAM - size of the gray-labelled QAM constellation
% [References] 
% Collings, I. B., M. R. G. Butler, and M. McKay. ¡°Low Complexity Receiver Design for MIMO Bit-Interleaved Coded Modulation.¡± In 2004 IEEE Eighth International Symposium on Spread Spectrum Techniques and Applications, 12¨C16, 2004. doi:10.1109/ISSSTA.2004.1371654.
% [Changes]
% 2016/3/25 - Created by Zhizhen Wu
% 2017/2/19 - Added parameter 'scaling' by Zhizhen Wu
function L = Calc_LLR_Appr(rho, z, mQAM, scaling)
k = length(z);
if scaling==1
    d=sqrt(2*(mQAM-1)/3);%to normalize the energy of the QAM symbol 
else
    d=1;
end
z = d*z;
realz = real(z);
imagz = imag(z);
if mQAM == 16
    t = 4;
    L = zeros(t, k);
    lambda = zeros(t, k);
    for iz = 1:k
        % 1st bit of each symbol
        if abs(realz(iz)) < 2
            lambda(1, iz) = 4*realz(iz);
        else
            lambda(1, iz) = 8*realz(iz)-8*sign(realz(iz));
        end
        % 2nd bit of each symbol
        lambda(2, iz) = 8-4*abs(realz(iz));
        % 3rd bit of each symbol
        if abs(imagz(iz)) < 2
            lambda(3, iz) = 4*imagz(iz);
        else
            lambda(3, iz) = 8*imagz(iz)-8*sign(imagz(iz));
        end
        % 4th bit of each symbol
        lambda(4, iz) = 8-4*abs(imagz(iz));
    end
elseif mQAM == 64
    t = 6;
    L = zeros(t, k);
    lambda = zeros(t, k);
    for iz = 1:k
        % 1st bit of each symbol
        if abs(realz(iz)) < 2
            lambda(1, iz) = 4*realz(iz);
        elseif (abs(realz(iz))>=2) && (abs(realz(iz))<4)
            lambda(1, iz) = 8*realz(iz)-8*sign(realz(iz));
        elseif (abs(realz(iz))>=4) && (abs(realz(iz))<6)
            lambda(1, iz) = 12*realz(iz)-24*sign(realz(iz));
        else
            lambda(1, iz) = 16*realz(iz)-48*sign(realz(iz));           
        end
        % 2nd bit of each symbol
        if abs(realz(iz)) < 2
            lambda(2, iz) = 24-8*abs(realz(iz));
        elseif (abs(realz(iz))>=2) && (abs(realz(iz))<6)
            lambda(2, iz) = 16-4*abs(realz(iz));
        else
            lambda(2, iz) = 40-8*abs(realz(iz));   
        end
        % 3rd bit of each symbol
        if abs(realz(iz)) < 4
            lambda(3, iz) = 4*abs(realz(iz))-8;
        else
            lambda(3, iz) = 24-4*abs(realz(iz));   
        end
        
        % 4st bit of each symbol
        if abs(imagz(iz)) < 2
            lambda(4, iz) = 4*imagz(iz);
        elseif (abs(imagz(iz))>=2) && (abs(imagz(iz))<4)
            lambda(4, iz) = 8*imagz(iz)-8*sign(imagz(iz));
        elseif (abs(imagz(iz))>=4) && (abs(imagz(iz))<6)
            lambda(4, iz) = 12*imagz(iz)-24*sign(imagz(iz));
        else
            lambda(4, iz) = 16*imagz(iz)-48*sign(imagz(iz));           
        end
        % 5nd bit of each symbol
        if abs(imagz(iz)) < 2
            lambda(5, iz) = 24-8*abs(imagz(iz));
        elseif (abs(imagz(iz))>=2) && (abs(imagz(iz))<6)
            lambda(5, iz) = 16-4*abs(imagz(iz));
        else
            lambda(5, iz) = 40-8*abs(imagz(iz));   
        end
        % 6rd bit of each symbol
        if abs(imagz(iz)) < 4
            lambda(6, iz) = 4*abs(imagz(iz))-8;
        else
            lambda(6, iz) = 24-4*abs(imagz(iz));   
        end

    end
else
    return;
end
for n = 1:k
    L(:, n) = rho(n)*lambda(:, n);
end
        
        