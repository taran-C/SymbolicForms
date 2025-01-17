export Manifold

"""
Manifold

Object representing the spatial characteristics of our domain
"""
struct Manifold
	Lx::Real
	Ly::Real

	nx::Integer
	ny::Integer
	nh::Integer
	
	msk
	mskx
	msky
	mskv

	xc
	yc

	#Arrays representing edge lengths and cell surface (metric)
	dx 
	dy
	A
end
function Manifold(msk; Lx=1, Ly=1, nx=30, ny=30, nh=3)
	xc = zeros(nx,ny)
	yc = zeros(nx,ny)

	dx,dy,A = zeros(nx,ny), zeros(nx,ny), zeros(nx,ny)
	mskx,msky,mskv = zeros(nx,ny), zeros(nx,ny), zeros(nx,ny)

	for i in 1+nh:nx-nh, j in 1+nh:ny-nh
		dx[i,j] = Lx / (nx-2*nh)
		dy[i,j] = Ly / (ny-2*nh)
		A[i,j] = dx[i,j]*dy[i,j]

		xc[i,j] = dx[i,j] * (i-nh-0.5) * Lx
		yc[i,j] = dy[i,j] * (j-nh-0.5) * Ly
	
		mskx[i,j] = msk[i,j]+msk[i+1,j] > 0 ? 1 : 0
		msky[i,j] = msk[i,j]+msk[i,j+1] > 0 ? 1 : 0
		mskv[i,j] = msk[i,j]+msk[i+1,j]+msk[i,j+1]+msk[i+1,j+1] > 0 ? 1 : 0
	end


	return Manifold(Lx,Ly,nx,ny,nh,msk,mskx,msky,mskv,xc,yc, dx,dy,A)
end

"""
Global Expressions representing any manifold
Can be used directly in differential operators for example, and compute will need a manifold object to forward variables
"""
Lx = ScalarVariable("Lx")
Ly = ScalarVariable("Ly")

nx = ScalarVariable("nx")
ny = ScalarVariable("ny")
nh = ScalarVariable("nh")

#Should the other masks be defined in function of msk ? (probably not)
msk = ArrayVariable("msk")
mskx = ArrayVariable("mskx")
msky = ArrayVariable("msky")
mskv = ArrayVariable("mskv")

#Interp Orders TODO create Order object (cf Forms.jl) that can be used for concrete OR expr objects
ocx = ArrayVariable("ocx")
ocy = ArrayVariable("ocy")

oxx = ArrayVariable("oxx")
oxy = ArrayVariable("oxy")

oyx = ArrayVariable("oyx")
oyy = ArrayVariable("oyy")

#Grid points
xc = ArrayVariable("xc")
yc = ArrayVariable("yc")

#Metric
dx = ArrayVariable("dx")
dy = ArrayVariable("dy")
A = ArrayVariable("A")
