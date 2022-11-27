%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% Closed loop model                                   %
%                                                     %
%  -- Version: 1.0  - 25/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

npts = 799;

for t=1:npts,
    yest(t)=0;
    ref(t) = 0.3;
    u(t) = ref(t);
end;


load teta.dat
a1=teta(1);a2=teta(2);b1=teta(3);b2=teta(4);


for t=5:npts,
    
    
    
    yest(t) = -a1*yest(t-3)-a2*yest(t-4)+b1*u(t-3)+b2*u(t-4);
    
    
    
    
    
end;

plot(yest,'g');
hold on;
%plot(u, 'r');
folderName = 'model-closed-loop';

%%
err = yest
plot(err, 'r');

plot(y,'g');
hold on;
plot(yy, 'r');
plot(ee, 'r');

%%
trail = ['./results/',folderName];
if (~exist(trail)) mkdir(trail);end   
%save([trail, '/y.dat'],'y', '-ascii')
%save ([trail, '/u.dat'], 'u', '-ascii')
save ([trail, '/teta.dat'], 'teta', '-ascii')

    



   
   