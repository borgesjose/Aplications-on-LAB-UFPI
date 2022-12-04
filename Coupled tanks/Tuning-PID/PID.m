function [Kc,Ti,Td] = PID(Ctype),

      if (Ctype == 'ZN')

            Kc = 0.27589;
            Ti =  1.5;
            Td = 0.375;       
        end;
        
        if (Ctype == 'CC')
            Kc = .0001;
            Ti = 0.2;
            Td = 0.079;            
        end;
        
        if (Ctype == 'AT')
            Kc = 0.14045;
            Ti = 4.0125;
            Td = 1.0031;            
            
        end;   
        
        if (Ctype == 'FG')
             
            K = AT_PID_FG(Am,L,a,b,c);
            
            Kc = K(1);
            Ti = Kc/K(2);
            Td = K(3)/Kc;
            
        end; 
        
        if(Ctype == 'PR')
            disp("Selecione um controlador: ZN , CC, AT ") 
            %SINTONIA PROFESSOR:
            Kc = 0.37222;
            Ti = 1.5;
            Td = 0.375;
            %Td = 0.0;
        end; 
   

            