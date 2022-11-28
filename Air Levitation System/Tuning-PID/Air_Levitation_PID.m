%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -Jose Borges do Carmo Neto-         %
% @author José Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% PID                                                 %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

varlist = {'u','y', 'Tempo'};
clear(varlist{:})
clf(figure(1))

format shortg;
data_horario_test = datestr(clock,'yyyy-mm-dd THH-MM-SS');
folderName = 'siso_control_cilindrical_tank';

Ts = 0.06;  %Determinação do período de amostragem



Qde_amostras =1000; %Quantidade de amostras do gráfico
npts = Qde_amostras;

%Flags

PIDflag = 0;
h_flag = 0;
PIDtype = 'AT';

%% PID definition: 

        Ts = 0.06; %  5~10s( Digital control systems,Landau,2006,p.32)

        ts = linspace(0,Qde_amostras,npts); % time vector
        H=npts; % Horizon
       
        u = zeros(npts,1); % variavel de entrada
        h = zeros(npts,1); % variavel de saida
        
        ref_type = 'st'; % st = step ; us = upper stair ; ls = lower stair;
    
        patamar = 50;
        passo = 20;
        ref = ref_def(patamar,passo,npts) % Gerar degraus;   
                
        y(1)=0 ; y(2)=0 ; y(3)=0; y(4)=0;
        u(1)=0 ; u(2)=0 ; u(3)=0; u(4)=0;
        erro(1)=1 ; erro(2)=1 ; erro(3)=1; erro(4)=1;
         Tamostra = Ts;

[Kc,Ti,Td] = PID(PIDtype); % Type PID selection


%% 
% load teta_hagglund.dat
% a1=teta_hagglund(1);a2=0;b1=teta_hagglund(2);b2=teta_hagglund(3);
a1 = -0.955255265000912
a2 = -0.029363939258160
b1 = 0.026243849901936
b2 = 0.274777441417530
     for k=3:npts
       
        y(k) = -a1*y(k-1)-a2*y(k-2)+b1*u(k-1)+b2*u(k-2);
        
        
        erro(k)= ref(k) - y(k);
        rate(k)=(erro(k) - erro(k-1));%/Tc; %Rate of erro
        
        
         
        
 
         
                        %Controlador:
                        Ami = 1;
                        Kp(k)= Kc/Ami;
                        Kd(k)= (Td)*Kc/Ami;
                        Ki(k)= (Kc/Ami)/(Ti);

                        alpha = (Kc/Ami)*(1+((Td)/Tamostra)+(Tamostra/(2*(Ti))));
                        beta = -(Kc/Ami)*(1+2*((Td)/Tamostra)-(Tamostra/(2*(Ti))));
                        gama = (Kc/Ami)*(Td)/Tamostra;

               
                        u(k)= u(k-1) + alpha*erro(k) + beta*erro(k-1) + gama*erro(k-2);
                
        

      %saturation:
    if u(k) > 100
        u(k) = 100;
    elseif u(k) < 0
        u(k) = 0;
    end
      
  
      
      Tempo(k) = k*Ts;
      %pause(Ts);
     end
   
%Plotar sinal de controle 
hold on
plot(Tempo,y,'r');
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
save ([trail, '/rate.dat'], 'u', '-ascii')


