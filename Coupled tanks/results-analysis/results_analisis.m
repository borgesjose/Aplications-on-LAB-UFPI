%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% Results analisis cilindrical tank Aplication        %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Main script for test of results analysis of pratical iplementation in
% cilindrical tank

%% Step 7, Saving and ploting results
        
        if (PIDflag)
            ISE_pid  = objfunc(erro,tempo,'ISE')
            ITSE_pid = objfunc(erro,tempo,'ITSE')
            ITAE_pid = objfunc(erro,tempo,'ITAE')
            IAE_pid  = objfunc(erro,tempo,'IAE')
            
            I_pid = esforco_ponderado(erro,u,H,100)
            IG_pid = IG(H,1e4,1e9,1,u,ref,h)
            
            sy_pid= var(h)
            su_pid = var(u)
            
            fileName = ['Resluts for PID - ' ,' - ', Opt_type , ' - ', PIDtype,' - ',ref_type,' - ',simName];
            trail = ['./results/',folderName];
            if (~exist(trail)) mkdir(trail);end   
            save( [trail,'/',fileName])

           [fig1,fig2] =  p_pid(ts,h,ref,u,tempo,Kp,Kd,Ki)
            
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


                 p_ft1(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)

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

                   p_ft1_nl(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)

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
                
                p_ft2(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)
                
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
                
                p_ft2(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)
                
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


                 p_ft1(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)

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

                   p_ft1_nl(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)

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
                
                p_ft2(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)
                
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
                
                p_ft2(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)
                
            end;
            
             
            end
            
        end;