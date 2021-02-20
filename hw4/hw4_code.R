# Section 3 ---------------------------------------------------------------
addNA = function(data_with_some_nas, starting_row) {
  nas = is.na(data_with_some_nas[starting_row:dim(data_with_some_nas)[1], ])
  return(apply(nas, 2, sum))
}

load("allprcp.Rdata")
dim(allprcp)

data_start_column = 6
data_stop_column = dim(allprcp)[2]
  
rain = allprcp[, data_start_column:16]

sum(is.na(rain))

NAs_in_rain = rain * 0

print("1 Core")
system.time({
  for (i in 1:dim(rain)[1]) {
    NAs_in_rain[i, ] = addNA(rain, i)
  }
})

print("Parallel")
#install.packages("doParallel")
library(doParallel)
registerDoParallel(cores=2)
getDoParWorkers()
NAs_in_rain = rain * 0
system.time({
  NAs_in_rain_par = foreach(i = 1:dim(allprcp)[1], 
                            .export = c("addNA", "rain"), 
                            .combine = "rbind") %dopar% {
                              addNA(rain, i)
                            }
})

registerDoParallel(cores=4)
getDoParWorkers()
NAs_in_rain = rain * 0
system.time({
  NAs_in_rain_par = foreach(i = 1:dim(allprcp)[1], 
                            .export = c("addNA", "rain"), 
                            .combine = "rbind") %dopar% {
                              addNA(rain, i)
                            }
})
