# Section 3 ---------------------------------------------------------------
addNA = function(data_with_some_nas, starting_row) {
  nas = is.na(data_with_some_nas[starting_row:dim(data_with_some_nas)[1], ])
  return(apply(nas, 2, sum))
}

load("allprcp.Rdata")
dim(allprcp)

data_start_column = 6
data_stop_column = dim(allprcp)[2]
  
rain = allprcp[, data_start_column:8]

sum(is.na(rain))

NAs_in_rain = rain * 0
system.time({
  for (i in 1:dim(rain)[1]) {
    NAs_in_rain[i, ] = addNA(rain, i)
  }
})
