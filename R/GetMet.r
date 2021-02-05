library (openair)
library(lubridate)
library(latticeExtra)
library(ggplot2)
# require(devtools)
# install_github('davidcarslaw/worldmet')
library(worldmet)  ## download_met_data
library(mapdata)
dataDir="D:\\Hysplit"

setwd(dataDir)  ### Set the working directory
workingDirectory<<-dataDir  ### Shortcut for the working directory
getMet <- function (year = 2013:2020, month = 1:12, path_met = "D:\\Hysplit\\TrajData\\") {
  for (i in seq_along(year)) {
    for (j in seq_along(month)) {
      download.file(url = paste0("ftp://arlftp.arlhq.noaa.gov/archives/reanalysis/RP",
                                 year[i], sprintf("%02d", month[j]), ".gbl"),
                    destfile = paste0(path_met, "RP", year[i],
                                      sprintf("%02d", month[j]), ".gbl"), mode = "wb")}}}
getMet(year = 2020:2020, month = 9:12) ### GET data for sepecific time