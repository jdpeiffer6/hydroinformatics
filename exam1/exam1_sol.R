#make sure you set your working dir to the directory 
#with this script in it.
setwd("")
# A) Develop a function and test ------------------------------------------
load(".verify/verification_data.Rdata")
smoother = function(input, index, width) {
  output=input*0
  left = index - ((width - 1) / 2)
  right = index + ((width - 1) / 2)
  if (left < 1) {
    left = 1
  } else if (right > length(input)) {
    right = length(input)
  }
  return(mean(input[left:right], na.rm = TRUE))
}

my_smooth = rep(0, length(y))
for (i in 1:length(y)) {
  my_smooth[i] = smoother(y, i, 5)
}

#Run this to check part A
source(".verify/test_function.R")

# B) Apply function to rain data ------------------------------------------
rain = read.csv("precipitation.daily.88gages.1950.to.2017.csv")
rain = rain[, 1:8]
rain_smooth = rain * 0
system.time({
  for (i in 1:dim(rain)[1]) {
    rain_smooth[i, ] = apply(rain,2,FUN = smoother,index = i,width = 5)
  }
})

#Run this to check part B
source(".verify/test_function2.R")

# C) Accelerate -----------------------------------------------------------
library("doParallel")

registerDoParallel(cores = 2)
getDoParWorkers()
system.time({
  rain_smooth_par = foreach(i = 1:dim(rain)[1],.export = c("smoother", "rain"),.combine = "rbind"
  ) %dopar% {
    apply(rain,2,FUN = smoother,index = i,width = 5)
  }
})

#Run this to check part C
source(".verify/test_function3.R")
