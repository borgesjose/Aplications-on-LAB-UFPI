
function y = recebe(canal)
global SerPIC
global a
global b
switch canal

    case 1,
fprintf(SerPIC,'%c',dec2hex(17)); 
a = str2double(fgets(SerPIC));
y=a*4.34/1023;

    case 2,
fprintf(SerPIC, '%c', dec2hex(18));
b = str2double(fgets(SerPIC));
y=b*4.34/1023;

    case 3,
fprintf(SerPIC, '%c', dec2hex(19));
b = str2double(fgets(SerPIC));
y=b*4.34/1023; 
  
%otherwise
% disp('Canal desconhecido')

end
