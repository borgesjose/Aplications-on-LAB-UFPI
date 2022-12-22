function [fig1,fig2,fig3,fig4] = p_ft1(ts,h,ref,u,tempo,Kp,Kd,Ki,Am)
        
        fig1 = figure;
        plot(ts,h,'-r','LineWidth', 1,'DisplayName','height'); hold on
        plot(ts,ref,'k:','LineWidth', 1,'DisplayName','reference'); hold off
        ylabel('Tank Height (m)');
        xlabel('Time (s)');
        title('FT1-PID-FG_Resposta_Tanque ')
        saveas(fig1,['./figures/','FT1-PID-FG_Resposta_Tanque','.png'])
        
        fig2 = figure;
        plot(ts,u,'k:','LineWidth', 1,'DisplayName','input'); hold off
        ylabel('Sinal de entrada m³/s');
        xlabel('Time (s)');
        legend();
        title('FT1-PID-FG_Sinal_de_Controle')
        saveas(fig2,['./figures/','FT1-PID-FG_Sinal_de_Controle','.png'])
        
        fig3 = figure;
        grid;
        plot(tempo,Kp,'g-');
        hold on;
        plot(tempo,Kd);
        hold on;
        plot(tempo,Ki);
        title('FT1-PID-FG_Kp,Ki,Kd')
        legend('Kc','Kd','Ki')
        saveas(fig3,['./figures/','FT1-PID-FG_Kp,Ki,Kd','.png'])

        fig4 = figure;
        grid;
        plot(tempo,Am,'g-');
        title('FT1-PID-FG_Am')
        saveas(fig4,['./figures/','FT1-PID-FG_Am','.png'])



end