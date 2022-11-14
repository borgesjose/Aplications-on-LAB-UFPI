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

load y.dat
load u.dat


yy = smooth(y);
%y = yy';

%y = y(at:end);
%u = u(at:end);

at = 12;
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

plot(y,'g');
hold on;
plot(yest, 'r');
folderName = 'MQ';

%%

err = y-yest
plot(err, 'r');

plot(y,'g');
hold on;
plot(yy, 'r');
plot(ee, 'r');

%%


%%
trail = ['./results/',folderName];
if (~exist(trail)) mkdir(trail);end   
%save([trail, '/y.dat'],'y', '-ascii')
%save ([trail, '/u.dat'], 'u', '-ascii')
save ([trail, '/teta.dat'], 'teta', '-ascii')

    



   
   