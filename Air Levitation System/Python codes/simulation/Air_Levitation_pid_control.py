# -*- coding: utf-8 -*-
"""
Created on Sat Dec 10 18:32:04 2022

@author: netlu
"""

# ================================================================================== #
# title           :Air_Levitation_PID_control.py                                     #
# description     :Script  PID Air Levitation control                                #
# author          :José Borges                                                       #
# date            :20220105                                                          #
# version         :0.1                                                               #
# @email jose.borges90@hotmail.com                                                   #
# python_version  :3.6                                                               #
# ================================================================================== #

# -*- coding: utf-8 -*-

from IPython import get_ipython
# from pythonping import ping
import requests
import time
import matplotlib.pyplot as plt

from FT1_AT_PID_FG import *

# Limpa o console e apaga todas as variáveis presentes:
try:
    get_ipython().magic('clear')
    # Apaga todas as variáveis:
    # get_ipython().magic('reset -f')
except:
    pass



    
# ENDEREÇOS
ligar = '/Sensor/ON'
medicao = '/Sensor/Medicao'
desligar = '/Sensor/OFF'
pwm = '/Motor?'

# INICIO DO PROCESSO
# TESTE DE CONEXÃO
#teste_servidor()

# TO DO:
    # DEFINIR MEIOS DE DETERMINAR O PERÍODO DE AMOSTRAGEM COM BASE
    # EM UMA MÉDIA DA TAXA DE TRANSFERÊNCIA DO SERVIDOR
    # ATUALMENTE: ENTRE 0.059s e 0.063s (59ms a 63ms) - SERVIDOR ASYNC

# IDEIAS
    # CRIAR UM ATRASO ADAPTATIVO PÓS AQUISIÇÃO DO DADO PARA AJUSTAR AO
    # TEMPO DE AMOSTRAGEM DESEJADO.
    
    # CRIAR UMA MEDIDA PROTETIVA PARA CASO O SERVIDOR DEMORE MAIS QUE O
    # TEMPO DE AMOSTRAGEM PARA ENVIAR O DADO, SEJA FEITA UMA LINEARIZAÇÃO
    # (PREDIÇÃO) COM BASE EM 2 OU MAIS DADOS ANTERIORES, PARA ESTIMAR O
    # DADO PERDIDO E DAR SEGUIMENTO AS MEDIÇÕES.
    
# PERGUNTAS:
    # UTILIZAR O ESP COMO "ACESS POINT", ONDE ESTE CRIA UMA REDE PRÓPRIA
    # E FAZER UMA CONEXÃO PC-ESP SEM O INTERMÉDIO DO ROTEADOR É
    # *CONSIDERAVELMENTE* MAIS VANTAJOSO QUE O ESP COMO WIFI-STATION?
    
# VARIÁVEIS:
Ts = 0.06
alturas = [] # VARIÁVEL DE SAÍDA (y)
controle = [0] # VARIÁVEL DE CONTROLE (u)
amostras = 500
# tempo = []
erro = [0,0]
rate = [0,0]

# x = []

a1 = -0.955255265000912
a2 = -0.029363939258160
b1 = 0.026243849901936
b2 = 0.274777441417530

# Controle
Kp = [0,0];
Kd = [0,0];
Ki = [0,0];

Kc = 0.04028;
Ti = 1.969;
Td = 0.49225;


# amostras = int(input("Defina a quantidade de amostras: "))
# valor_altura = input("Defina o valor de altura em milímetros: ")
patamar = 500
passo = 200
ref = []
for amostra in range(amostras):
    if amostra<=amostras/4:
        ref.append(patamar)
    if amostra>amostras/4:
        ref.append(patamar) 
    if amostra>amostras/2 and amostra<=3*amostras/4:
        ref.append(patamar + passo)
    if amostra>3*amostras/4:
        ref.append(patamar + passo)

valor_altura_float = [float(i) for i in ref]




# set_pwm(pwm, "80")
# time.sleep(1)

# MEDIÇÃO

# PREPARAÇÃO:

k=0;

Am = []
Am_min = 1;        
Am_max = 5;
Theta_m_min = 30;
Theta_m_max = 60;
L = 1
param =  [-L,0,-L,0,L,0,L,-L,0,-L,0,L,0,L]; # Para MF lineares
FT1type = 'L';



k=0
# LAÇO DE AQUISIÇÃO:
for amostra in range(amostras):
    # plt.pause(0.01)
    tempo_inicio_amostra = time.time()
    
    y =-a1*alturas[-1]-a2*alturas[-2]+b1*controle[-1]+b2*controle[-2];
    
    alturas.append(int(y))
    print("--- %s seconds ---" % (time.time() - tempo_inicio_amostra))
    
 
    
    # MALHA FECHADA
    erro.append((valor_altura_float[k] - alturas[-1])/10)
    

   # Controlador:
       
    #Am.append(gain_margin_t1(erro[-1],rate[-1],L,param,FT1type));
    
    Ami = 1;
    
    Kp.append(Kc/Ami);
    Kd.append((Td)*Kc/Ami)
    Ki.append((Kc/Ami)/(Ti))

    alpha = (Kc/Ami)*(1+((Td)/Ts)+(Ts/(2*(Ti))));
    beta = -(Kc/Ami)*(1+2*((Td)/Ts)-(Ts/(2*(Ti))));
    gama = (Kc/Ami)*(Td)/Ts;

               
    u = controle[-1] + alpha*erro[-1] + beta*erro[-2] + gama*erro[-3];

    controle.append(u)
    
    # SATURAÇÃO 
    if controle[-1] > 80:
        controle[-1] = 80
    elif controle[-1] < 47:
        controle[-1] = 47

    #set_pwm(pwm, controle[-1])
        
    # tempo.append(amostra*Ts)
    # time.sleep(Ts - (time.time() - tempo_inicio_amostra)) # Atraso adaptativo?
    
    # x.append(amostra)
    # plt.plot(x, alturas, 'r')
    # plt.title("Teste")
    k=k+1;
    
      
# PÓS AQUISIÇÃO
total = time.time() - tempo_inicio_laco
print("\n===============================================")
print("--- Total: %s seconds ---" % total)
print(f"--- Média: {total/amostras} segundos/amostra")
print("===============================================\n")
pos_medicao(desligar)

#set_pwm(pwm, "0")

# PLOTAGEM
#plt.plot(list(range(amostras)), valor_altura_float, 'b')
#plt.plot(list(range(amostras)), alturas, 'r')
plt.plot( alturas)
plt.plot(ref)
plt.ylabel('Altura do objeto (mm)')
plt.xlabel('Número da amostra')
# plt.xlabel('Tempo')
plt.title("Altura desejada: " + str(valor_altura_float[-1]) + "mm")
plt.show()

plt.plot(list(range(amostras)), controle[:-1], 'g')
# plt.plot(tempo, alturas)
plt.ylabel('Variável de controle')
plt.xlabel('Número da amostra')
# plt.xlabel('Tempo')
plt.title("Controle - Altura desejada: " + str(valor_altura_float[-1]) + "mm")
plt.show()