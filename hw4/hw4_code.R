# Section 3: Load and Characterize Data ---------------------------------------------------------------

load("allprcp.Rdata")
dim(allprcp)

data_start_column = 6
data_stop_column = dim(allprcp)[2]
  
rain = allprcp[, data_start_column:data_stop_column]

sum(is.na(rain))


# Section 4: Quantify NAs in Serial ---------------------------------------------------------------
addNA = function(data_with_some_nas, starting_row) {
  nas = is.na(data_with_some_nas[starting_row:dim(data_with_some_nas)[1], ])
  return(apply(nas, 2, sum))
}

print("1 Core")
NAs_in_rain = rain * 0
system.time({
  for (i in 1:dim(rain)[1]) {
    NAs_in_rain[i, ] = addNA(rain, i)
  }
})

# Section 5: Quantify NAs in Parallel -------------------------------------
print("Parallel")
#install.packages("doParallel")
library(doParallel)
registerDoParallel(cores=2)
getDoParWorkers()
system.time({
  NAs_in_rain_par2 = foreach(i = 1:dim(allprcp)[1], 
                             .export = c("addNA", "rain"), 
                             .combine = "rbind") %dopar% {
                               addNA(rain, i)
                             }
})

registerDoParallel(cores=4)
getDoParWorkers()
system.time({
  NAs_in_rain_par4 = foreach(i = 1:dim(allprcp)[1], 
                            .export = c("addNA", "rain"), 
                            .combine = "rbind") %dopar% {
                              addNA(rain, i)
                            }
})

registerDoParallel(cores=6)
getDoParWorkers()
system.time({
  NAs_in_rain_par6 = foreach(i = 1:dim(allprcp)[1], 
                             .export = c("addNA", "rain"), 
                             .combine = "rbind") %dopar% {
                               addNA(rain, i)
                             }
})

registerDoParallel(cores=8)
getDoParWorkers()
system.time({
  NAs_in_rain_par8 = foreach(i = 1:dim(allprcp)[1], 
                             .export = c("addNA", "rain"), 
                             .combine = "rbind") %dopar% {
                               addNA(rain, i)
                             }
})


# Section 6: Plot ---------------------------------------------------------

library(ggplot2)
sumgt=function(x){            #simply adds up number of stations with less than lessThan missing days
  #this is what we will consider to be "too many" missing days
  lessThan=500
  return(sum(x<lessThan))
}
lthan=500

missings=apply(NAs_in_rain_par8,1,sumgt) 
missings=data.frame(missings,date=as.Date(allprcp$date))   #plots things
ggplot(data=missings,aes(x=date,y=missings,group=1))+geom_line(col="blue",size=2)+scale_x_date(date_labels = "%Y")+
  labs(x="Date of cutoff", y=paste('Sites with less than', lthan,'\nmissing days'),title="Cutoff date vs Missing Days")+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))

