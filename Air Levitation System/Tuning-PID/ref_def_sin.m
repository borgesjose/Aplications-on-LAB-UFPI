function ref = ref_def_sin(patamar,amp,f,nptos,npts,Qde_amostras),
    t = linspace(0,Qde_amostras,npts)
    ref = patamar + amp*sin(2*pi*f*t)
end