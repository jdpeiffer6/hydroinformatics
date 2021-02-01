data_col_start=6
data_col_end=12

system.time({sum(is.na(allprcp[,6:12]))})

margin=2
system.time({a=apply(allprcp[,data_col_start:data_col_end],margin,is.na)})

system.time(foreach(i=1:10000) %do% sum(tanh(1:i)))

registerDoParallel(cores=1)
getDoParWorkers()
system.time(foreach(i=1:10000) %dopar% sum(tanh(1:i)))

registerDoParallel(cores=2)
getDoParWorkers()
system.time(foreach(i=1:10000) %dopar% sum(tanh(1:i)))

registerDoParallel(cores=4)
getDoParWorkers()
system.time(foreach(i=1:10000) %dopar% sum(tanh(1:i)))

addNA=function(x,itr){
  #this function adds up all of the NA values in a vector. in this case 
  #we will use it on every column (station) of the dataset!
  nas=is.na(x[itr:dim(x)[1],])
  return(apply(nas,2,sum))
}
missingDate=allprcp[,6:dim(allprcp)[2]]*0     #the matrix we will use to store
#the number of missing values. same size
#the orignal matrix, but without date info at the front
system.time({
  for(i in 1:dim(allprcp)[1]) {       
    #this applies addNA function to every column but changes 
    #the amount of rows it operates on with each iteration of the for loop
    missingDate[i,]=addNA(allprcp[,6:dim(allprcp)[2]],i)
  }
})

registerDoParallel()
features=allprcp[,6:dim(allprcp)[2]]
system.time({
  missingDate3=foreach(i=1:dim(allprcp)[1],.export = c('addNA','features'),.combine = 'data.frame') %dopar% {
  data.frame(addNA(features,i))
}}
)


