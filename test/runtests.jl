using SymbolicForms
using GLMakie

function print_lie()
	x = ArrayVariable("x")
	y = ArrayVariable("y")

	a0 = Form0_2D(x) #a0 = x
	a1 = Form1_2D(x,y) #a1 = x dx + y dy
	a2 = Form2_2D(x) #a2 = x dxdy

	u = ArrayVariable("u")
	v = ArrayVariable("v")
	X = Vector_2D("X", u, v)

	for a in [a0,a1,a2]
		println("Lie derivative of a $(Base.typename(typeof(a)).wrapper) : $(string(SymbolicForms.simplify(SymbolicForms.liederivative(X, a))))\n")
	end
end

function passive_2_form_transport()
	#A lot of this has to be done in a Mesh object (is it in the scope of this Package ? Or perhaps different modules in the package ?)
	nx,ny = 30,30
	nh = 3
	dx = 1/(nx-2*nh)
	dy = 1/(ny-2*nh)

	msk = zeros(nx,ny)
	xarr, yarr = zeros(nx,ny), zeros(nx,ny)
	uarr, varr = zeros(nx,ny), zeros(nx,ny)
	tracarr = zeros(nx,ny)
	for j=1:ny, i=1:nx
		xarr[i,j] = dx * (i-nh-0.5)
		yarr[i,j] = dy * (j-nh-0.5)
		
		if (i>nh) & (i<nx-nh) & (j>nh) & (j<ny-nh)
			if sqrt((xarr[i,j]-0.5)^2 + (yarr[i,j]-0.5)^2)<0.5
				msk[i,j] = 1
			end
		end
		
		uarr[i,j] = -cos(pi*yarr[i,j]) * sin(pi*xarr[i,j])* msk[i,j]
		varr[i,j] = cos(pi*xarr[i,j]) * sin(pi*yarr[i,j]) * msk[i,j]
		tracarr[i,j] = msk[i,j] * (mod(floor(xarr[i,j] / (8*dx)),2) + mod(floor(yarr[i,j] / (8*dy)), 2) -1)
	end

	x = ArrayVariable("x")
	y = ArrayVariable("y")
	u,v = ArrayVariable("u"), ArrayVariable("v")
	U = Vector_2D(u,v)
	ta = ArrayVariable("trac")
	trac = Form2_2D(ta)
	symmsk = ArrayVariable("msk")
	
	out = zeros(nx,ny)
	dt = 0.1

	fig, ax, hm = heatmap(tracarr)
	record(fig, "2form.mp4", 1:dt:10, framerate = 10) do t
		compute(liederivative(U,trac), Dict("msk"=> msk, "u"=>uarr, "v"=>varr, "x"=>xarr, "y"=>yarr, "trac"=>tracarr, "i"=>0, "j"=>0), nx, ny, nh, out)
		tracarr += out * dt
		heatmap!(ax, tracarr)
	end
	current_figure()
end

#print_lie()
passive_2_form_transport()
