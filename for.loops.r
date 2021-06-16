#A few examples of for loops


#Our goal is to simulate sim.n datasets with sample size each of n
sim.n=10
n=5

#Let's simulate a single dataset
rnorm(n,0,2)

#We need to replcate this sim.n times


#setup a variable to store results
storage=NULL

#Setup the basic for loop structre (THIS DOES NOTHING)
# z is an index or counter that will count from 1:sim.n or
# 1  2  3  4  5  6  7  8  9 10
for(z in 1:sim.n){
  #DO SOMETHING sim.n times HERE
}

#PUT contents within th for loop
for(z in 1:sim.n){
  temp=rnorm(n,0,2)
  storage=rbind(storage,temp) 
}

#the output is sim.n by sim
dim(storage)

storage
######################################
#Do the same thing but lets be more specific about how we 
#want to store values

#create storage as a matrix
storage2=matrix(NA,nrow=sim.n,ncol=n)

#store each simulated data set as a specific row of strorage 2
for(z in 1:sim.n){
  storage2[z,]=rnorm(n,0,2)
}

storage2

#the output is sim.n by sim
dim(storage2)

######################################
######################################
#Compare vectorized code with a for loop

#for each row of storage, lets calcualte a mean and print it out
for(z in 1:sim.n){
  print(mean(storage[z,]))
}

#The same as above, but store the values
mean.storage=NULL
for(z in 1:sim.n){
  mean.storage=c(mean.storage,mean(storage[z,]))
}
mean.storage

#Let's do the same thing with apply
#"1' indicates to do the function on the rows and "mean" is the function
#we want to do
apply(storage,1,mean)

#Generally- vectorized functions are faster than for loops

############################################
############################################
#If we need to do a for loop and each operation take a while, 
#we can speed things up by using multiple computer processors 
#at the same time (parallelized execution). The speed depands
#on several factors- e.g., # of CPU's in the computer

#load packages to do parallel for loop
library(foreach)
library(doParallel)

#tell R how many processors to use
cores=detectCores()
#Make a cluster of processors that R can use
cl <- makeCluster(cores[1]-1) #not to overload your computer
registerDoParallel(cl)

#WE will use the simulated data from storage2
#and fit a linear model with only an intercet to each dataset

out.parallel<-foreach(i=1:sim.n,.multicombine = TRUE)%dopar%{
            
                    y=storage2[i,]    
                    fit=lm(y~1)    
                    fit$coefficients
            }
#stop cluster
stopCluster(cl)

#The output is a list, each element is one model fit using one row
#of storage2
out.parallel

