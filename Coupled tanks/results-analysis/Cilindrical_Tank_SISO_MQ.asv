%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-         %
% @author José Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank MQ Identification                  %
%                                                     %
%  -- Version: 1.0  - 25/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


npts = 799;

%% CARREGAR .DAT
load y.dat
load u.dat

%% CARREGAR DADOS DE .FIG

open('Degrau.fig');
a = get(gca,'Children');
xdata = get(a, 'XData');
ydata = get(a, 'YData');
A = cell2mat(ydata);
y = A(2,:);
u = A(1,:);
y = y(2:end);
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
 
%%
plot(y,'g');
hold on;
plot(yest, 'r');
folderName = 'MQ-2';

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
save ([trail, '/teta.dat'], 'teta', '-ascii')

    



   
   