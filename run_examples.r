source("./calc_doswell.r")

Lab.palette.t<<-colorRampPalette(c("darkblue","blue","lightblue","white","orange","red","darkred"), space = "Lab")

### initialization
#define coordinate grid
xs=seq(-pi/2,pi/2,0.1)
ys=xs
nx=length(xs)
ny=length(ys)

GRID=expand.grid(xs,ys)
X=matrix(GRID[,2],nrow=nx,ncol=ny)
Y=matrix(GRID[,1],nrow=nx,ncol=ny)

#init temperature field
temp0 = matrix(0,nrow=nx,ncol=ny)
temp0 = -tanh(X) #uncurved frontal zone

u0 = u(X,Y)
v0 = v(X,Y)

### integration
nt=100
temps = array(NA,dim=c(ny,nx,nt))
fronto = array(NA,dim=c(ny,nx,nt))
temps[,,1]=temp0
for (i in 2:nt) {
	fronto[,,i-1]=calc_fronto(temps[,,i-1],u0,v0,xs,ys)
	temps[,,i]=int_advection(temps[,,i-1],u0,v0,xs,ys,0.1)
}

### plot
par(mfrow=c(2,4))
par(cex.main=1.8,cex.lab=1.3,cex.axis=1.3)

#init
plot(NA,xlim=range(xs),ylim=range(ys),main='Temperature field -- initialization',xlab='x',ylab='y')
levs=seq(-1,1,length.out=20)
.filled.contour(xs,ys,temp0,levels=levs,col=Lab.palette.t(length(levs)))
arrows(X,Y,X+u0/3,Y+v0/3,length=0.05)

tt=10
plot(NA,xlim=range(xs),ylim=range(ys),main=paste('Temperature field t =',tt),xlab='x',ylab='y')
.filled.contour(xs,ys,temps[,,tt],levels=levs,col=Lab.palette.t(length(levs)))
#contour(xs,ys,temps[,,60],add=T,drawlabels=F,levs=levs,lwd=2)

tt=20
plot(NA,xlim=range(xs),ylim=range(ys),main=paste('Temperature field t =',tt),xlab='x',ylab='y')
.filled.contour(xs,ys,temps[,,tt],levels=levs,col=Lab.palette.t(length(levs)))

tt=30
plot(NA,xlim=range(xs),ylim=range(ys),main=paste('Temperature field t =',tt),xlab='x',ylab='y')
.filled.contour(xs,ys,temps[,,tt],levels=levs,col=Lab.palette.t(length(levs)))


#fronto
tt=0
plot(NA,xlim=range(xs),ylim=range(ys),main=paste('Frontogenesis t =',tt),xlab='x',ylab='y')
levs=seq(-1.2,1.2,length.out=30)
.filled.contour(xs,ys,fronto[,,1],levels=levs,col=Lab.palette.t(length(levs)))
#arrows(X,Y,X+u0/3,Y+v0/3,length=0.05)
tt=10
plot(NA,xlim=range(xs),ylim=range(ys),main=paste('Frontogenesis t =',tt),xlab='x',ylab='y')
.filled.contour(xs,ys,fronto[,,10],levels=levs,col=Lab.palette.t(length(levs)))
#arrows(X,Y,X+u0/3,Y+v0/3,length=0.05)
tt=20
plot(NA,xlim=range(xs),ylim=range(ys),main=paste('Frontogenesis t =',tt),xlab='x',ylab='y')
.filled.contour(xs,ys,fronto[,,20],levels=levs,col=Lab.palette.t(length(levs)))
#arrows(X,Y,X+u0/3,Y+v0/3,length=0.05)
tt=30
plot(NA,xlim=range(xs),ylim=range(ys),main=paste('Frontogenesis t =',tt),xlab='x',ylab='y')
.filled.contour(xs,ys,fronto[,,30],levels=levs,col=Lab.palette.t(length(levs)))
#arrows(X,Y,X+u0/3,Y+v0/3,length=0.05)


