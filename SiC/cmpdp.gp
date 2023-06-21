set xlabel 'mass density (g/cm^3)'
set ylabel 'pressure (GPa)'
    "with open('hugoniot/marsh.dat') as fp: marsh=readHugrho0usup(fp)\n",
    "plt.scatter(marsh[0]['rho'],marsh[0]['p'],label='Marsh')\n",
    "with open('hugoniot/vanthiel.dat') as fp: vanthiel=readHugrho0usup(fp)\n",
    "plt.scatter(vanthiel[0]['rho'],vanthiel[0]['p'],label='van Thiel')\n",
    "#plotfilepts('hugoniot/trunin.dat',ix=3,iy=4,label='Trunin')\n",
    "\n",
    "# models\n",
    'models/leos2130/hugoniot.dat'u 1:6 title 'LEOS 2130'
    "plt.xlabel('density (g/cm^3)'); plt.ylabel('pressure (GPa)')\n",
    "plt.yscale('log')\n",
    "# alt graphs\n",
    "#plt.ylim(bottom=0.1,top=1e4)\n",
    "plt.xlim(left=3.0,right=12.0); plt.ylim(bottom=10.0,top=2e3)\n",
    "# experimental data\n",
    "plotfileerrorbars('ramp/Kim2022_supptab2.dat',ix=5,iy=3,idx=6,idy=4,label='ramp: Kim 2022 pi')\n",
    "# models\n",
    "plotfileline('models/leos2130/isentrope.dat',ix=0,iy=2,label='LEOS 2130')\n",
    "plt.xlabel('density (g/cm^3)'); plt.ylabel('pressure (GPa)')\n",
    "plt.yscale('log')\n",
    "# alt graphs\n",
    "#plt.xlim(left=5,right=35); plt.ylim(bottom=0.1,top=1e3)\n",
    "plt.xlim(left=2,right=20); plt.ylim(bottom=1.0,top=1e4)\n",
    "# experimental data\n",
    "# models\n",
    "plotfileline('models/leos2130/isotherm0k.dat',ix=0,iy=2,label='LEOS 2130')\n",
    "# DFT\n",
    "plotfileline('estruc/castep/cZnS.dat',ix=0,iy=2,label='CASTEP cZnS') \n",
    "plt.xlabel('density (g/cm^3)'); plt.ylabel('specific energy (MJ/kg)')\n",
    "#plt.yscale('log')\n",
    "# alt graphs\n",
    "#plt.xlim(left=5,right=35); plt.ylim(bottom=0.1,top=1e3)\n",
    "plt.xlim(left=3,right=12); plt.ylim(bottom=-650.0,top=-500)\n",
    "# DFT\n",
    "plotfileline('estruc/castep/NaCl.dat',ix=0,iy=1,label='NaCl') \n",
    "plotfileline('estruc/castep/CsCl.dat',ix=0,iy=1,label='CsCl') \n",
    "plotfileline('estruc/castep/cZnS.dat',ix=0,iy=1,label='cZnS') \n",
    "plt.xlabel('density (g/cm^3)'); plt.ylabel('pressure (GPa)')\n",
    "plt.yscale('log')\n",
    "# alt graphs\n",
    "#plt.xlim(left=5,right=35); plt.ylim(bottom=0.1,top=1e3)\n",
    "plt.xlim(left=3,right=12); plt.ylim(bottom=10.0,top=2e3)\n",
    "# DFT\n",
    "plotfileline('estruc/castep/NaCl.dat',ix=0,iy=2,label='NaCl') \n",
    "plotfileline('estruc/castep/CsCl.dat',ix=0,iy=2,label='CsCl') \n",
    "plotfileline('estruc/castep/cZnS.dat',ix=0,iy=2,label='cZnS') \n",
    "plotfileline('estruc/vasp/NaCl-wilson.dat',ix=1,iy=0,label='NaCl VASP') \n",
    "plotfileline('estruc/vasp/Cmcm-wilson.dat',ix=1,iy=0,label='Cmcm VASP') \n",
    "# expt\n",
    "plotfileerrorbars('dac/Kidokoro2017add.dat',ix=4,iy=0,idx=5,idy=1,label='DAC: Kidokoro 2017')\n",
    "plotfileerrorbars('ramp/Kim2022_supptab2.dat',ix=5,iy=1,idx=6,idy=2,label='ramp: Kim 2022 pl')\n",

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
