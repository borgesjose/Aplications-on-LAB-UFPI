%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-         %
% @author Jose Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank relay FT1-PID-FG tuning            %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load 'y.dat'
load 'u.dat'
load 'Tempo.dat'
load 'ref.dat'
load 'e.dat'
load 'dl.dat'
load 'dh.dat'
load 'eps.dat'

%%

ep = eps;
Tamostra = 1;
Qde_amostras = size(u,2);
nptos = Qde_amostras;
n = 200;

maxi=max(y);
mini= .45;%min(y);
d=(dl-dh)/2 
  
  
%%
%     hold on
%     plot(u,'b');
%     plot(y,'g');
%     hold off; 
%% 3 Identificar os parametros a partir do experimento com rel�:

  %[gw,w,arm,Kp]=Identificar(n, d, eps,Tamostra,y,u);
    
  a=(maxi-mini)/2
  img=((pi*ep)/(4*d))
  real=((-pi)/(4*d))*sqrt((a^2)-(ep^2))
  g=real-j*img

kont = 0;
for t = 4:Qde_amostras,
   if u(t) ~= u(t-1)
      kont = kont + 1;
      ch(kont) = t;
   end
end
Tu1 = (ch(3) - ch(2))*Tamostra
Tu2 = (ch(4) - ch(3))*Tamostra
Tu = Tu1 + Tu2
w = (2*pi)/(Tu)

% --- Calcula valor de pico positivo
amp_max = eps;
for t =1:Qde_amostras,
   if y(t) >= amp_max  amp_max = y(t); end;
end;
%%
num = 0;
den = 0;
for j=(n/2):(n/2)+ceil(Tu),
    num = num + y(j);
    den = den + u(j);
end
Kp = num/den
  %******************Calculo ganho e fase do processo*******
gw=-(pi*sqrt(a^2-eps^2))/(4*d)
%%
    Ku = -1/gw;
    %Tu = (2*pi)/w; 

    L = 12;
   
    c = 1/Kp;
    b = sin(w*L)/(w*Ku);
    a = (c + cos(w*L))/(w^2);
    
%% Sintonizanodo o PID:

    Am = 1;
    Theta_m = (180/2)*(1-(1/Am));

    K = (pi/(2*Am*L))*[b;c;a];
    Kc = K(1);
    Ki = K(2);
    Kd = K(3);
    K
    

    Td = Kd/Kc;
    Ti = Kc/Ki;
    
    FT1type = 'L';
    L = 2;
    param =  [-L,0,-L,0,L,0,L,-L,0,-L,0,L,0,L]; % Para MF lineares
    
    %param = [-L,0,-L,0,L,0,L,-L,0,-L,0,L,0,L]; %PAra MF nao Lineares

        Am_min = 1;        
        Am_max = 3;
        Theta_m_min = 30;
        Theta_m_max = 60;
        %L = 12;
%% Step 2 - Problem definition:

load teta.dat
a1=teta(1);a2=teta(2);b1=teta(3);b2=teta(4);



%%
for i=1:nptos,
    if (i<=nptos/2)  ref(i)=1; end;
    if (i>nptos/2)   ref(i) = 2; end;
end ;

h(4)=0 ; h(3)=0 ; h(2)=0 ; h(1)=0 ; 
u(1)=0 ; u(2)=0 ; u(3)=0; u(4)=0;

erro(1)=1 ; erro(2)=1 ; erro(3)=1; erro(4)=1;

        for i=5:nptos
            if(i>100) b1= teta(3)*1.1;end;
                h(i) = -a1*h(i-1)-a2*h(i-2)+b1*u(i-1)+b2*u(i-2);
  

                erro(i)= ref(i) - h(i);
                rate(i)=(erro(i) - erro(i-1));%/Tc; %Rate of erro

                Am(i) = gain_margin_t1(erro(i),rate(i),L,param,FT1type);
                Ami = Am(i)*Am_max + Am_min*(1 - Am(i));
    
                        %Controlador:

%                         Kp(i)= Kc/Ami;
%                         Kd(i)= (Td)*Kc/Ami;
%                         Ki(i)= (Kc/Ami)/(Ti);
% 
%                         alpha = (Kc/Ami)*(1+((Td)/Tamostra)+(Tamostra/(2*(Ti))));
%                         beta = -(Kc/Ami)*(1+2*((Td)/Tamostra)-(Tamostra/(2*(Ti))));
%                         gama = (Kc/Ami)*(Td)/Tamostra;
                        
                        Kci(i) = Kc/Ami;
                        Kdi(i) = Kd/Ami;
                        Kii(i) = Ki/Ami;

                        % new version
                        alpha = Kci(i)+ Kdi(i)/Tamostra + (Kii(i)*Tamostra)/2;
                        beta = -Kci(i) - 2*(Kdi(i)/Tamostra)+(Kii(i)*Tamostra)/2;
                        gama = Kdi(i)/Tamostra;

  
                        u(i)= u(i-1) + alpha*erro(i) + beta*erro(i-1) + gama*erro(i-2);
                       

                        %saturation:
                        if(u(i)<0.05) u(i)=0.05;end;
                        if(u(i)>0.5) u(i)=0.5;end;

                        tempo(i)=i*Tamostra;

        end
  
     ISE_FT1FG = objfunc(erro,tempo,'ISE')
     ITSE_FT1FG = objfunc(erro,tempo,'ITSE')
     ITAE_FT1FG = objfunc(erro,tempo,'ITAE')
     IAE_FT1FG = objfunc(erro,tempo,'IAE')
        
 %plotar seinal de saida e  de controle:    
% figure;
% grid;
plot(tempo,h,'r-');
hold on;
plot(tempo,u);
plot(tempo,ref);
%title(['AT-PID-FG:',num2str(rlevel), ' ISE:', num2str(ISE_t2), ', ITSE:' ,num2str(ITSE_t2),', IAE:' ,num2str(IAE_t2), ', ITAE:' ,num2str(ITAE_t2)])
%%
% %plotar P1 e P2
% figure;
% grid;
% plot(tempo,P1,'g-');
% hold on;
% plot(tempo,P2);       

p_ft1(tempo,h,ref,u,tempo,Kci,Kdi,Kii,Am)
%%
format shortg;
         
folderName ='FT1_PID_FG'  
subfolderName = datestr(clock,'yyyy-mm-dd THH-MM-SS');   
pid = [Kc,Td ,Ti]

% Salvar dados:
trail = ['./results/',folderName,'/',subfolderName];
if (~exist(trail)) mkdir(trail);end   
save([trail, '/pid.dat'],'pid', '-ascii')
