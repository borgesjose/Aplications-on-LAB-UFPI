%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% @author                                             %
% @email                                              %
%  Resposta ao Degrau em Malha Aberta                 %
%                                                     %
%  -- Version: x.x  - xx/xx/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Não fiz nenhuma alteração nesse código ele já era 100% compativel com octave
varlist = {'ref','u','e','y', 'Tempo','maxi','mini','a','img','real','g','ep','d'};
clear(varlist{:})

%Código implementação Relé
global SerPIC
 %Limpar o Workspace - INICIO
Ts = 0.1;  %Determinação do período de amostragem
set_pwm(0); %zerar PWM
ep = 6 %epsilon igual a 2.5 dá valor máximo do motor
%eps=10;
dh=75;
dl=5;

%clf(figure(1))

Qde_amostras = 100; %Quantidade de amostras do gráfico
% REF = 100; % Referência em 100% de PWM
% pwm = REF;

for k=1:Qde_amostras
    ref(k)=40;
end

clf(figure(2));
h = figure(2);
hLine1 = line(nan, nan, 'Color','red');
title('Implementação Controle Motor DC');
xlabel('Tempo (s)');
ylabel('Velocidade (RPS)');

%Inicializa as variáveis gráficas
  k=1;
  y(1)=0 ; y(2)=0; erro(1)=ref(1)-y(1); erro(2)=ref(2)-y(2); u(1)=0; u(2)=0;
  while k<2
      x1 = get(hLine1, 'XData');
      y1 = get(hLine1, 'YData');
      k=1;
      x1 = [x1 k*Ts];
      y1 = [y1 y(k)];
      set(hLine1, 'XData', x1, 'YData', y1); % atribuindo os vetores atualizados a figura h
      k=k+1;
  end
u(1)=dh;
for k=2:Qde_amostras

    y(k) = recebe_velocidade; %Recebe o valor medido de armazena

   e(k) = ref(k)-y(k);
   if ((abs(e(k)) >= ep)&& (e(k)  > 0))     u(k) =  dh; end;
   if ((abs(e(k)) > ep) && (e(k)  < 0))     u(k) =  dl; end;
   if ((abs(e(k)) < ep) && (u(k-1) == dh))  u(k) =  dh; end;
   if ((abs(e(k)) < ep) && (u(k-1) == dl))  u(k) =  dl; end;
    x1 = get(hLine1, 'XData');
    y1 = get(hLine1, 'YData');
    x1 = [x1 k*Ts];
    y1 = [y1 y(k)];
    set(hLine1, 'XData', x1, 'YData', y1);
   Tempo(k) = k*Ts;

    set_pwm(u(k))

   pause(0.1);
    end

set_pwm(0);
  maxi=max(y1);
  mini=min(y1(7:50));
  d=(dh-dl)/2
  a=(maxi-mini)/2
  img=((pi*ep)/(4*d))
  real=((-pi)/(4*d))*sqrt((a^2)-(ep^2))
  g=real-j*img

kont = 0;
for t = 4:Qde_amostras,
   if u(t) ~= u(t-1)
      kont = kont + 1;
      ch(kont) = t;
   end
end
Tu1 = (ch(3) - ch(2))*Tamostra
Tu2 = (ch(4) - ch(3))*Tamostra
Tu = Tu1 + Tu2
omega = (2*pi)/(Tu)

% --- Calcula valor de pico positivo
amp_max = eps;
for t =1:Qde_amostras,
   if y(t) >= amp_max  amp_max = y(t); end;
end;

%********Sintonia de Controladores PID Método do Astrom (Ziegler-Nichols
%                                                             Modificado)
P=0;
I=0;
D=0;

  %******************Calculo ganho e fase do processo*******
gwr=-(pi*sqrt(a^2-eps^2))/(4*d)
gwi=-(pi*eps)/(4*d)
ra=abs(gwr-j*gwi);
fia=atan(eps/sqrt(a^2-eps^2));

%*********Especificações do ganho e da fase *************
fib=60;
rb=ra/0.25;
fib=pi*fib;

%*************Cálculo dos Parâmetros do Controlador***********
Kc=rb*cos(fib-fia)/ra
aux1=tan(fib-fia);
aux2=sqrt(1+aux1^2);
aux3=aux1+aux2;
Ti=aux3/(2*omega*0.25)
Td=0.25*Ti
P=Kc
I=Kc/Ti
D=Kc*Td

%clf(figure(2));
%figure(2);
hold on
plot(Tempo,u,'b'); %Gera o gráfico Tempo x Saída
hold off;
saidas=[Tempo; u; y]';
% axis([0 Qde_amostras*Ts 0 inf])
%save -ascii ReleHisterese4.dat saidas;
