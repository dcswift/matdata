import numpy as np
import matplotlib.pyplot as plt

def check(): print(dir(np))

def read(chan,ix,iy): # read tabular x,f array from channel, choosing column indices (base 0)
    xf=[]
    for line in chan:
        words=line.split()
        if len(words)>max(ix,iy) and not words[0].startswith('#'): xf+=[[float(words[ix]),float(words[iy])]]
    return xf

def readcompauto(chan,rhoscale=1.0,pscale=1.0): # read Hugoniot data as rho0,p,v/v0 from channel and return rho,p array
    xf=[]
    irho0=ivv0=ip=-1
    for line in chan:
        words=line.split()
        if len(words)>3 and words[0]=='#rho0': # interpret as column headers for this block
            irho0=0; ivv0=ip=-1
            for i,word in enumerate(words):
                if word=='p': ip=i
                elif word=='v/v0': ivv0=i
        elif len(words)>max(irho0,ivv0,ip) and not words[0].startswith('#') and min(irho0,ivv0,ip)>=0:
            if words[irho0]!='-': rho0=float(words[irho0]) # else use previous value
            vsc=float(words[ivv0]); p=float(words[ip])
            xf+=[[rho0/vsc*rhoscale,p*pscale]]
    return xf

def plotfileline(filename,ix=0,iy=1,label=""):
    with open(filename) as fp: fdat=np.transpose(read(fp,ix,iy))
    if label=='': plt.plot(fdat[0],fdat[1])
    else: plt.plot(fdat[0],fdat[1],label=label)

def plotfilepts(filename,ix=0,iy=1,label=""):
    with open(filename) as fp: fdat=np.transpose(read(fp,ix,iy))
    if label=='': plt.scatter(fdat[0],fdat[1])
    else: plt.scatter(fdat[0],fdat[1],label=label)
