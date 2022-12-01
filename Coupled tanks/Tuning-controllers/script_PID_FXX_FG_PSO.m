        Tsim = 1500; % Total simulation time
        PIDtype = 'CC'; %'ZN' = Ziegle-Nichols , 'CC' = Choen Coon,'AT' = Astrom, 'PR' = Teacher tunning;
        PIDflag = 0;
        %% Step 2 - Problem definition:
        load teta.dat
        a1=teta(1);a2=teta(2);b1=teta(3);b2=teta(4);
 
        %% Step 3 - Controller definition: 

        [Kc,Ti,Td] = PID(PIDtype); % Type PID selection 
        

        Ts = 1; %  5~10s( Digital control systems,Landau,2006,p.32)
        nptos = Tsim/Ts; %number point of simulation
        ts = linspace(0,Tsim,nptos); % time vector
        H=nptos; % Horizon
       
        u = zeros(nptos,1); % variavel de entrada
        h = zeros(nptos,1); % variavel de saida
        
        %ref_type = 'st'; % st = step ; us = upper stair ; ls = lower stair;
        patamar = 1;
        passo = 0.10;
        Tamostra = Ts;
    
        ref = ref_def(patamar,passo,nptos);
                
        %clear h;
        h(4)=0 ; h(3)=0 ; h(2)=0 ; h(1)=0 ; 
        u(1)=0 ; u(2)=0 ; u(3)=0; u(4)=0;
        erro(1)=1 ; erro(2)=1 ; erro(3)=1; erro(4)=1;


        Am_min = 1;
        Am_max = 18;
        Theta_m_min = 45;
        Theta_m_max = 72;
        


if (FuzzyType == 'T1'),
            
            if (FT1type == 'L')
                gene = currentX;
                Param = gene;
                
            elseif (FT1type == 'N')
                
               gene = currentX;
               Param = gene;
    
            end;
            
            
         elseif (FuzzyType == 'T2'),
            
            if (FT2Itype == 'L')
                
                gene = currentX;
                Param =[gene,1,1];
                
            elseif (FT2Itype == 'N')
                
                gene = currentX;
                Param = gene;
                
            end;
 end
         


        %% Step 8, Simulation with ode45;

        for i=5:nptos
            
            
            h(i) = -a1*h(i-3)-a2*h(i-4)+b1*u(i-3)+b2*u(i-4);
            
            
           erro(i)=ref(i) - h(i);

            rate(i)=(erro(i) - erro(i-1));%/Tc; %Rate of erro

            if (PIDflag)
                Ami = 1;
            else
                if (FuzzyType == 'T1'),
                    
                    Am(i) = FT1_pid_ag(erro(i),rate(i),L,Param,FT1type);
                    Ami = Am(i)*Am_max + Am_min*(1 - Am(i));
                end
                
                if (FuzzyType == 'T2'),
                    
                    Am(i) =Inferencia_T2(erro(i),rate(i),L,Param,FT2Itype);
                    Ami = Am(i)*Am_max + Am_min*(1 - Am(i));
                    
                end
                
            end
                        %Controlador:

                        Kp(i)= Kc/Ami;
                        Kd(i)= (Td)*Kc/Ami;
                        Ki(i)= (Kc/Ami)/(Ti);

                        alpha = (Kc/Ami)*(1+((Td)/Tamostra)+(Tamostra/(2*(Ti))));
                        beta = -(Kc/Ami)*(1+2*((Td)/Tamostra)-(Tamostra/(2*(Ti))));
                        gama = (Kc/Ami)*(Td)/Tamostra;

                            u(i)= u(i-1) + alpha*erro(i) + beta*erro(i-1) + gama*erro(i-2);

                        %saturation:
                        if(u(i)<0.05) u(i)=0.05;end;
                        if(u(i)>0.5) u(i)=0.5;end;

                        tempo(i)=i*Tamostra;

        end