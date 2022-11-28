function ref = ref_def_sin(patamar,amp,f,nptos,Ts),
    t=0:Ts:nptos
    ref = patamar + amp*sin(2*pi*f*t)
end