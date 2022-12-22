%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piaui                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -Jose Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% Pratical results analisis                           %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
clear;
clc;
load('Resluts for PID - AT - 0 - 0.mat')
                H=200
                Tsim = npts*Ts
                ts = linspace(0,Tsim,npts);
                I_pid = esforco_ponderado(erro,u,H,100)
                
                ISE_pid  = objfunc(erro,Tempo,'ISE')
                ITSE_pid = objfunc(erro,Tempo,'ITSE')
                ITAE_pid = objfunc(erro,Tempo,'ITAE')
                IAE_pid  = objfunc(erro,Tempo,'IAE')
                
                IG_pid = IG(H,1e1,1e3,1,u,ref,y)
                
                [ Mp_pid, Te_pid, Ms_pid ] =  find_Mp_Te_Ms(y,ref,Ts)
                
                sy_pid= var(y)
                su_pid = var(u)
                p_pid(ts,y,ref,u,Tempo,Kp,Kd,Ki)
                
%%
%clear;
clc;
load('Resluts for PID - AT - T1 - L.mat')

                Tsim = npts*Ts
                ts = linspace(0,Tsim,npts);
                I_t1_no = esforco_ponderado(erro,u,H,100)
                
                ISE_t1_no  = objfunc(erro,Tempo,'ISE')
                ITSE_t1_no = objfunc(erro,Tempo,'ITSE')
                ITAE_t1_no = objfunc(erro,Tempo,'ITAE')
                IAE_t1_no  = objfunc(erro,Tempo,'IAE')
                
                IG_t1_no = IG(H,1e1,1e3,1,u,ref,y)
                
                [ Mp_t1_no, Te_t1_no, Ms_t1_no ] =  find_Mp_Te_Ms(y,ref,Ts)
                
                sy_t1_no= var(y)
                su_t1_no = var(u)

                p_ft1(ts,y,ref,u,Tempo,Kp,Kd,Ki,Am)
                
%%

clc;
load('Resluts for PID - AT - T2 - L.mat')

                Tsim = npts*Ts
                ts = linspace(0,Tsim,npts);
                I_t2_no = esforco_ponderado(erro,u,H,100)
                
                ISE_t2_no  = objfunc(erro,Tempo,'ISE')
                ITSE_t2_no = objfunc(erro,Tempo,'ITSE')
                ITAE_t2_no = objfunc(erro,Tempo,'ITAE')
                IAE_t2_no  = objfunc(erro,Tempo,'IAE')
                
                IG_t2_no = IG(H,1e1,1e3,1,u,ref,y)
                
                [ Mp_t2_no, Te_t2_no, Ms_t2_no ] =  find_Mp_Te_Ms(y,ref,Ts)
                
                sy_t2_no= var(y)
                su_t2_no = var(u)
                p_ft2(ts,y,ref,u,Tempo,Kp,Kd,Ki,Am) 
                
%%


clc;
load('Resluts for FT1 - Minimum - AT - T2 - L.mat')
                H=200
                Tsim = npts*Ts
                ts = linspace(0,Tsim,npts);
                I_t1_min = esforco_ponderado(erro,u,H,100)
                
                ISE_t1_min  = objfunc(erro,Tempo,'ISE')
                ITSE_t1_min = objfunc(erro,Tempo,'ITSE')
                ITAE_t1_min = objfunc(erro,Tempo,'ITAE')
                IAE_t1_min  = objfunc(erro,Tempo,'IAE')
                
                IG_t1_min = IG(H,1e1,1e3,1,u,ref,y)
                
                [ Mp_t1_min, Te_t1_min, Ms_t1_min ] =  find_Mp_Te_Ms(y,ref,Ts)
                
                sy_t1_min= var(y)
                su_t1_min = var(u)
                p_ft1(ts,y,ref,u,Tempo,Kp,Kd,Ki,Am) 


%%

clc;
load('Resluts for FT2 - Minimum - AT - T2 - L.mat')
                H=200
                Tsim = npts*Ts
                ts = linspace(0,Tsim,npts);
                I_t2_min = esforco_ponderado(erro,u,H,100)
                
                ISE_t2_min  = objfunc(erro,Tempo,'ISE')
                ITSE_t2_min = objfunc(erro,Tempo,'ITSE')
                ITAE_t2_min = objfunc(erro,Tempo,'ITAE')
                IAE_t2_min  = objfunc(erro,Tempo,'IAE')
                
                IG_t2_min = IG(H,1e1,1e3,1,u,ref,y)
                
                [ Mp_t2_min, Te_t2_min, Ms_t2_min ] =  find_Mp_Te_Ms(y,ref,Ts)
                
                sy_t2_min= var(y)
                su_t2_min = var(u)
                p_ft2(ts,y,ref,u,Tempo,Kp,Kd,Ki,Am) 
                
%%

clc;
load('Resluts for FT2 - Minimum -NO- AT - T2 - L.mat')
                H=200
                Tsim = npts*Ts
                ts = linspace(0,Tsim,npts);
                I_t2_min_no = esforco_ponderado(erro,u,H,100)
                
                ISE_t2_min_no  = objfunc(erro,Tempo,'ISE')
                ITSE_t2_min_no = objfunc(erro,Tempo,'ITSE')
                ITAE_t2_min_no = objfunc(erro,Tempo,'ITAE')
                IAE_t2_min_no  = objfunc(erro,Tempo,'IAE')
                
                IG_t2_min_no = IG(H,1e1,1e3,1,u,ref,y)
                
                [ Mp_t2_min_no, Te_t2_min_no, Ms_t2_min_no ] =  find_Mp_Te_Ms(y,ref,Ts)
                
                sy_t2_min_no= var(y)
                su_t2_min_no = var(u)
                p_ft2(ts,y,ref,u,Tempo,Kp,Kd,Ki,Am) 

                