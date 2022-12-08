# -*- coding: utf-8 -*-
"""
Created on Wed Dec  7 12:11:19 2022

@author: jose borges
"""
import math 


def tri_mf_t1(x,param):
    
    a = param[0]
    b = param[1]
    c = param[2]
    
    y = max(min((x-a)/(b-a),(c-x)/(c-b)),0)
    
    return y


def Rshoulder_mf_t1(x,param):
    
    c = param[0];   
    d = param[1];

    y = max(min((1,(d-x)/(d-c))),0);
    
    return y


def Lshoulder_mf_t1(x,param):
    
    a = param[0];
    b = param[1];
    
    
    y = max(min(((x-a)/(b-a),1)),0);

    return y    

def gauss_mf_t1(x,param):
    
    rho = param[0];
    m = param[1];
    
    y = math.exp(-(1/2)*((x-m)/rho)**2)
    
    return y
    
    
def sigmoid_mf_t1(x,param):

    a = param[0];
    c = param[1];
    
    y = 1/(1 + math.exp(-a*(x-c)))   
    
    return y



def inferencia_t1_3X3(pert_erro,pert_rate):
    
    
    R1 = pert_erro[0]*pert_rate[0]
    
    R2 =pert_erro[0]*pert_rate[1]
    
    R3= pert_erro[0]*pert_rate[2]
    
    R4 = pert_erro[1]*pert_rate[0]
    
    R5 =pert_erro[1]*pert_rate[1]
    
    R6= pert_erro[1]*pert_rate[2] 
    
    R7 = pert_erro[2]*pert_rate[0]
    
    R8 =pert_erro[2]*pert_rate[1]
    
    R9= pert_erro[2]*pert_rate[2]
    
    
    
    output = R1*(math.exp(-R1*4)) + R2*(math.exp(-R2*4)) + R3*(math.exp(-R3*4))+ R4*(1 - math.exp(-R4*4)) + R5*(1 - math.exp(-R5*4)) + R6*(1 - math.exp(-R6*4))+ R7*(math.exp(-R7*4)) + R8*(math.exp(-R8*4)) + R9*(math.exp(-R9*4));

    return output
    
def gain_margin_t1(erro,rate,L,param,Itype):
    
    if Itype == 'L':
        
        param_erro_N = param[0:2];
        param_erro_Z = param[2:5];
        param_erro_P = param[5:7];

        param_rate_N = param[7:9];
        param_rate_Z = param[9:12];
        param_rate_P = param[12:14];

        #Funções de pertinencia para o erro:
        erro_N = Rshoulder_mf_t1(erro,param_erro_N);
        erro_Z = tri_mf_t1(erro,param_erro_Z); 
        erro_P = Lshoulder_mf_t1(erro,param_erro_P);

        # Funções de pertinencia para o rate:
        rate_N = Rshoulder_mf_t1(erro,param_rate_N);
        rate_Z = tri_mf_t1(erro,param_rate_Z);
        rate_P = Lshoulder_mf_t1(erro,param_rate_P);

    elif Itype == 'N':

        param_erro_N = param[0:2];
        param_erro_Z = param[2:4];
        param_erro_P = param[4:6];

        param_rate_N = param[6:8];
        param_rate_Z = param[8:10];
        param_rate_P = param[10:12];

        #Funções de pertinencia para o erro:
        erro_N = 1-sigmoid_mf_t1(erro,param_erro_N);
        erro_Z = gauss_mf_t1(erro,param_erro_Z); 
        erro_P = sigmoid_mf_t1(erro,param_erro_P);

        # Funções de pertinencia para o rate:
        rate_N = 1-sigmoid_mf_t1(erro,param_rate_N);
        rate_Z = gauss_mf_t1(erro,param_rate_Z);
        rate_P = sigmoid_mf_t1(erro,param_rate_P);

    Am =  inferencia_t1_3X3([erro_N,erro_Z,erro_P],[rate_N,rate_Z,rate_P]);

    return Am    


    

