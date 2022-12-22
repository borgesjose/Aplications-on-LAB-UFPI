function [fig1,fig2] = p_pid(ts,h,ref,u,tempo,Kp,Kd,Ki)

        fig1 = figure;
        plot(ts,h,'-r','LineWidth', 1,'DisplayName','height'); hold on
        plot(ts,ref,'k:','LineWidth', 1,'DisplayName','reference'); hold off
        ylabel('Tank Height (m)');
        xlabel('Time (s)');
        title(['Resposta Tanque PID '])
        trail = ['./figures'];
        if (~exist(trail)) mkdir(trail);end 
        saveas(gcf,['./figures/','Resposta Tanque PID ','.png'])
        
        fig2 = figure;
        plot(ts,u,'k:','LineWidth', 1,'DisplayName','input'); hold off
        ylabel('Sinal de entrada m³/s');
        xlabel('Time (s)');
        legend();
        title(['Sinal de Controle PID '])
        saveas(gcf,['./figures/','Sinal de Controle PID ','.png'])
        %


end