library(openair)
library(plyr)
library(dplyr)
library(rmweather)
library(ranger)
library(readxl)  
#please install the requaired (above) packages first

filename="Beijing_Urban" #model inputs file
polllist<-list("co","o3","no2") #run each pullutant one by one
ncal=100 #ncal: modeling using different seeds and select a model with highest model performance

Dataraw1 <- read_excel(paste(filename,".xlsx",sep=''), 
                                    sheet = "Sheet1", col_types = c("date", 
                                                                      "numeric", "numeric", "text", 
                                                                      "numeric", "numeric", "numeric", 
                                                                      "numeric", "numeric", "numeric", 
                                                                      "numeric", "numeric", "text", 
                                                                "numeric", "numeric", "numeric", "numeric","numeric",
                                                                      "numeric", "numeric", "numeric", 
                                                                      "numeric", "numeric", "numeric", "numeric")) #Can also use import csv function
#Dataraw1: all dataset
Dataraw1$cluster<-as.factor(Dataraw1$cluster) #set back trajectory as category
Dataraw1$weekday<-as.factor(Dataraw1$weekday) #set weekday as category
Dataraw1 <- Dataraw1 %>% filter(!is.na(cluster))
Dataraw <-  Dataraw1 %>% filter(date>="2019-12-01"& date <= "2020-05-31") #Dataraw: selected dataset for model training and weather normalisation

for (poll in polllist){
r.min <- 0.1
perform<-matrix(data=NA,ncol=11,nrow=1)
colnames(perform)<-c("default","n", "FAC2","MB", "MGE", "NMB", "NMGE", "RMSE", "r","COE", "IOA")
for (i in as.numeric(1:ncal)){
set.seed(i) 
data_prepared <- Dataraw %>% 
  filter(!is.na(ws)) %>% 
  dplyr::rename(value = poll) %>% 
  rmw_prepare_data(na.rm = TRUE,fraction = 0.7)

set.seed(i) 
RF_model <- rmw_do_all(
  data_prepared,
  variables = c(
    "date_unix","day_julian", "weekday","hour", "temp",  "RH", "wd", "ws","sp","cluster","tp","blh","tcc","ssr"), #factors for random forest modeling
    variables_sample=c("temp",  "RH", "wd", "ws","sp","cluster","tp","blh","tcc","ssr"), #factors for weather relpacement
  n_trees = 300,
  n_samples = 300,min_node_size = 3,n_samples = 1000,
  verbose = TRUE
)

testing_model <- rmw_predict_the_test_set(model = RF_model$model,df = RF_model$observations) 
model_performance<-modStats(testing_model, mod = "value", obs = "value_predict", 
statistic = c("n", "FAC2","MB", "MGE", "NMB", "NMGE", "RMSE", "r","COE", "IOA"),
                                           type = "default", rank.name = NULL)
																	   
perform<-rbind(perform,model_performance)
if (model_performance$r > r.min){
r.min <- model_performance$r
RF_modelo <- RF_model}
} 
save.image(file = paste(filename,"_",poll,"_RW",".RData",sep=""))
write.table(perform, file=paste(filename,"_",poll,"_RWPerformance",".csv",sep=""), sep=",", row.names=FALSE)
}


