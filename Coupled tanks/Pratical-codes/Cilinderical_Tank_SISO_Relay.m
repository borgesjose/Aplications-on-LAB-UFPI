%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-         %
% @author José Borges do Carmo Neto                  %
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
subfolderName = datestr(clock,'yyyy-mm-dd THH-MM-SS');
folderName = 'Relay_cilindrical_tank';

Ts = 1;  %Determinação do período de amostragem
Tamostra = Ts;

freq = 3000; %Frequencia de atuação da bomba

Qde_amostras =200; %Quantidade de amostras do gráfico
npts = Qde_amostras;

%%
eps=1;
%eps=10;
dh=0.2;
dl=0.5;
varlist = {'ref','u','e','y', 'Tempo'};
clear(varlist{:})
clf(figure(1))
% %% PID definition: 
% %             Kc = 0.38768;
% %             Ti =  1.5;
% %             Td = 0.375;
%             
% Kc = 0.49529;
% Ti = 1.5;
% Td = 0.375;
% 
% %             Kc = 0.01;
% %             Ti = 0.50;
% %             Td = 0.090;  
% 
%         Am_min = 1;        
%         Am_max = 12;
%         Theta_m_min = 45;
%         Theta_m_max = 72;
%         L = 1;

%%
%Previnir erro de leitura
recebe(1)
recebe(2)
recebe(3)

%zerar PWM
set_pwm_duty(1,1,freq);

%%
Qde_amostras = 200; %Quantidade de amostras do gráfico
% REF = 100; % Referência em 100% de PWM
% pwm = REF;

for k=1:Qde_amostras 
    ref(k)=1;
end
clf(figure(1));
h = figure(1);
hLine1 = line(nan, nan, 'Color','red');
title('Implementação Relé DC');
xlabel('Tempo (s)');
ylabel('Leitura Sensor');
 %Inicializa as variáveis gráficas
  k=1;
  y(1)=0 ; y(2)=0; erro(1)=ref(1)-y(1); erro(2)=ref(2)-y(2); u(1)=0; u(2)=0;
  while k<2
      x1 = get(hLine1, 'XData');  
      y1 = get(hLine1, 'YData');  
      k=1;
      x1 = [x1 k*Ts];  
      y1 = [y1 y(k)];  
      set(hLine1, 'XData', x1, 'YData', y1);
      k=k+1;
  end
u(1)=dh;
for k=2:Qde_amostras
     
    y(k) = recebe_velocidade; %Recebe o valor medido de armazena
        
   e(k) = ref(k)-y(k);
   if ((abs(e(k)) >= eps) & (e(k)  >0))      u(k) =  dh; end;
   if ((abs(e(k)) > eps) & (e(k) < 0))      u(k) = dl; end;
   if ((abs(e(k)) < eps) & (u(k-1) == dh))   u(k) =  dh; end;
   if ((abs(e(k)) < eps) & (u(k-1) == dl))  u(k) = dl; end;
    x1 = get(hLine1, 'XData');  
    y1 = get(hLine1, 'YData');  
    x1 = [x1 k*Ts];  
    y1 = [y1 y(k)];  
    set(hLine1, 'XData', x1, 'YData', y1);  
    Tempo(k) = k*Ts;
   
    set_pwm_duty(1,u(k),freq);
    
   %pause(0.1);
end
%%
  
 %zerar bombau
 set_pwm_duty(1,1,freq); 
 
%Plotar sinal de controle 
hold on
plot(Tempo,u,'b');
plot(Tempo,ref,'g');
hold off; 

% Salvar dados:
trail = ['./results/',folderName,'/',subfolderName];
if (~exist(trail)) mkdir(trail);end   
save([trail, '/y.dat'],'y', '-ascii')
save ([trail, '/u.dat'], 'u', '-ascii')
save([trail, '/Tempo.dat'],'y', '-ascii')
save ([trail, '/ref.dat'], 'u', '-ascii')
save([trail, '/erro.dat'],'y', '-ascii')


