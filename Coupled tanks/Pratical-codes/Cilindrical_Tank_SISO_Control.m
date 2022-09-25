
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank Aplication                         %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global SerPIC
varlist = {'u','y', 'Tempo'};
clear(varlist{:})
clf(figure(1))

Ts = 1;  %Determinação do período de amostragem
freq = 3000;


% Evitar erro de leitura
recebe(1)
recebe(2)
recebe(3)
set_pwm_duty(1,1,freq); %zerar PWM


for i=3:nptos,
    tt = clock;
     y(i) = recebe(2);
     erro(i) = ref(i) - y(i); %Erro
     
     rate(i) = ( erro(i) - erro(i-1) );%/Tc; %Rate of erro
     
    
    Am(i) = Inferencia_T2(erro(i),rate(i),L,Param,'LI');
        
    Ami = Am(i)*Am_max + Am_min*(1 - Am(i)); 
    %Ami = 1;
    %Td = 0;

      %Controlador:

            alpha = (Kc/Ami)*(1+((Td/Ami)/Tamostra)+(Tamostra/(2*(Ti*Ami))));
            beta = -(Kc/Ami)*(1+2*((Td/Ami)/Tamostra)-(Tamostra/(2*(Ti*Ami))));
            gama = (Kc/Ami)*(Td/Ami)/Tamostra;
        
            u(i)= u(i-1) + alpha*erro(i) + beta*erro(i-1) + gama*erro(i-2);
            if u(i)<0
                u(i) = 0;
            end
            if u(i)>100
                u(i) = 100;
            end

            set_pwm_duty(1,u(i),freq);
            
       tempo(i)=i*Tamostra;
       
      fprintf('amostra:  %d \t entrada:  %6.3f \t saida:  %4.0f\n',i,u(i),y(i));
       while etime(clock, tt) < Tamostra
       %não fazer nada enquanto o tempo de amostragem não terminar
       end
 end ;
 
 
 
 
