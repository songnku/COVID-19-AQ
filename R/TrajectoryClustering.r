library (openair)
library(lubridate)
library(latticeExtra)
library(ggplot2)
# require(devtools)
# install_github('davidcarslaw/worldmet')
library(worldmet)  ## download_met_data
#library(mapdata)
#dataDir="~/Hysplit/TrajProc/"
#setwd(dataDir)  ### Set the working directory
#workingDirectory<<-dataDir  ### Shortcut for the working directory



Rall<-read.csv('BeijingDectoMaysince2015.csv',header=T)
Rall$date<-as.POSIXct(Rall$date)
Rall$date2<-as.POSIXct(Rall$date2)
trajCityc<-trajCluster(Rall, method="Euclid",n.cluster= 12)#Or use method="Angle"
trajCitydata<-trajCityc$data
write.csv(trajCitydata,"trajCitydat_BeijingDectoMaysince2015Euclid.csv")