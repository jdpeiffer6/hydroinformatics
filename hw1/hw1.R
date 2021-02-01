# Generate Data ----------------------------------------------------------------

test=matrix(nrow=5,ncol=4)
test[,1]=1:5
test[2:5,2]=2:5
test[3:5,3]=3:5
test[4:5,4]=4:5

test=data.frame(test)
colnames(test)=c("Station1","Station2","Station3","Station4")
rownames(test)=c("Day1","Day2","Day3","Day4","Day5")

View(test)


# Quantify NA -------------------------------------------------------------
addNA=function(data_with_some_nas,starting_row){
  nas=is.na(data_with_some_nas[starting_row:dim(data_with_some_nas)[1],])
  return(apply(nas,2,sum))
}

NAs_in_test=test*0
for(i in 1:dim(test)[1]){
  NAs_in_test[i,]=addNA(test,i)
}

library(ggplot2)
library(reshape)
NAs_in_test$date=1:5
reshaped=melt(NAs_in_test,id.vars="date")
ggplot(reshaped,aes(x=date,y=value,col=variable))+geom_line()+facet_wrap(~variable)


# Bigger Data -------------------------------------------------------------

load("allprcp.Rdata")
View(allprcp)

data_start_column=6
data_stop_column=12

rain=allprcp[,data_start_column:data_stop_column]

NAs_in_rain=rain*0

for(i in 1:dim(rain)[1]){
  NAs_in_rain[i,]=addNA(rain,i)
}


NAs_in_rain$date=allprcp$date
rain_reshaped=melt(NAs_in_rain,id.vars="date")
ggplot(rain_reshaped,aes(x=date,y=value,col=variable))+geom_line()+facet_wrap(~variable)



# Parallelize -------------------------------------------------------------

#without parallel
system.time({
  for(i in 1:dim(rain)[1]){
    NAs_in_rain[i,]=addNA(rain,i)
  }
})
  
