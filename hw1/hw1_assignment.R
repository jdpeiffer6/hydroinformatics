# Section 1: An Example ---------------------------------------------------
test = matrix(nrow = 5, ncol = 4)
test[, 1] = 1:5
test[2:5, 2] = 2:5
test[3:5, 3] = 3:5
test[4:5, 4] = 4:5
test = data.frame(test)
colnames(test) = c("Station1", "Station2", "Station3", "Station4")
rownames(test) = c("Day1", "Day2", "Day3", "Day4", "Day5")

# Questions 1.1-1.4

addNA = function(data_with_some_nas, starting_row) {
  nas = is.na(data_with_some_nas[starting_row:dim(data_with_some_nas)[1],])
  return(apply(nas, 2, sum))
}

# Questions 1.5-1.9

NAs_in_test = test * 0
for (i in 1:dim(test)[1]) {
  NAs_in_test[i,] = addNA(test, i)
}
library(ggplot2)
library(reshape2)
NAs_in_test$date = 1:5
reshaped = melt(NAs_in_test, id.vars = "date")
ggplot(reshaped, aes(x = date, y = value, col = variable)) + geom_line() +
  facet_wrap(~ variable)

# Questions 1.10-1.11

# Section 2: Real data ----------------------------------------------------

setwd("YOUR_DIR_HERE")     #Don't forget to set this to a folder with allprcp
load("allprcp.Rdata")

# Questions 2.1-2.3

data_start_column = #Enter your answer here
  data_stop_column = #Enter your answer here
  rain = allprcp[, data_start_column:data_stop_column]

NAs_in_rain = rain * 0            #Creates output shape
for (i in 1:dim(rain)[1]) {
  #This may take a few minutes
  NAs_in_rain[i,] = addNA(rain, i)
}

NAs_in_rain$date = allprcp$date   #adds date
rain_reshaped = melt(NAs_in_rain, id.vars = "date")
ggplot(rain_reshaped, aes(x = date, y = value, col = variable)) + geom_line() +
  facet_wrap(~ variable)

# Questions 2.4-2.5


# Section 3: Parallel -----------------------------------------------------

NAs_in_rain = rain * 0
system.time({
  for (i in 1:dim(rain)[1]) {
    NAs_in_rain[i,] = addNA(rain, i)
  }
})

# Question 3.1

install.packages("doParallel")
library(doParallel)

registerDoParallel()
getDoParWorkers()

# Question 3.2

system.time({
  NAs_in_rain_par = foreach(i = 1:dim(allprcp)[1],.export = c("addNA",  "rain"),.combine =  "rbind") %dopar% {
    addNA(rain, i)
  }
})

# Question 3.3

NAs_in_rain_par = data.frame(NAs_in_rain_par)
NAs_in_rain_par$date = allprcp$date
rain_reshaped_par = melt(NAs_in_rain_par, id.vars = "date")
ggplot(rain_reshaped_par, aes(x = date, y = value, col = variable)) + geom_line() +
  facet_wrap( ~ variable)

