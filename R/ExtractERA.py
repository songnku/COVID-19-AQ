import netCDF4
import netCDF4 as nc
from netCDF4 import Dataset
import pandas as pd
import numpy as np
import os

xn='London'
lat=51.5
lon=-0.2
timezone=0
os.chdir(r'D:\\COVID-19\\'+xn)
f=Dataset('adaptor.mars.internal-'+xn+'.nc')
for i in f.variables.keys():
    print(i)

def closest(lst, K):  
     lst = np.asarray(lst) 
     idx = (np.abs(lst - K)).argmin() 
     return lst[idx] 
	 
av=closest(list(f.variables['latitude'][:]),lat)
bv=closest(list(f.variables['longitude'][:]),lon)
a=list(f.variables['latitude'][:]).index(av)
b=list(f.variables['longitude'][:]).index(bv)

dtime = netCDF4.num2date(f.variables['time'][:],f.variables['time'].units,calendar=f.variables['time'].calendar)

atm=pd.DataFrame(index=np.array(dtime),
                 data={'ssr':f.variables['ssr'][:,:,a,b][~f.variables['ssr'][:,:,a,b].mask],
                              'tp':f.variables['tp'][:,:,a,b][~f.variables['tp'][:,:,a,b].mask]})
#atm=pd.DataFrame(index=np.array(dtime),
 #                data={'ssr':f.variables['ssr'][:,a,b],
  #                            'tp':f.variables['tp'][:,a,b]})
atm['blh']=np.nan
atm['tcc']=np.nan
atm['sp']=np.nan
atm['blh'].iloc[:-9]=f.variables['blh'][:,:,a,b][~f.variables['blh'][:,:,a,b].mask]
atm['tcc'].iloc[:-9]=f.variables['tcc'][:,:,a,b][~f.variables['tcc'][:,:,a,b].mask]
atm['sp'].iloc[:-9]=f.variables['sp'][:,:,a,b][~f.variables['sp'][:,:,a,b].mask]
#atm['blh'].iloc[:-9]=f.variables['blh'][:,a,b][:-9]
#atm['tcc'].iloc[:-9]=f.variables['tcc'][:,a,b][:-9]
#atm['sp'].iloc[:-9]=f.variables['sp'][:,a,b][:-9]


atm.index.name='date'
atm.index=atm.index.astype('datetime64[ns]')
atm=atm.sort_index()
atm.index=atm.index.shift(timezone, freq='H')
atm.to_csv(xn+'ERA.csv')
