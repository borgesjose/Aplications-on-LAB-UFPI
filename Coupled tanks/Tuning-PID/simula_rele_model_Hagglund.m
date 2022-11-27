%	Modelagem da função de transferência: Relé com histerese

% --- Função de transferência discreta
%          -1.1091 z + 1.1996
%         -------------------
%           z^2 + 0.9823 z^1 
% --- Período de amostragem: 1


clear all;
Tamostra = 1
nptos = 60;
d = 0.8;

eps = 0.01;
for t=1:5,
   u(t) = -d;e(t) = 0;y(t) = 0;tempo(t) = t*Tamostra;
end;

% --- Experimentação com o relé
load teta_Hagglund.dat
a1=teta_Hagglund(1);b1=teta_Hagglund(2);b2=teta_Hagglund(3);
a2=0;
for t = 5:nptos,								

   y(t) = -a1*y(t-3)-a2*y(t-4)+b1*u(t-3)+b2*u(t-4);
   
   e(t) = -y(t);
   if ((abs(e(t)) >= eps) & (e(t)  >0))      u(t) =  d; end;
   if ((abs(e(t)) > eps) & (e(t) < 0))      u(t) = -d; end;
   if ((abs(e(t)) < eps) & (u(t-1) == d))   u(t) =  d; end;
   if ((abs(e(t)) < eps) & (u(t-1) == -d))  u(t) = -d; end;
   tempo(t) = t*Tamostra;
end;
%%
% --- Calcula período
kont = 0;								
for t = 4:nptos,								
   if u(t) ~= u(t-1)
      kont = kont + 1;
      ch(kont) = t;
   end
end
%%
Tu1 = (ch(7) - ch(6))*Tamostra;
Tu2 = (ch(8) - ch(7))*Tamostra;
Tu = Tu1 + Tu2 %Periodo critico;
omega = (2*pi)/(Tu)
aux1 = ch(5);aux2 = ch(7);
% --- Calcula valor de pico positivo
arm = eps;										
for t = aux1:aux2,
   if y(t) >= arm  arm = y(t); end;
end;
Au = arm;
% --- Calcula valor de pico negativo
arm = eps;										
for t = aux1:aux2,
   if y(t) <= arm  arm = y(t); end;
end;
Ad = arm;
a = (abs(Au) + abs(Ad))/2
% --- Calcula ganho critico
Ku = (4*d)/(pi*sqrt(a^2 - eps^2));
% --- Constantes da planta

%% --- Gráfico da saída e entrada
figure(1)
rele = [u;y];
plot(tempo,rele);
%% --- Sintonia por Ziegler-Nichols
Kc = 0.6*Ku
Ti = 0.5*Tu
Td = Ti/4







