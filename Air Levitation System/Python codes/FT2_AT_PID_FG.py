# -*- coding: utf-8 -*-
"""
Created on Thu Dec  8 13:17:00 2022

@author: netlu
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


