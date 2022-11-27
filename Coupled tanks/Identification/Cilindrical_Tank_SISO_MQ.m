%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piau√≠                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -Jos√© Borges do Carmo Neto-         %
% @author Jos√© Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank MQ Identification                  %
%                                                     %
%  -- Version: 1.0  - 25/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dados = 'fig'
npts = 799;
if (dados == 'dat')
    %% CARREGAR .DAT
    load y.dat
    load u.dat
end
if (dados == 'fig')
    %% CARREGAR DADOS DE .FIG

    open('Degrau.fig');
    a = get(gca,'Children');
    xdata = get(a, 'XData');
    ydata = get(a, 'YData');
    A = cell2mat(ydata);
    y = A(2,:);
    u = A(1,:);
end
    %%
figure
plot(y)
hold on
plot(u)
%%
at = 2;
Y = [];
fi = [];

for j = 1:npts
    if j<=2
        y1 = 0; y2 = 1; u1=0;u2=0;
    else y1=y(j-1);  y2=y(j-2);  u1=u(j-1);  u2=u(j-2);
    end;
    
   Y=[Y; y(j)]; fi=[fi;  -y1 -y2 u1 u2];  
   
end;
teta = inv(fi'*fi)*fi'*Y

for t=1:2,
    yest(t)=0;
end;

a1=teta(1);a2=teta(2);b1=teta(3);b2=teta(4);

for t=5:npts,
    yest(t) = -a1*yest(t-3)-a2*yest(t-4)+b1*u(t-3)+b2*u(t-4);
end;

% Pelo estimador de mÌnimos quadrados, tem-se;

%             b1 z + b2
% Gp(Z) = ------------------
%          z^2 + a1 z + a2
%

% --- FunÁ„o de transferÍncia discreta
%          -0.6336 z + 0.9054
%       -------------------------
%       z^2 + 0.5591 z^1 - 0.3840
% --- PerÌodo de amostragem: 1
%

%%
plot(y,'g');
hold on;
plot(yest, 'r');
folderName = 'MQ';

%% 
err = y-yest
plot(err, 'r');

plot(y,'g');
hold on;
plot(y, 'd');
%plot(err, 'r');

%%
trail = ['./results/',folderName];
if (~exist(trail)) mkdir(trail);end   
%save([trail, '/y.dat'],'y', '-ascii')
%save ([trail, '/u.dat'], 'u', '-ascii')
save ([trail, '/teta_MQ.dat'], 'teta', '-ascii')

    



   
   