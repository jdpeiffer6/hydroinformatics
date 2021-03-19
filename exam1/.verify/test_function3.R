par(mfrow=c(2,1))
par(mar=c(5-3, 4,4-3, 2) + 0.1)
beginning_plot=100
end_plot=150
plot(rain[beginning_plot:end_plot,1],type="l",ylab="Rainfall")
title("Original")
plot(rain_smooth[beginning_plot:end_plot,1],type="l",ylab="Rainfall")
title("Smoothed")
load(".verify/check_rain.Rdata")
if(sum(rain_smooth_par[,1]-check_rain[,1],na.rm=TRUE)==0){
  print("3) Congrats! Your solution worked!")
  png("par_output.png")
  par(mfrow=c(2,1))
  par(mar=c(5-3, 4,4-3, 2) + 0.1)
  plot(rain[beginning_plot:end_plot,1],type="l",ylab="Rainfall")
  title("Original")
  plot(rain_smooth[beginning_plot:end_plot,1],type="l",ylab="Rainfall")
  title("Parallel Smoothed")
  dev.off()
}else{
  print("Try Again!")
}
