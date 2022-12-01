
    % calculate derivative of the Level
    
    g  = 9.81;
    H  = ; % Altura
    R1 = ; % Raio em metros
    R2 = ; % Raio da base do cilindro
    Cd = ;
    A  = ;
    
    b = A*Cd*sqrt(2*g);

    dh_dt = (Qin - b*y^(1/2))/(R2 + ((R1-R2)/H)*y)^(2);
