%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -José Borges do Carmo Neto-         %
% @author José Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% cilindrical tank Control                            %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global SerPIC

epss = [1,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1];

for eps in epss
    
    varlist = {'u','y', 'Tempo'};
    clear(varlist{:})
    clf(figure(1))

    subfolder = ['eps = ',num2str(eps)]
    format shortg;
    subsubfolderName = datestr(clock,'yyyy-mm-dd THH-MM-SS');
    folderName = 'Relay_cilindrical_tank';

    Ts = 1;  %Determinação do período de amostragem
    Tamostra = Ts;

    freq = 3000; %Frequencia de atuação da bomba

    Qde_amostras =400; %Quantidade de amostras do gráfico
    npts = Qde_amostras;

    %%
    %eps=.5;
    %eps=10;
    dh=0.2;
    dl=0.5;
    varlist = {'ref','u','e','y', 'Tempo'};
    clear(varlist{:})
    clf(figure(1))

    %%
    %Previnir erro de leitura
    recebe(1)
    recebe(2)
    recebe(3)

    %zerar PWM
    set_pwm_duty(1,1,freq);

    %%


    for k=1:Qde_amostras 
        ref(k)=1;
    end
    clf(figure(1));
    h = figure(1);
    hLine1 = line(nan, nan, 'Color','red');
    title('Implementação Relé DC');
    xlabel('Tempo (s)');
    ylabel('Leitura Sensor');
     %Inicializa as variáveis gráficas
      k=1;
      y(1)=0 ; y(2)=0; erro(1)=ref(1)-y(1); erro(2)=ref(2)-y(2); u(1)=0; u(2)=0;
      while k<2
          x1 = get(hLine1, 'XData');  
          y1 = get(hLine1, 'YData');  
          k=1;
          x1 = [x1 k*Ts];  
          y1 = [y1 y(k)];  
          set(hLine1, 'XData', x1, 'YData', y1);
          k=k+1;
      end
    u(1)=dh;
    for k=2:Qde_amostras

        y(k) = recebe(2); %Recebe o valor medido de armazena

       e(k) = ref(k)-y(k);
       if ((abs(e(k)) >= eps) & (e(k)  >0))      u(k) =  dh; end;
       if ((abs(e(k)) > eps) & (e(k) < 0))      u(k) = dl; end;
       if ((abs(e(k)) < eps) & (u(k-1) == dh))   u(k) =  dh; end;
       if ((abs(e(k)) < eps) & (u(k-1) == dl))  u(k) = dl; end;
        x1 = get(hLine1, 'XData');  
        y1 = get(hLine1, 'YData');  
        x1 = [x1 k*Ts];  
        y1 = [y1 y(k)];  
        set(hLine1, 'XData', x1, 'YData', y1);  
        Tempo(k) = k*Ts;

        set_pwm_duty(1,u(k),freq);

       pause(Ts);
    end
    %%

     %zerar bombau
     set_pwm_duty(1,1,freq); 

    %Plotar sinal de controle 
    hold on
    plot(Tempo,u,'b');
    plot(Tempo,ref,'g');
    hold off; 

    % Salvar dados:
    trail = ['./results/',folderName,'/',subfolderName,'/',subsubfolderName];
    if (~exist(trail)) mkdir(trail);end   
    save([trail, '/y.dat'],'y', '-ascii')
    save ([trail, '/u.dat'], 'u', '-ascii')
    save([trail, '/Tempo.dat'],'y', '-ascii')
    save ([trail, '/ref.dat'], 'u', '-ascii')
    save([trail, '/e.dat'],'e', '-ascii')

    save([trail, '/dl.dat'],'dl', '-ascii')
    save([trail, '/dh.dat'],'dh', '-ascii')
    save([trail, '/eps.dat'],'eps', '-ascii')  
    
    
end

