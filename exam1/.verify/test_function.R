par(mfrow=c(3,1))
par(mar=c(5-3, 4,4-3, 2) + 0.1)
plot(x,y,type="l")
title("Original")
plot(x,y_smooth,type="l")
title("Desired smoothing")
plot(x,my_smooth,type="l")
title("Your smoothing")

if(sum(my_smooth-y_smooth)==0){
  print("1) Congrats! Your function works!")
}else{
  print("Try again!")
}