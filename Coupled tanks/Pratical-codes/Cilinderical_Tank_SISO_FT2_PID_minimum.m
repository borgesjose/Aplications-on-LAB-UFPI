%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -Jose Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank Control                            %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global SerPIC

varlist = {'u','y', 'Tempo'};
clear(varlist{:})
%clf(figure(1))

format shortg;
data_horario_test = datestr(clock,'yyyy-mm-dd THH-MM-SS');
folderName = 'siso_control_cilindrical_tank';

Ts = 1;  %Determinação do período de amostragem
Tamostra = Ts;

freq = 3000; %Frequencia de atuação da bomba

Qde_amostras = 200; %Quantidade de amostras do gráfico
npts = Qde_amostras;
PIDtype = 'AT'

%Flags

PIDflag = 0;
h_flag = 0;


FuzzyType = 'T2';% 'T1' = Tipo 1, 'T2' = Tipo 2;
FT1type = 'L'; % L = input linear ; N = input non linear
FT2Itype = 'L'; % L = input linear ; N = input non linear

%% 
        patamar = 1.0;
        passo = 0.00;
        ref = ref_def(patamar,passo,npts) % Gerar degraus;   
        y(1)=0 ; y(2)=0 ; y(3)=0; y(4)=0;
        u(1)=0.67 ; u(2)=0.67 ; u(3)=0.67; u(4)=0.67;
        erro(1)=1 ; erro(2)=1 ; erro(3)=1; erro(4)=1;
         Tamostra = Ts;
%% PID definition: 
%             Kc = 0.38768;
%             Ti =  1.5;
%             Td = 0.375;
            
% Kc = 0.49529;
% Ti = 1.5;
% Td = 0.375;


%[Kc,Ti,Td] = PID(PIDtype); % Type PID selection
% load pid.dat
% [Kc,Td ,Ti] = pid

% Kc = 0.015;
% Ti = 0.50;
% Td = 0.15;

%  Kc = 0.19736;
%  Ti = 6.5396;
%  Td = 6.5396;

% MELHOR
 Kc = 0.488;
 Ti = 27.968;
 Td = 0.51381;
 
%  Kc = 0.3;
%  Ti = 27.968;
%  Td = 0.51381;


Am_min = .1;        
Am_max = 5;
Theta_m_min = 45;
Theta_m_max = 72;
L = 2;

H1 = 0.1;
H2 = 0.1;
H3 = 0.9;
H4 = 0.9;
H = [H1,H1,H3,H4];
        Param = [2.0653,-0.0214,-0.0593,9.2812,0.1300,0.3850,1.7406,-0.0045];
        Param =[Param,1,1];
%%
%Previnir erro de leitura
recebe(1)
recebe(2)
recebe(3)

%zerar PWM
set_pwm_duty(1,.43,freq);
pause(5);
%%


  h = figure(1);  
  hLine1 = line(nan, nan, 'Color','red');
  %hLine1 = line(nan, nan);
  title('Resposta ao Degrau Tanque ');
  xlabel('Tempo (s)');
        if (h_flag == 1)
           ylabel('Altura da Coluna de agua'); 
        else
           ylabel('Leitura do Sensor');  
        end
  
%% 
     for k=5:npts
       
        if (h_flag == 1)
           y(k) = mapfun(recebe(2),0.19,2.389,0,60); %Recebe o valor medido da altura e armazena 
        else
           for ii=1:10
           mm(ii) = recebe(2); %Recebe o valor medido de armazena
           pause(.05)
           end
           y(k) = mean(mm)  
        end
        
        erro(k)= ref(k) - y(k);
        rate(k)=(erro(k) - erro(k-1));%/Tc; %Rate of erro
        
        

         Am(k) = inferencia_T2_minimum_2(erro(k),rate(k),L,Param,H);
         Ami = Am(k)*Am_max + Am_min*(1 - Am(k)); 
                        %Controlador:

                        Kp(k)= Kc/Ami;
                        Kd(k)= (Td)*Kc/Ami;
                        Ki(k)= (Kc/Ami)/(Ti);

                        alpha = (Kc/Ami)*(1+((Td)/Tamostra)+(Tamostra/(2*(Ti))));
                        beta = -(Kc/Ami)*(1+2*((Td)/Tamostra)-(Tamostra/(2*(Ti))));
                        gama = (Kc/Ami)*(Td)/Tamostra;


                       u(k)= u(k-1) + alpha*erro(k) + beta*erro(k-1) + gama*erro(k-2);
                    
        

      %saturation:
          if(u(k)<0) u(k)=0;end;
          if(u(k)>1) u(k)=1;end;
      
      
      set_pwm_duty(1,1-u(k),freq);
      x1 = get(hLine1, 'XData');  
      y1 = get(hLine1, 'YData');  
      x1 = [x1 k*Ts];  
      y1 = [y1 y(k)];  
      set(hLine1, 'XData', x1, 'YData', y1);  
      %k=k+1;
      Tempo(k) = k*Ts;
      pause(Ts);
     end
  
 %zerar bombau
 set_pwm_duty(1,1,freq); 
 
%Plotar sinal de controle 
hold on
plot(Tempo,u,'b');
plot(Tempo,u);
plot(Tempo,ref,'g');
hold off; 

% Salvar dados:
%%
subfolderName = ['FUZZY - T2 - MINIMUM', '-',data_horario_test];
trail = ['./results/',folderName,'/',subfolderName];
if (~exist(trail)) mkdir(trail);end   
save([trail, '/y.dat'],'y', '-ascii')
save ([trail, '/u.dat'], 'u', '-ascii')
save([trail, '/Tempo.dat'],'Tempo', '-ascii')
save ([trail, '/ref.dat'], 'ref', '-ascii')
save([trail, '/erro.dat'],'erro', '-ascii')
save ([trail, '/rate.dat'], 'rate', '-ascii')

fileName = ['Resluts for FT2 - Minimum' ,' - ', PIDtype, ' - ', FuzzyType ,' - ' , FT2Itype];
save( [trail,'/',fileName])


