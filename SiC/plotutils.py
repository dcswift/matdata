import numpy as np
import matplotlib.pyplot as plt

def read(chan,ix,iy): # read tabular x,f array from channel, choosing column indices (base 0)
    xf=[]
    for line in chan:
        words=line.split()
        if len(words)>max(ix,iy) and not words[0].startswith('#'): xf+=[[float(words[ix]),float(words[iy])]]
    return xf

def readtable(chan): # read tabular array from channel
    xf=[]
    for line in chan:
        words=line.split()
        if len(words)>0 and not words[0].startswith('#'):
           vals=[]
           for word in words: vals+=[float(word)]
           xf+=[vals]
    return xf

def readHugrho0usup(chan,irho0=3,ius=5,iup=6): # read Hugoniot data to find rho0,us,up
# default cols for Marsh
# gnuplot-like in that treats 2+ blank lines as break between indexed sets
    hugsets=[]
    nblank=0; iset=-1
    for line in chan:
        words=line.split()
        if len(words)==0: nblank+=1
        elif len(words)>2 and not words[0].startswith('#'):
            if iset<0 or nblank>1:
               iset+=1
               hug={'rho0':[],'up':[],'us':[],'rho':[],'p':[],'e':[]}
               hugsets+=[hug]
            nblank=0
            try:
               rho0=float(words[irho0]); us=float(words[ius]); up=float(words[iup])
               rho=rho0*us/(us-up); p=rho0*us*up; e=(1/rho0-1/rho)*p/2
               hug['rho0']+=[rho0]
               hug['us']+=[us]
               hug['up']+=[up]
               hug['rho']+=[rho]
               hug['p']+=[p]
               hug['e']+=[e]
            except ValueError:
               #print(words)
               irho0=words.index('rho0'); ius=words.index('us'); iup=words.index('up')
               #print('rho0',irho0,'us',ius,'up',iup)
    return hugsets

def readcompauto(chan,rhoscale=1.0,pscale=1.0): # read Hugoniot data as rho0,p,v/v0 from channel and return rho,p array
    xf=[]
    irho0=ivv0=ip=-1
    for line in chan:
        words=line.split()
        if len(words)>3 and 'rho0' in words: # interpret as column headers for this block
            irho0=words.index('rho0')-1; ivv0=ip=-1 # -1 to account for #
            for i,word in enumerate(words):
                if word=='p': ip=i-1
                elif word=='v/v0': ivv0=i-1
        elif min(irho0,ivv0,ip)>=0 and len(words)>max(irho0,ivv0,ip) and not words[0].startswith('#') and min(irho0,ivv0,ip)>=0:
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

def plotfileerrorbars(filename,ix=0,iy=2,idx=1,idy=3,label=""):
    with open(filename) as fp: fdat=np.transpose(readtable(fp))
    if label=='': plt.errorbar(fdat[ix],fdat[iy],xerr=fdat[idx],yerr=fdat[idy],fmt='o')
    else: plt.errorbar(fdat[ix],fdat[iy],xerr=fdat[idx],yerr=fdat[idy],fmt='o',label=label)
