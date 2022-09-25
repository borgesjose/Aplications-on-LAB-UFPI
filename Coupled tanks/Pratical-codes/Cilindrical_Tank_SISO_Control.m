
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank Aplication                         %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Main script for test of optimal controllers applied to a conical tank

%% Step 1, simulation definition:
        %clear;clc;
        format shortg;
        data_horario_test = datestr(clock,'yyyy-mm-dd THH-MM-SS');
       
        Tsim = 240; % Total simulation time
        
        PIDtype = 'ZN'; %'ZN' = Ziegle-Nichols , 'CC' = Choen Coon,'AT' = Astrom, 'PR' = Teacher tunning;
        PIDflag = 1;
        FuzzyType = 'T2';% 'T1' = Tipo 1, 'T2' = Tipo 2;
        FT1type = 'L'; % L = input linear ; N = input non linear
        FT2Itype = 'L'; % L = input linear ; N = input non linear
        
        
        Opt_type = 'NO'; % AG = Genetic Algorithm ; PS = Particle Swarm ; NO = No optimization
        
        folderName = ['h005', '-', FuzzyType,'-',Opt_type,'-',data_horario_test];

%%        
        if(PIDflag) simName = 'PID';
        else simName = FuzzyType;
        end;
        
        %% Step 2 - Controller definition: 

        [Kc,Ti,Td] = PID(PIDtype); % Type PID selection 
        
