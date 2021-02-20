# Section 3 ---------------------------------------------------------------

load("allprcp.Rdata")
dim(allprcp)

data_start_column = 6
data_stop_column = dim(allprcp)[2]
  
rain = allprcp[, data_start_column:data_stop_column]

sum(is.na(rain))

NAs_in_rain = rain * 0
system.time({
  for (i in 1:dim(rain)[1]) {
    NAs_in_rain[i, ] = addNA(rain, i)
  }
})
