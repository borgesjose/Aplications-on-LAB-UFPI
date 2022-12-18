function Am =inferencia_T2_minimum(erro,rate,L,T,H)
%%
%% Maquina de inferencia TYPE-2
%% 
%%
%% Autor: jose borges 
%% Data: 04/03/2019

[mi mo] = pertinencias_T2_minimum(erro,rate,L,T);   % Pertinencias para variavel de entrada ERRO

% Forma do vetor mi
% mi = [Nb,0,Pb,0,0,Nu,Nl,Pu,Pl] erro
% Forma do vetor mo
% mo = [Nb,0,Pb,0,0,Nu,Nl,Pu,Pl] rate

%Base de Regras:

%REGRA 1: 

R(1,:) = [mi(7)*mo(7),mi(6)*mo(6)];

Y(1,:) = [ R(1,1)*H(1) , R(1,2)*H(1) ];
  
%REGRA 2: 

R(2,:) = [mi(9)*mo(7),mi(8)*mo(6)];
Y(2,:) = [ R(2,1)*H(2), R(2,2)*H(2) ];

%REGRA 3: 

R(3,:)= [mi(7)*mo(9),mi(6)*mo(8)];

Y(3,:) = [R(3,1)*H(3), R(3,2)*H(3)];
 
%REGRA 4: 

R(4,:) = [mi(9)*mo(9),mi(8)*mo(8)];

Y(4,:) = [R(4,1)*H(4) ,R(4,2)*H(4)];
 

for i=1:4
       [y(i),yl(i),yr(i),l(i),r(i)]=EIASC(Y(i,1),Y(i,2),R(i,1),R(i,2),1);
       
       IF(i) = (R(i,1)*yl(i) + R(i,2)*yr(i))/2;
       
    end

Am = sum(IF);

%Am = R1*(exp(-R1*4)) + R2*(exp(-R2*4)) + R3*(exp(-R3*4))+ R4*(1 - exp(-R4*4)) + R5*(1 - exp(-R5*4)) + R6*(1 - exp(-R6*4))+ R7*(exp(-R7*4)) + R8*(exp(-R8*4)) + R9*(exp(-R9*4));

end