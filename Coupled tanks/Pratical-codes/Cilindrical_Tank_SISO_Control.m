%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank Control                            %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global SerPIC

varlist = {'u','y', 'Tempo'};
clear(varlist{:})
clf(figure(1))

format shortg;
data_horario_test = datestr(clock,'yyyy-mm-dd THH-MM-SS');
folderName = 'siso_control_cilindrical_tank';

Ts = 1;  %Determinação do período de amostragem

freq = 3000; %Frequencia de atuação da bomba

Qde_amostras =800; %Quantidade de amostras do gráfico
npts = Qde_amostras;

%Flags

PIDflag = 0;
h_flag = 0;


PIDtype = 'ZN'; %'ZN' = Ziegle-Nichols , 'CC' = Choen Coon,'AT' = Astrom, 'PR' = Teacher tunning;

FuzzyType = 'T2';% 'T1' = Tipo 1, 'T2' = Tipo 2;
FT1type = 'L'; % L = input linear ; N = input non linear
FT2Itype = 'L'; % L = input linear ; N = input non linear

%% 
        patamar = 1;
        passo = 0.20;
        ref = ref_def(patamar,passo,npts) % Gerar degraus;   

%% PID definition: 

[Kc,Ti,Td] = PID(PIDtype); % Type PID selection

%%
if (PIDflag)
    subfolderName = ['PID -',PIDtype,'-',data_horario_test];
else  
    if (FuzzyType == 'T1'),
        
        Am_min = 2; 
        Am_max = 5;
        Theta_m_min = 45;
        Theta_m_max = 72;
        L = 2;
        
        % o vetor parametros dá os valores das MF's:
        if (FT1type == 'L')
            param = load('T1_L.dat')
            subfolderName = ['FUZZY -', FuzzyType,'-',FT1type,'-',PIDtype,'-',data_horario_test];
            
        elseif (FT1type == 'N')
            param = load('T1_N.dat')
            subfolderName = ['FUZZY -', FuzzyType,'-',FT1type,'-',PIDtype,'-',data_horario_test];
            
        end;
        
        
    end
    
    if (FuzzyType == 'T2'),
        
        Am_min = 2;
        Am_max = 5;
        Theta_m_min = 45;
        Theta_m_max = 72;
        L = 2;
        
        % o vetor parametros dá os valores das MF's:        
        if (FT2Itype == 'L')
            param = load('T2_L.dat')
            param =[param,1,1];
            subfolderName = [PIDtype, '-', FuzzyType,'-',FT2Itype,'-',PIDtype,'-',data_horario_test];
            
        elseif (FT2Itype == 'N')   
            param = load('T2_N.dat')
            subfolderName = [PIDtype, '-', FuzzyType,'-',FT2Itype,'-',PIDtype,'-',data_horario_test];

        end;
        
    end

    end
%%
%Previnir erro de leitura
recebe(1)
recebe(2)
recebe(3)

%zerar PWM
set_pwm_duty(1,1,freq);

%%


  h = figure(1);  
  hLine1 = line(nan, nan, 'Color','red');
  title('Resposta ao Degrau Tanque ');
  xlabel('Tempo (s)');
        if (h_flag == 1)
           ylabel('Altura da Coluna de agua'); 
        else
           ylabel('Leitura do Sensor');  
        end
  
%% 
     for k=5:nptos
       
        if (h_flag == 1)
           y(k) = mapfun(recebe(2),0.19,2.389,0,60); %Recebe o valor medido da altura e armazena 
        else
           y(k) = recebe(2); %Recebe o valor medido de armazena  
        end
        
        erro(k)= ref(k) - y(k);
        rate(k)=(erro(k) - erro(k-1));%/Tc; %Rate of erro
        
        
         if (PIDflag)
                Ami = 1;
            else
                if (FuzzyType == 'T1'),
                    
                    Am(k) = FT1_pid_ag(erro(k),rate(k),L,param,FT1type);
                    Ami = Am(k)*Am_max + Am_min*(1 - Am(k));
                end
                
                if (FuzzyType == 'T2'),
                    
                    Am(k) =Inferencia_T2(erro(k),rate(k),L,param,FT2Itype);
                    Ami = Am(k)*Am_max + Am_min*(1 - Am(k));
                    
                end
                
         end
         
                        %Controlador:

                        Kp(k)= Kc/Ami;
                        Kd(k)= (Td)*Kc/Ami;
                        Ki(k)= (Kc/Ami)/(Ti);

                        alpha = (Kc/Ami)*(1+((Td)/Tamostra)+(Tamostra/(2*(Ti))));
                        beta = -(Kc/Ami)*(1+2*((Td)/Tamostra)-(Tamostra/(2*(Ti))));
                        gama = (Kc/Ami)*(Td)/Tamostra;

                        if (flag_load_dist) 
                            u(k)= u(k-1) + alpha*erro(k) + beta*erro(k-1) + gama*erro(k-2) + disturbio(k);
                        else
                            u(k)= u(k-1) + alpha*erro(k) + beta*erro(k-1) + gama*erro(k-2);
                        end;
        

      %saturation:
          if(u(k)<0.05) u(k)=0.05;end;
          if(u(k)>0.5) u(k)=0.5;end;
      
      
      set_pwm_duty(1,u(k),freq);
      x1 = get(hLine1, 'XData');  
      y1 = get(hLine1, 'YData');  
      x1 = [x1 k*Ts];  
      y1 = [y1 y(k)];  
      set(hLine1, 'XData', x1, 'YData', y1);  
      %k=k+1;
      Tempo(k) = k*Ts;
      pause(Ts);
     end
  
 %zerar bomba
 set_pwm_duty(1,1,freq); 
 
%Plotar sinal de controle 
hold on
plot(Tempo,u,'b');
hold off; 

% Salvar dados:
trail = ['./results/',folderName,'/',subfolderName];
if (~exist(trail)) mkdir(trail);end   
save([trail, '/y.dat'],'y', '-ascii')
save ([trail, '/u.dat'], 'u', '-ascii')
save([trail, '/Tempo.dat'],'y', '-ascii')
save ([trail, '/ref.dat'], 'u', '-ascii')
save([trail, '/erro.dat'],'y', '-ascii')
save ([trail, '/rate.dat'], 'u', '-ascii')


