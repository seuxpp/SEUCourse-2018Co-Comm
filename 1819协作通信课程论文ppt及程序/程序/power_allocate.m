function [Ps,Pr]=power_allocate(P,asd,asr,ard,combining_type,al_method,transMode,sd_weight);
%根据接收端不同的接收合并方式进行最优功率分配

%MRC方式
switch transMode
    case 'AAF'
        switch combining_type
           case 'MRC'
              for(i=1:1:size(asd,2))
                 switch al_method
                     case 'Best'
                       if(((asd(i)*ard(i)+asr(i)*ard(i)-asd(i)*asr(i))>0)&&((asr(i)*ard(i)*P-asr(i)*asd(i)*P-asd(i))>0))
                         Ps(i)=(asr(i)*ard(i)*P+asd(i)*ard(i)*P+asd(i))/(asd(i)*ard(i)+asr(i)*ard(i)-asd(i)*asr(i)+sqrt((asd(i)*ard(i)+asr(i)*ard(i)-asd(i)*asr(i))*asr(i)*ard(i)*(asr(i)*P+1)/(ard(i)*P+1)));
                         Pr(i)=(asr(i)*ard(i)*P-asr(i)*asd(i)*P-asd(i))/(asd(i)*ard(i)+asr(i)*ard(i)-asd(i)*asr(i)+sqrt((asd(i)*ard(i)+asr(i)*ard(i)-asd(i)*asr(i))*asr(i)*ard(i)*(ard(i)*P+1)/(asr(i)*P+1)));
                       else
                        Ps(i)=P/2;
                        Pr(i)=P/2;
                       end
                    case 'equal'
                       Ps(i)=P/2;
                       Pr(i)=P/2;
                    case 'onlys'
                       Ps(i)=P;
                       Pr(i)=0;
                    otherwise
                       error('No such power allocate method'); 
                 end
              end
            case 'ERC'
                for(i=1:1:size(asd,2))
                    switch al_method
                        case 'Best'
                            if(((asd(i)-ard(i))*(asd(i)-2*asr(i))>0)&&(2*asr(i)*ard(i)*P-2*asd(i)-2*asd(i)*asr(i)*P-asd(i)*ard(i)*P>0))
                               Ps(i)=(asr(i)*ard(i)*P+asd(i))/(asr(i)*ard(i)-asr(i)*asd(i)+sqrt((asr(i)*P+1)*(asd(i)-ard(i))*(asd(i)-2*asr(i))*asr(i)*ard(i)/(ard(i)*P+2)));
                               Pr(i)=(2*asr(i)*ard(i)*P-2*asd(i)-2*asd(i)*asr(i)*P-asd(i)*ard(i)*P)/(2*asr(i)*ard(i)-2*asr(i)*asd(i)+sqrt((ard(i)*P+2)*(asd(i)-ard(i))*(asd(i)-2*asr(i))*ard(i)*asr(i)/(asr(i)*P+1)));
                            else
                               Ps(i)=P/2;
                               Pr(i)=P/2;
                            end
                        case 'equal'
                            Ps(i)=P/2;
                            Pr(i)=P/2;
                        case 'onlys'
                            Ps(i)=P;
                            Pr(i)=0;
                        otherwise
                            error('No such power allocate method'); 
                    end                           
                end
            case 'FRC'
                for(i=1:1:size(asd,2))
                    switch al_method
                        case 'Best'
                            if(((asd(i)*sd_weight^2-ard(i))*(asd(i)*sd_weight^2-sd_weight^2*asr(i)-asr(i))>0)&&((P*asr(i)*ard(i)-asd(i)*sd_weight^2)*(sd_weight^2+1)-P*sd_weight^2*asd(i)*(asr(i)*sd_weight^2+asr(i)+ard(i))>0))
                               Ps(i)=(asr(i)*ard(i)*P+sd_weight^2*asd(i))/(asr(i)*ard(i)-asr(i)*sd_weight^2*asd(i)+sqrt((asr(i)*P+1)*(asd(i)*sd_weight^2-ard(i))*(sd_weight^2*asd(i)-sd_weight^2*asr(i)-asr(i))*asr(i)*ard(i)/(ard(i)*P+sd_weight^2+1)));
                               Pr(i)=((P*asr(i)*ard(i)-asd(i)*sd_weight^2)*(sd_weight^2+1)-P*sd_weight^2*asd(i)*(asr(i)*sd_weight^2+asr(i)+ard(i)))/((asr(i)*ard(i)-asd(i)*asr(i)*sd_weight^2)*(sd_weight^2+1)+sqrt((asd(i)*asr(i)*sd_weight^2-asr(i)*ard(i))*(ard(i)*P+sd_weight^2+1)*(sd_weight^2*asd(i)-sd_weight^2*asr(i)-asr(i))*ard(i)/(asr(i)*P+1)));
                            else
                               Ps(i)=P/2;
                               Pr(i)=P/2;
                            end
                        case 'equal'
                            Ps(i)=P/2;
                            Pr(i)=P/2;
                        case 'onlys'
                            Ps(i)=P;
                            Pr(i)=0;
                        otherwise
                            error('No such power allocate method'); 
                    end                     
                end
            case 'ESNRC'
                for(i=1:1:size(asd,2))
                    switch al_method
                      case 'Best'
                           if(((asd(i)-ard(i))*(asd(i)-2*asr(i))>0)&&(2*asr(i)*ard(i)*P-2*asd(i)-2*asd(i)*asr(i)*P-asd(i)*ard(i)*P>0))
                               basic_ps(i)=(asr(i)*ard(i)*P+asd(i))/(asr(i)*ard(i)-asr(i)*asd(i)+sqrt((asr(i)*P+1)*(asd(i)-ard(i))*(asd(i)-2*asr(i))*asr(i)*ard(i)/(ard(i)*P+2)));
                               basic_pr(i)=(2*asr(i)*ard(i)*P-2*asd(i)-2*asd(i)*asr(i)*P-asd(i)*ard(i)*P)/(2*asr(i)*ard(i)-2*asr(i)*asd(i)+sqrt((ard(i)*P+2)*(asd(i)-ard(i))*(asd(i)-2*asr(i))*ard(i)*asr(i)/(asr(i)*P+1)));
                               if(0.1<asd(i)*(asr(i)*basic_ps(i)+ard(i)*basic_pr(i)+1)/(basic_pr(i)*asr(i)*ard(i))&&(asd(i)*(asr(i)*basic_ps(i)+ard(i)*basic_pr(i)+1)/(asr(i)*ard(i)*basic_pr(i))<10))
                                   Ps(i)=(asr(i)*ard(i)*P+asd(i))/(asr(i)*ard(i)-asr(i)*asd(i)+sqrt((asr(i)*P+1)*(asd(i)-ard(i))*(asd(i)-2*asr(i))*asr(i)*ard(i)/(ard(i)*P+2)));
                                   Pr(i)=(2*asr(i)*ard(i)*P-2*asd(i)-2*asd(i)*asr(i)*P-asd(i)*ard(i)*P)/(2*asr(i)*ard(i)-2*asr(i)*asd(i)+sqrt((ard(i)*P+2)*(asd(i)-ard(i))*(asd(i)-2*asr(i))*ard(i)*asr(i)/(asr(i)*P+1)));
                               else
                                   Ps(i)=P/2;
                                   Pr(i)=P/2;
                               end
                           else
                               Ps(i)=P/2;
                               Pr(i)=P/2;
                           end  
                        case 'equal'
                           Ps(i)=P/2;
                           Pr(i)=P/2;
                        case 'onlys'
                           Ps(i)=P;
                           Pr(i)=0;
                        otherwise
                            error('No such power allocate method'); 
                    end
                end                        
            otherwise
               error(['Unknown relay-type:',combining_type]);
        end
    case 'DAF'
        for(i=1:1:size(asd,2))
            Ps(i)=P/2;
            Pr(i)=P/2;
        end
    otherwise
        error('No such tran Mode'); 
end
            
            
            
            