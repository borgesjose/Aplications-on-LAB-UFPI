%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% @author                                             %
% @email                                              %
%  Resposta ao Degrau em Malha Aberta                 %
%                                                     %
%  -- Version: x.x  - xx/xx/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc, clear
global SerPic

Ts = 0.1;  %Determinação do período de amostragem
Qde_amostras = 100;

a = 10.480;
Tu = 0.7;
d = 35;
epson = 1;

alpha = 0.25;
r_a = pi*a/(4*d);
phi_a = atan(epson/sqrt(a^2-epson^2));
omega_a = 2*pi/Tu;

r_b = r_a / 1.5;
phi_b = deg2rad(45);

Kp = (r_b*cos(phi_b-phi_a))/(r_a);
Ti = ((omega_a*tan(phi_b-phi_a)) + sqrt(omega_a^2*tan(phi_b-phi_a)^2 + 4*omega_a^2*alpha))/(2*omega_a^2*alpha);
Td = alpha*Ti;

Ki = Kp/Ti;
Kd = Kp*Td;

a1 = Kp + (Ki*Ts)/2 + Kd/Ts;
a2 = Ki*Ts/2 - Kp - 2*Kd/Ts;
a3 = Kd/Ts;


set_pwm(0); %zerar PWM

for k = 1:10
  r(k) = 0;
  e(k) = 0;
  u(k) = 0;
  y(k) = 0;
end

for k = 11:Qde_amostras
  r(k) = 60;
end


h = figure(1);
hLine1 = line(nan, nan, 'Color','red');
title('Implementação Controle Motor DC');
xlabel('Tempo (s)');
ylabel('Velocidade (RPS)');

k=5;
Kg=6;
while k <= Qde_amostras
     y(k) = recebe_velocidade; %Recebe o valor medido de armazena

     e(k) = r(k) - y(k);

     u(k) = u(k-1) + a1*e(k) + a2*e(k-1) + a3*e(k-2);

     if u(k) > 100
          u(k) = 100;
     end;
     if u(k) < 0
          u(k) = 0;
     end;

     set_pwm(u(k));

     x1 = get(hLine1, 'XData');
     y1 = get(hLine1, 'YData');
     x1 = [x1 k*Ts];    % vetor com as amostras de tempo
     y1 = [y1 y(k)];    % vetor com as respostas

     set(hLine1, 'XData', x1, 'YData', y1);

     Tempo(k) = k*Ts;
     k = k+1;
     pause(0.1);
end
set_pwm(0);


hold on
plot(Tempo,r);
plot(Tempo,u);
hold off;
grid


