
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-         %
% @author José Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank Frequence domanain Analisis        %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Neste script temos analise no domino da frequencia da planta siso do
%tanque c?nico.
%%
load 'y.dat'
load 'u.dat'
load 'Tempo.dat'
load 'ref.dat'
load 'e.dat'
load 'Tempo.dat'
load 'dl.dat'
load 'dh.dat'
load 'eps.dat'
%%
figure(1);
hold on
plot(u,'b'); %Gera o gráfico Tempo x Saída
plot(y,'r'); %Gera o gráfico Tempo x Saída
hold off;
saidas=[Tempo; u; y]';
%%
Qde_amostras = size(u,2)
ep = eps
Tamostra = 1
  maxi=max(y);
  mini=min(y);
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
a
%%
%logo apos analise dos graficos calculamos os valores da fun??es de
%transferencia
ep2 = [1,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1];

%criamos um vetor com os valores da amplitude da saida do sistema.
a(1) = 1.1815;%ep = 1.0
a(2) = 1.0373;% ep =0.9
a(3) = 1.0606;%ep = 0.8;
a(4) =  0.97788;%ep = 0.3;
a(5) = 1.0797;%ep = 0.4;
a(6) = 0.82939;%ep = 0.5;
a(7) = 0.77636;%ep = 0.2;
a(8) = 0.7403;%ep = 0.3;
a(9) = 0.94394;%ep = 0.4;
a(10) = 0.79758;%ep = 0.5;
%criamos um veotr com os periodos criticos
Tp(1) = 75;
Tp(2) = 68;
Tp(3) = 57;
Tp(4) = 48;
Tp(5)=  47;
Tp(6) = 41;
Tp(7) = 27;
Tp(8) = 21;
Tp(9) = 21;
Tp(10)=  11;

Ncrt = (4*d)*((sqrt(a.^2 - ep2.^2)./a) + (1i.*ep2./a))./(pi.*a); % estimativa do ganho cr?tico.
for i = 1:length(Ncrt)
    num = [-1];
    den = [Ncrt(i)];
    GF(i) = tf(num,den);%fun??es de transferencia estimadas
end
w =2*pi./Tp %Aqui calculamos o vetro com os valores estimados da frrequencia critica.
%% fun??o real
%     x(1) = 1i*w(1);
%     x(2) = 1i*w(2);
%     x(3) = 1i*w(3);
%     x(4) = 1i*w(4);
%     x(5) = 1i*w(5);
%     g = 1./(x.^3+3*x.^2+2*x+1)

%%
%plot do diagrama de Nyquist:
figure;
% viscircles([0 0],1,'LineStyle','--','EdgeColor','black','LineWidth',0.5); hold on;
% nyquist(GZ); title('Compara??o dos diagramas');
 hold on;

for n = 1:length(Ncrt)
nyquist(GF(n));
end
legend('ep = 1.0','ep = 0.9','ep = 0.8','ep = 0.7','ep = 0.6','ep = 0.5','ep = 0.4','ep = 0.3','ep = 0.2','ep = 0.1')
%ylim([-1.2 1.2]);
%xlim([-1.2 1.2]);
%legend('ep = 0.0','ep = 0.1','ep = 0.2','ep = 0.3','ep = 0.4')
hold off;