par <- read.csv2("Paracou 15.csv",header=T)
p15.spp<-spp(par$X,par$Y,window=c(0,0,250,250),marks=par$PointType)
nsp<-nlevels(p15.spp$marks)
plot(p15.spp,legend=F,chars=rep("•",nsp),cols=palette(rainbow(nsp)))
system.time(test<-ksfun(p15.spp,125,1,1000))
plot(test)
