global SerPIC
fclose(SerPIC); %--close the serial port when done
delete(SerPIC);
delete(instrfind); 
