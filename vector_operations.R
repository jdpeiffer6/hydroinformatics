# Vector Operations -------------------------------------------------------
a=1:10
b=rep(1,10)

a+b
a+1
a*2
tan(a)

# Data --------------------------------------------------------------------
lat1=rnorm(5)
phi <- (pi/180)*lat1
df1 <- data.frame(matrix(NA, nrow = 7, ncol = 5))

# Double for loop ---------------------------------------------------------
for(i in 1:7){    #row
  for(j in 1:5){  #col
    df1[i,j]=100*tan(phi[j])*i
  }
}
df1

# Vector operations -------------------------------------------------------
df2=df1*0
df2
for(i in 1:7){
  df2[i,]=100*tan(phi)*i
}
df2

df2==df1