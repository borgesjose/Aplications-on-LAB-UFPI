%********Sintonia de Controladores PID M?todo do Astron (Ziegler-Nichols
%                                                             Modificado)
P=0;
I=0;
D=0;
%*********  Per?odo de amostragem  *******
% Ler do prompt - Tamostra=0.5;

%***********  Dados do Rel?  ****************
% Ler do prompt

%******************Identifica a FT do processo na frequ?ncia*******
gw=-(pi*sqrt(a^2-eps^2))/(4*d) %PROCESSO: valor da ft pro rel?.
    
%gw = -0.2134+0.4488i;
rp=abs(gw); 
fip=atan(eps/sqrt(a^2-eps^2))
%fip=angle(gw);
%%
%omega = 2.618;
Metodo de Hagglund
%*********Especifica??es*************
fim=0.01;
rs=0.05*rp;
fis=pi*fim/180;

%*************C?lculo dos Par?metros do Controlador***********
Kc=rs*cos(fis-fip)/rp     
aux1=sin(fis-fip)/cos(fis-fip);
aux2=sqrt(1+aux1^2);
aux3=aux1+aux2;
Td=aux3/(2*omega);
Ti=4*Td;

P=Kc
I=Kc/Ti
D=Kc*Td




Kc
Ti
Td