%% Step 3  - Controller definition:        

    if (PIDflag)
        disp('lol')
    else
        
    if (FuzzyType == 'T1'),
        Am_min = 2;
        
        Am_max = 5;
        Theta_m_min = 45;
        Theta_m_max = 72;
        L = 2;
        
        % o vetor parametros dá os valores das MF's
        if (FT1type == 'L')
            if (Opt_type == 'AG')
                param = [-L,0,-L,0,L,0,L,-L,0,-L,0,L,0,L];
            end;
            if (Opt_type == 'PS')
                param = [-1.1315,-0.9545,0,0, 0.4670, 0.5544, 0.7647, 1.2665, 1.2889, 1.4262, 1.8816, 1.9272, 2.0000, 2.0000];
            end;
            
            if (Opt_type == 'NO')
                param = [-L,0,-L,0,L,0,L,-L,0,-L,0,L,0,L];
            end;
        
        elseif (FT1type == 'N')
            if (Opt_type == 'AG')
                param = [-L,0,-L,0,L,0,L,-L,0,-L,0,L,0,L];
            end;
            if (Opt_type == 'PS')
                param = [-L,0,-L,0,L,0,L,-L,0,-L,0,L,0,L];
            end;            
            if (Opt_type == 'NO')
                param = [-L,0,-L,0,L,0,L,-L,0,-L,0,L,0,L];
            end;
        end;
        
        
    end
    
    if (FuzzyType == 'T2'),
        Am_min = 2;
        Am_max = 5;
        Theta_m_min = 45;
        Theta_m_max = 72;
        L = 2;
        
        % o vetor parametros dá os valores das MF's:        
        if (FT2Itype == 'L')
            
            %Resultado para PSO:
            if (Opt_type == 'AG')
                param = .3*ones(1,16);   
            end;
            
            if (Opt_type == 'PS')
                param = [ -4.0000,-3.9509,-2.9262,-2.7615,-1.5759,-1.5165,-0.9248,-0.7246,-0.2196, 1.1298, 1.5116, 1.6241, 1.7757, 2.8473,3.2940,4.0000];   
            end;
            
            if (Opt_type == 'NO')
                param = .3*ones(1,16); 
            end;
            
        param =[param,1,1];    
        elseif (FT2Itype == 'N')
            param = [-2,-2,-2,-2,-2,-2,-2,-0.63817,0.63322,1.3364,1.3386,2]; % Dia 04/09/2022
            if (Opt_type == 'NO')
                param = .3*ones(1,12);
            end;

        end;
        
    end

    end      
        %% Step 4, Aplication setings:
        
        global SerPIC
        
        varlist = {'u','y', 'Tempo'};
        clear(varlist{:})
        clf(figure(1))
        
        
        
        Ts = 1; %  5~10s( Digital control systems,Landau,2006,p.32)
        nptos = Tsim/Ts; %number point of simulation
        ts = linspace(0,Tsim,nptos); % time vector
        H=nptos; % Horizon
      
        set_pwm_duty(1,1,3000); %zerar PWM

        
        u = zeros(nptos,1); % variavel de entrada
        h = zeros(nptos,1); % variavel de saida
        
        ref_type = 'st'; % st = step ; us = upper stair ; ls = lower stair;
        patamar = 0.050;
        passo = 0.10;
       
        ref = ref_def(patamar,passo,nptos);
                
          h = figure(1);  
          hLine1 = line(nan, nan, 'Color','red');
          title('Implementação Tanque ');
          xlabel('Tempo (s)');
          ylabel('Leitura Sensor');
        
          %Flag-acionar medida altura
            flag_h = 0;
        
         k=1;
        
        
        %% Step 8, PLANT APLICATION;

        while k < nptos
            
            if flag_h == 1:
               y(k) = mapfun(recebe(2),0.19,2.389,0,60); %Recebe o valor medido da altura e armazena 
            else
               y(k) = recebe(2); %Recebe o valor medido de armazena  
            end
            

            erro(k)=ref(k) - y(k);
           
            
            rate(k)=(erro(k) - erro(k-1));%/Tc; %Rate of erro

            if (PIDflag)
                Ami = 1;
            else
                if (FuzzyType == 'T1'),
                    
                    Am(k) = FT1_pid_ag(erro(k),rate(k),L,param,FT1type);
                    Ami = Am(k)*Am_max + Am_min*(1 - Am(k));
                end
                
                if (FuzzyType == 'T2'),
                    
                    Am(k) =Inferencia_T2(erro(k),rate(k),L,param,FT2Itype);
                    Ami = Am(k)*Am_max + Am_min*(1 - Am(k));
                    
                end
                
            end
                        %Controlador:

                        Kp(k)= Kc/Ami;
                        Kd(k)= (Td)*Kc/Ami;
                        Ki(k)= (Kc/Ami)/(Ti);

                        alpha = (Kc/Ami)*(1+((Td)/Ts)+(Ts/(2*(Ti))));
                        beta = -(Kc/Ami)*(1+2*((Td)/Ts)-(Ts/(2*(Ti))));
                        gama = (Kc/Ami)*(Td)/Ts;

                        u(k)= u(k-1) + alpha*erro(k) + beta*erro(k-1) + gama*erro(k-2);                      

                        %saturation:
                        if(u(k)<0) u(k)=0;end;
                        if(u(k)>1) u(k)=1;end;
                        
              set_pwm_duty(1,u(k),3000);
              
              x1 = get(hLine1, 'XData');  
              y1 = get(hLine1, 'YData');  
              x1 = [x1 k*Ts];  
              y1 = [y1 y(k)];  
              set(hLine1, 'XData', x1, 'YData', y1);  
              k=k+1;
              Tempo(k) = k*Ts;
              tempo(k)=Tempo(k);
              pause(Ts);

        end
        set_pwm_duty(1,1,3000);
        %% Step 7, Saving and ploting results
        
        if (PIDflag)
            ISE_pid  = objfunc(erro,tempo,'ISE')
            ITSE_pid = objfunc(erro,tempo,'ITSE')
            ITAE_pid = objfunc(erro,tempo,'ITAE')
            IAE_pid  = objfunc(erro,tempo,'IAE')
            
            I_pid = esforco_ponderado(erro,u,H,100)
            IG_pid = IG(H,1e4,1e9,1,u,ref,h)
            
            sy_pid = var(h)
            su_pid = var(u)
            
            fileName = ['Resluts for PID - ' ,' - ', Opt_type , ' - ', PIDtype,' - ',ref_type,' - ',simName];
            trail = ['./results/',folderName];
            if (~exist(trail)) mkdir(trail);end   
            save( [trail,'/',fileName])

           %[fig1,fig2] =  p_pid(ts,h,ref,u,tempo,Kp,Kd,Ki)
            
        elseif(Opt_type ~= 'NO'),
            
            if (FuzzyType == 'T1') 
            
                if (FT1type == 'L')
                    I_t1 = esforco_ponderado(erro,u,H,100)

                    ISE_t1  = objfunc(erro,tempo,'ISE')
                    ITSE_t1 = objfunc(erro,tempo,'ITSE')
                    ITAE_t1 = objfunc(erro,tempo,'ITAE')
                    IAE_t1  = objfunc(erro,tempo,'IAE')

                    IG_t1 = IG(H,1e4,1e9,1,u,ref,h)

                    sy_t1= var(h)
                    su_t1 = var(u)

                fileName = ['Resluts for PID - FT1-FG ' ,' - ', Opt_type , ' - ', PIDtype, ' - ', FuzzyType ,' - ' , FT1type, ' - ',ref_type,' - ',simName];
                trail = ['./results/', Opt_type,'/',folderName];
                if (~exist(trail)) mkdir(trail);end   
                save( [trail,'/',fileName])


                 %p_ft1(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)

                elseif (FT1type == 'N')
                    I_t1 = esforco_ponderado(erro,u,H,100)

                    ISE_t1  = objfunc(erro,tempo,'ISE')
                    ITSE_t1 = objfunc(erro,tempo,'ITSE')
                    ITAE_t1 = objfunc(erro,tempo,'ITAE')
                    IAE_t1  = objfunc(erro,tempo,'IAE')

                    IG_t1 = IG(H,1e4,1e9,1,u,ref,h)

                    sy_t1= var(h)
                    su_t1 = var(u)

                    fileName = ['Resluts for PID - FT1-FG ' ,' - ', Opt_type , ' - ', PIDtype, ' - ', FuzzyType ,' - ' , FT1type, ' - ',ref_type,' - ',simName];
                    trail = ['./results/', Opt_type,'/',folderName];
                    if (~exist(trail)) mkdir(trail);end   
                    save( [trail,'/',fileName])

                  % p_ft1_nl(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)

                end;
            
            
        elseif (FuzzyType == 'T2'),
            
            if (FT2Itype == 'L')
                I_t2_li = esforco_ponderado(erro,u,H,100)
                
                ISE_t2_li  = objfunc(erro,tempo,'ISE')
                ITSE_t2_li = objfunc(erro,tempo,'ITSE')
                ITAE_t2_li = objfunc(erro,tempo,'ITAE')
                IAE_t2_li  = objfunc(erro,tempo,'IAE')
                
                IG_t2_li = IG(H,1e4,1e9,1,u,ref,h)
                
                sy_t2_li= var(h)
                su_t2_li = var(u)
                
                fileName = ['Resluts for PID - FT2-FG ' ,' - ', Opt_type , ' - ', PIDtype, ' - ', FuzzyType ,' - ' , FT2Itype, ' - ',ref_type,' - ',simName];
                
                trail = ['./results/', Opt_type,'/',folderName];
                if (~exist(trail)) mkdir(trail);end   
                save( [trail,'/',fileName])
                
               % p_ft2(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)
                
            elseif (FT2Itype == 'N')
                I_t2_nli = esforco_ponderado(erro,u,H,100)
                
                ISE_t2_nli  = objfunc(erro,tempo,'ISE')
                ITSE_t2_nli = objfunc(erro,tempo,'ITSE')
                ITAE_t2_nli = objfunc(erro,tempo,'ITAE')
                IAE_t2_nli  = objfunc(erro,tempo,'IAE')
                
                IG_t2_nli = IG(H,1e4,1e9,1,u,ref,h)
                
                sy_t2_nli= var(h)
                su_t2_nli = var(u)
              
                fileName = ['Resluts for PID - FT2-FG ' ,' - ', Opt_type , ' - ', PIDtype, ' - ', FuzzyType ,' - ' , FT2Itype, ' - ',ref_type,' - ',simName];
                
                trail = ['./results/', Opt_type,'/',folderName];
                if (~exist(trail)) mkdir(trail);end   
                save( [trail,'/',fileName])
                
               % p_ft2(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)
                
            end;
             
            end;
            
        else
            if (FuzzyType == 'T1') 
            
                if (FT1type == 'L')
                    I_t1_no = esforco_ponderado(erro,u,H,100)

                    ISE_t1_no  = objfunc(erro,tempo,'ISE')
                    ITSE_t1_no = objfunc(erro,tempo,'ITSE')
                    ITAE_t1_no = objfunc(erro,tempo,'ITAE')
                    IAE_t1_no  = objfunc(erro,tempo,'IAE')

                    IG_t1_no = IG(H,1e4,1e9,1,u,ref,h)

                    sy_t1_no= var(h)
                    su_t1_no = var(u)

                fileName = ['Resluts for PID - FT1-FG ' ,' - ', Opt_type , ' - ', PIDtype, ' - ', FuzzyType ,' - ' , FT1type, ' - ',ref_type,' - ',simName];
                trail = ['./results/', Opt_type,'/',folderName];
                if (~exist(trail)) mkdir(trail);end   
                save( [trail,'/',fileName])


                 %p_ft1(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)

                elseif (FT1type == 'N')
                    I_t1 = esforco_ponderado(erro,u,H,100)

                    ISE_t1_n_no  = objfunc(erro,tempo,'ISE')
                    ITSE_t1_n_no = objfunc(erro,tempo,'ITSE')
                    ITAE_t1_n_no = objfunc(erro,tempo,'ITAE')
                    IAE_t1_n_no  = objfunc(erro,tempo,'IAE')

                    IG_t1_n_no = IG(H,1e4,1e9,1,u,ref,h)

                    sy_t1_n_no = var(h)
                    su_t1_n_no = var(u)

                    fileName = ['Resluts for PID - FT1-FG ' ,' - ', Opt_type , ' - ', PIDtype, ' - ', FuzzyType ,' - ' , FT1type, ' - ',ref_type,' - ',simName];
                    trail = ['./results/', Opt_type,'/',folderName];
                    if (~exist(trail)) mkdir(trail);end   
                    save( [trail,'/',fileName])

                   %p_ft1_nl(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)

                end;
            
            
        elseif (FuzzyType == 'T2'),
            
            if (FT2Itype == 'L')
                I_t2_li_no = esforco_ponderado(erro,u,H,100)
                
                ISE_t2_li_no  = objfunc(erro,tempo,'ISE')
                ITSE_t2_li_no = objfunc(erro,tempo,'ITSE')
                ITAE_t2_li_no = objfunc(erro,tempo,'ITAE')
                IAE_t2_li_no  = objfunc(erro,tempo,'IAE')
                
                IG_t2_li_no = IG(H,1e4,1e9,1,u,ref,h)
                
                sy_t2_li_no= var(h)
                su_t2_li_no = var(u)
                
                fileName = ['Resluts for PID - FT2-FG ' ,' - ', Opt_type , ' - ', PIDtype, ' - ', FuzzyType ,' - ' , FT2Itype, ' - ',ref_type,' - ',simName];
                
                trail = ['./results/', Opt_type,'/',folderName];
                if (~exist(trail)) mkdir(trail);end   
                save( [trail,'/',fileName])
                
               % p_ft2(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)
                
            elseif (FT2Itype == 'N')
                I_t2_nli = esforco_ponderado(erro,u,H,100)
                
                ISE_t2_nli_no  = objfunc(erro,tempo,'ISE')
                ITSE_t2_nli_no = objfunc(erro,tempo,'ITSE')
                ITAE_t2_nli_no = objfunc(erro,tempo,'ITAE')
                IAE_t2_nli_no  = objfunc(erro,tempo,'IAE')
                
                IG_t2_nli_no = IG(H,1e4,1e9,1,u,ref,h)
                
                sy_t2_nli_no= var(h)
                su_t2_nli_no = var(u)
              
                fileName = ['Resluts for PID - FT2-FG' ,' - ', Opt_type , ' - ', PIDtype, ' - ', FuzzyType ,' - ' , FT2Itype, ' - ',ref_type,' - ',simName];
                
                trail = ['./results/', Opt_type,'/',folderName];
                if (~exist(trail)) mkdir(trail);end   
                save( [trail,'/',fileName])
                
                %p_ft2(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)
                
            end;
            
             
            end
            
        end;
        
