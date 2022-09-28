function y = set_pwm_duty(canal,duty,freq)
global SerPIC

if (canal==1)
if (freq == 3000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%X', 1);
duty = int16((250)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 6000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%X', 2);
duty = int16((125)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 

end

elseif (freq == 12000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%X', 3);
duty = int16((250)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 24000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%X', 4);
duty = int16((125)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 48000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%X', 5);
duty = int16((250)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 60000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%X', 6);
duty = int16((200)*duty);
if(duty<=15)
fprintf(SerPIC, '%X',0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c',dec2hex(duty)); 
end

elseif (freq == 96000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%X', 7);
duty = int16((125)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
duty = dec2hex(duty);
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 120000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%X', 8);
duty = int16((100)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end
else
    disp('Frequencia inválida. Parametros aceitos(3000, 6000, 12000, 24000, 48000, 60000, 96000, 120000).')
end

end

if (canal==2)
    if (freq == 3000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%X', 9);
duty = int16((250)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 6000)
fprintf(SerPIC, '%X', 0);     
fprintf(SerPIC, '%c', dec2hex(10));
duty = int16((125)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 12000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c',dec2hex(11));
duty = int16((250)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
duty = dec2hex(duty);
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 24000)
fprintf(SerPIC, '%X',0); 
fprintf(SerPIC, '%c', dec2hex(duty));
duty = int16((125)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
duty = dec2hex(duty);
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 48000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(13));
duty = int16((250)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 60000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(14));
duty = int16((200)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c',dec2hex(duty)); 
end

elseif (freq == 96000)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c',dec2hex(15));
int16((125)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end

elseif (freq == 120000)
fprintf(SerPIC, '%c', dec2hex(16));
duty = int16((100)*duty);
if(duty<=15)
fprintf(SerPIC, '%X', 0); 
fprintf(SerPIC, '%c', dec2hex(duty));
else  
fprintf(SerPIC, '%c', dec2hex(duty)); 
end
else
    disp('Frequencia inválida. Parametros aceitos(3000, 6000, 12000, 24000, 48000, 60000, 96000, 120000).')
    end


end
