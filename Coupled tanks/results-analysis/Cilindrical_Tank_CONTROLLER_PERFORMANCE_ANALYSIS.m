
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do PiauÃ­                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -JosÃ© Borges do Carmo Neto-         %
% @author JosÃ© Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% PRATICAL RESULT ANALISIS                            %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Neste script temos analise do desempenhi do controlador aplidaco ao tanque
%siso
%%
load 'y.dat'
load 'u.dat'
load 'Tempo.dat'
load 'ref.dat'
load 'rate.dat'
load 'erro.dat'

%%
figure(1)
hold on;
plot(y,'g');
plot(ref,'r');

