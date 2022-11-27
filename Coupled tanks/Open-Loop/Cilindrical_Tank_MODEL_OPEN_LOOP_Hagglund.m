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


load teta_hagglund.dat
a1=teta_hagglund(1);a2=0;b1=teta_hagglund(2);b2=teta_hagglund(3);

for t=5:npts,

    yest(t) = -a1*yest(t-1)-a2*yest(t-2)+b1*u(t-1)+b2*u(t-2);

end;

plot(yest,'g');
hold on;
%plot(u, 'r');
folderName = 'model-closed-loop';

%%
err = yest
plot(err, 'r');

%plot(y,'g');
%hold on;



    



   
   