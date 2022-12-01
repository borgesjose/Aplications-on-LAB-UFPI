function [h,u]=histeresis_relay(n, Tc, d0, d1, d2, eps);
    
    dmax = d0 + d1;
    dmin = d0 - d2;
    
    for i=1:n,
        y(i)=0;
        ref(i)= 0.3;
    end;
    e(1)=0; e(2)=0; 
    h(1)=0.0 ; h(2)=0.0 ; h(3)=0.0 ; h(4)=0.0; h(5)=0.00;
        load teta.dat
        a1=teta(1);a2=teta(2);b1=teta(3);b2=teta(4);
    u(1)=0 ; u(2)=0 ; u(3)=0 ; u(4)=0; u(5)=dmax;

    for i=5:n,
        
        h(i) = -a1*h(i-3)-a2*h(i-4)+b1*u(i-3)+b2*u(i-4);

       e(i)= ref(i)- h(i);

       if ((abs(e(i))>eps) & (e(i)>0))  u(i+1)=dmax; end;
       if ((abs(e(i))>eps) & (e(i)<0))  u(i+1)=dmin; end;
       if ((abs(e(i))<eps) & (u(i)==dmax))  u(i+1)=dmax; end;
       if ((abs(e(i))<eps) & (u(i)==dmin))  u(i+1)=dmin; end;
       if (e(i)==eps)  u(i+1)=dmax; end;
       if (e(i)==-eps)  u(i+1)=dmin; end;

    end;

end