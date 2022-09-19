%Código de Resposta ao Degrau em Malha Aberta


global SerPIC
% clc;
% clear ; %Limpar variáveis do Workspace - INICIO
varlist = {'u','y', 'Tempo'};
clear(varlist{:})
clf(figure(1))

Ts = 1;  %Determinação do período de amostragem
%Dados da estimação pela resposta ao degrau

set_pwm_duty(1,1,3000); %zerar PWM

Qde_amostras =240; %Quantidade de amostras do gráfico

 for k=1:Qde_amostras u(k)=.08;end
    
  h = figure(1);  
  hLine1 = line(nan, nan, 'Color','red');
  title('Implementação Tanque ');
  xlabel('Tempo (s)');
  ylabel('Leitura Sensor');
  k=1;
  %u(k)=0;
   while k < Qde_amostras
       y(k) = recebe(2); %Recebe o valor medido de armazena 

       if u(k)>1 u(k)=1; end;
        if u(k)<0 u(k)=0; end;
        set_pwm_duty(1,u(k),3000);
      x1 = get(hLine1, 'XData');  
      y1 = get(hLine1, 'YData');  
      x1 = [x1 k*Ts];  
      y1 = [y1 y(k)];  
      set(hLine1, 'XData', x1, 'YData', y1);  
      k=k+1;
      Tempo(k) = k*Ts;
      pause(Ts);
      %u(k) = u(k-1) + 0.04;
   end
set_pwm_duty(1,1,3000);


hold on
plot(Tempo,u,'b');
hold off;
% saidas=[Tempo; r; u; y1]';
%  axis([0 Qde_amostras*Ts 0 inf])
%  save -ascii degmotor.dat saidas;

