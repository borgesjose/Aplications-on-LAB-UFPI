%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank Open Loop                          %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global SerPIC

varlist = {'u','y', 'Tempo'};
clear(varlist{:})
clf(figure(1))

Ts = 1;  %Determinação do período de amostragem

freq = 6000; %Frequencia de atuação da bomba

%Flag-acionar medida altura
flag_h = 0;

%Previnir erro de leitura
recebe(1)
recebe(2)
recebe(3)

%zerar PWM
set_pwm_duty(1,1,freq); 

Qde_amostras =200; %Quantidade de amostras do gráfico

for k=1:Qde_amostras u(k)=.1;end % Gerar o sinal de entrada;

h = figure(1);  
  hLine1 = line(nan, nan, 'Color','red');
  title('Resposta ao Degrau Tanque ');
  xlabel('Tempo (s)');
        if flag_h == 1:
           ylabel('Altura da Coluna de agua'); 
        else
           ylabel('Leitura do Sensor');  
        end
  
  k=1;
     while k < Qde_amostras
       
        if flag_h == 1:
           y(k) = mapfun(recebe(2),0.19,2.389,0,60); %Recebe o valor medido da altura e armazena 
        else
           y(k) = recebe(2); %Recebe o valor medido de armazena  
        end
        
        
      if u(k)>1 
         u(k)=1; 
      end;
      if u(k)<0 
         u(k)=0; 
      end;
      set_pwm_duty(1,u(k),freq);
      x1 = get(hLine1, 'XData');  
      y1 = get(hLine1, 'YData');  
      x1 = [x1 k*Ts];  
      y1 = [y1 y(k)];  
      set(hLine1, 'XData', x1, 'YData', y1);  
      k=k+1;
      Tempo(k) = k*Ts;
      pause(Ts);
     end
  
 %zerar bomba
 set_pwm_duty(1,1,freq); 
 
%Plotar sinal de controle 
hold on
plot(Tempo,u,'b');
hold off; 
  
  

