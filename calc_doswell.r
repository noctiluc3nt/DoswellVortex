## Doswell Vortex
library(pracma)

#======= Doswell (1984) vortex =========

#' tangential wind (Eq. 9)
#' @input r radius (distance from origin)
#' @return tangential velocity
v_tan = function(r) {
	return(sech(r)^2*tanh(r)) #doswell, 1984
}

#' zonal wind (Eq. 10a)
#' @ input x coordinate
#' @ input y coordinate
#' @ return zonal wind at (x,y)
u = function(x,y) {
	theta = atan2(y,x)
	r = sqrt(x^2+y^2)
	return(-v_tan(r)*sin(theta)) 
}

#' meridional wind (Eq. 10b)
#' @ input x coordinate
#' @ input y coordinate
#' @ return meridional wind at (x,y)
v = function(x,y) {
	theta = atan2(y,x)
	r = sqrt(x^2+y^2)
	return(v_tan(r)*cos(theta))
}



# ======== numerics ====================

#' x derivative (finite differences)
#' @input temp field to calculate derivative of
#' @input xs vector containing x coordinates
#' @input ys vector containing y coordinates
df_dx = function(temp,xs,ys) {
	n=length(xs)
	m=length(ys)
	temp_new=temp
	for (i in 2:(n-1)) {
		temp_new[,i] = (temp[,i+1]-temp[,i-1])/(xs[i+1]-xs[i-1])
	}
	#boundaries
	temp_new[,1]=(temp[,2]-temp[,1])/(xs[2]-xs[1])
	temp_new[,n]=(temp[,n]-temp[,n-1])/(xs[n]-xs[n-1])
	return(temp_new)
}

#' y derivative (finite differences)
#' @input temp field to calculate derivative of
#' @input xs vector containing x coordinates
#' @input ys vector containing y coordinates
df_dy = function(temp,xs,ys) {
	n=length(xs)
	m=length(ys)
	temp_new=temp
	for (i in 2:(m-1)) {
		temp_new[i,] = (temp[i+1,]-temp[i-1,])/abs((ys[i+1]-ys[i-1]))
	}
	#boundaries
	temp_new[1,]=(temp[2,]-temp[1,])/abs((ys[2]-ys[1]))
	temp_new[n,]=(temp[n,]-temp[n-1,])/abs((ys[n]-ys[n-1]))
	return(temp_new)
}

#' horizontal advection
#' @input temp field
#' @input u zonal wind
#' @input v meridional wind
#' @input xs vector containing x coordinates
#' @input ys vector containing y coordinates
advection = function(temp,u,v,xs,ys) {
	temp_new=temp
	temp_new=-(u*df_dx(temp,xs,ys)+v*df_dy(temp,xs,ys))
	return(temp_new)
}

#' forward integration (Euler)
#' @input temp field
#' @input u zonal wind
#' @input v meridional wind
#' @input xs vector containing x coordinates
#' @input ys vector containing y coordinates
#' @input tstep time step (default is 1)
int_advection = function(temp,u,v,xs,ys,tstep=1) {
	adv = advection(temp,u,v,xs,ys)
	return(temp-adv*tstep)
}



# ======= frontogenesis function (2D) ================

#' horizontal frontogenesis function (Petterssen, 1936)
#' @input temp field
#' @input u zonal wind
#' @input v meridional wind
#' @input xs vector containing x coordinates
#' @input ys vector containing y coordinates
calc_fronto = function(temp,u,v,xs,ys) {
	dt_dx=df_dx(temp,xs,ys)
	dt_dy=df_dy(temp,xs,ys)
	du_dx=df_dx(u,xs,ys)
	du_dy=df_dy(u,xs,ys)
	dv_dx=df_dx(v,xs,ys)
	dv_dy=df_dy(v,xs,ys)
	betrag=sqrt(dt_dx^2+dt_dy^2)
	return(-1/betrag*(dt_dx*(du_dx*dt_dx+dv_dx*dt_dy)-dt_dy*(du_dy*dt_dx+dv_dy*dt_dy)))
}
