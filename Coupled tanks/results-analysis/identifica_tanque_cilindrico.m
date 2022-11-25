 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
%  Simulation cilindrical tank                        %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Dados do tanque cilidrico

H = 70 % Altura 
R = 3.75 % Raio
h0 = 30 % Altura a ser linearizado
g = 9.81 % gravidade

a = 9.0269 % Constante da valvula

b = a*sqrt(2*g)

k1 = 1/(pi*R^2)
k2 = b*k1
%%
% Modelo não linear

k1 = 1/(pi*(R/H)^2)
k2 = b/(pi*(R/H)^2)

%dh_dt = Fin*k1 - k2*h^(-1/2)

%%
% Metodo de Hagglund:
% 
% Hs_planta =
%  
%     Ge^-sL
% -------------------
%    1 + Ts  

G = 5.11

T = 68-12

L = 12 % Atraso de Transporte Caracteristico da planta

s = tf('s')

fts = (G*exp(-s*L))/(1+T*s)

%%
% Discretização do Modelo:
% 
% Hz_planta =
%  
%     b1 z^-1 + b2 z^-2
% ------------------------
%       1 - a1 z^-1  

Ts = 1 % tempo de amostragem ( Landau,2006)

b1 = G*( 1 - exp((L - Ts)/T))

b2 = G*exp(-Ts/T)*(exp(L/T)-1)

a1 = -exp(-Ts/T)

z = tf('z', Ts )

ftz = (b1*(z^-1)+ b2*(z^-2))/(1 + a1*(z^-1))

teta = [a1,b1,b2]

%%
folderName = 'Metodo de Hagglund';
trail = ['./results/',folderName];
if (~exist(trail)) mkdir(trail);end   
%save([trail, '/y.dat'],'y', '-ascii')
%save ([trail, '/u.dat'], 'u', '-ascii')
save ([trail, '/teta.dat'], 'teta', '-ascii')

%%
uiopen('resposta ao degrau com ruido.fig',1)
opt = stepDataOptions;
opt.StepAmplitude = .3;
hold on
step(fts,opt)
step(ftz,opt)
