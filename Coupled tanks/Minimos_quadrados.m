%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piau√≠                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -Jos√© Borges do Carmo Neto-         %
% @author Jos√© Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% Minimos Quadrados                                   %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

inicializa('COM4')
%clear;
Ts = 0.1;
npts=200;
%%
clear u y tempo;
for k=1:npts
    u(k) = 50 + 0.9*(5 - 10*rand(1,1));
%     if(k < (npts/2)),u(k) = 25 + 0.9*(2.5 - 5*rand(1,1)); end
%     if( k >= (npts/2) ),u(k) = 50 + 0.9*(5 - 10*rand(1,1)); end
     %Degrau com ruido branco
    tempo(k) = Ts*k; %tempo
end
% figure;
% plot(u)
%% Aplicando o degrau com ruido branco:
y(1)=0; y(2)=0; u(1)=0; u(2)=0;
for k=3:npts
    tt = clock;
    %y(k) = num(2)*u(k-1) + num(3)*u(k-2) - den(2)*y(k-1) - den(3)*y(k-2);
            if u(k)<0
                u(k) = 0;
            end
            if u(k)>100
                u(k) = 100;
            end
       set_pwm(u(k));
    
       y(k) = recebe_velocidade;
        if y(k)>75
            y(k) = recebe_velocidade;
        end
        if y(k)<0
            y(k) = recebe_velocidade;
        end
       fprintf('amostra:  %d \t entrada:  %6.3f \t saida:  %4.0f\n',k,u(k),y(k));
       while etime(clock, tt) < Ts
       %n„o fazer nada enquanto o tempo de amostragem n„o terminar
       end
       
end
set_pwm(0);
finaliza;
%%
    clear saida
    saida = [u;y]
    %saveas(saida,'tabela','.csv')
%% Estimador dos MÌnimos Quadrado

Y=[];
fi=[];
for j=1:npts
 if j<=2
   y1=0; y2=0;  u1=0; u2=0;
   else  y1=y(j-1);  y2=y(j-2);  u1=u(j-1);  u2=u(j-2);
 end;
   Y=[Y; y(j)];
   fi=[fi;  -y1 -y2 u1 u2];   
end;

teta= inv(fi'*fi)*fi'*Y;

for k=1:2
    yest(k)=0; yu(k)=0;e(k)=0;
end;

a1=teta(1) ; a2=teta(2)  ; b1=teta(3) ; b2=teta(4);
t(1)=Ts ; t(2)=Ts*2;t(3)=Ts*3;t(4)=Ts*4
 
for i=1:npts
    u(k) = 50 + 0.9*(5 - 10*rand(1,1));
%     if(k < (npts/2)),u(k) = 25 + 0.9*(2.5 - 5*rand(1,1)); end
%     if( k >= (npts/2) ),u(k) = 50 + 0.9*(5 - 10*rand(1,1)); end
end
%u(1)=0; u(2)=0;

for k=3:npts
     yest(k)=-a1*yest(k-1)-a2*yest(k-2)+b1*u(k-1)+b2*u(k-2);
     t(k)=k*Ts;
end

%% Plotar
figure;
plot(t,y', 'b')
hold on
plot( t, yest', 'r' )
hold off
legend('original','estimado')
%figure(2)
%plot(t,u);
