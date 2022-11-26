%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% Extractiong data from fig                           %
%                                                     %
%  -- Version: 1.0  - 25/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

open('grafico6kplantnivel-identificação-hunglund.fig');
a = get(gca,'Children');
xdata = get(a, 'XData');
ydata = get(a, 'YData');
A = cell2mat(ydata);
output = A(2,:);
input = A(1,:);

%%


