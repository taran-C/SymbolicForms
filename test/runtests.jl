using SymbolicForms
#using GLMakie

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

function conditionals_test()
	a = RealValue(4)
	b = ScalarVariable("x")

	max = TernaryOperator(a>b, a,b)

	println(string(max))
	println(SymbolicForms.eval(max, Dict("x"=>6)))
	println((a>b) isa SymbolicForms.BooleanExpression)
end

function interpolation_test()
	U = ArrayVariable("U")
	q = ArrayVariable("q")

	println(string(SymbolicForms.upwindx(U,q)))
end

function passive_2_form_transport()
	#A lot of this has to be done in a Mesh object (is it in the scope of this Package ? Or perhaps different modules in the package ?)
	nx, ny, nh = 30,30,3

	msk = zeros(nx,ny)
	for j=1:ny, i=1:nx
		if (i>nh) & (i<nx-nh) & (j>nh) & (j<ny-nh)
			msk[i,j] = 1
		end
	end
	manifold = Manifold(msk, nx=nx, ny=ny, nh=nh)
		
	uarr, varr = zeros(nx,ny), zeros(nx,ny)
	tracarr = zeros(nx,ny)
	for j=1:ny, i=1:nx
		uarr[i,j] = -cos(pi*manifold.yc[i,j]) * sin(pi*manifold.xc[i,j])* manifold.mskx[i,j]
		varr[i,j] = cos(pi*manifold.xc[i,j]) * sin(pi*manifold.yc[i,j]) * manifold.msky[i,j]
		#tracarr[i,j] = msk[i,j] * (mod(floor(xarr[i,j] / (8*dx)),2) + mod(floor(yarr[i,j] / (8*dy)), 2) -1)
		if (manifold.xc[i,j]>0.4) & (manifold.xc[i,j]<0.6) & (manifold.yc[i,j]>0.4) & (manifold.yc[i,j]<0.6)
			tracarr[i,j] = 1
		end
	end

	u,v = ArrayVariable("u"), ArrayVariable("v")
	U = Vector_2D(u,v)
	ta = ArrayVariable("trac")
	trac = Form2_2D(ta)
	symmsk = ArrayVariable("msk")
	
	out = zeros(nx,ny)
	dt = 0.1

	fig, ax, hm = heatmap(tracarr)
	record(fig, "2form.mp4", 1:dt:10, framerate = 10) do t
		compute(liederivative(U,trac), Dict{String, Any}("u"=>uarr, "v"=>varr, "trac"=>tracarr), manifold, out)
		tracarr += out * dt
		heatmap!(ax, tracarr)
	end
	current_figure()
end

function manifold_test()
	nx,ny,nh = 30,30, 3
	msk = zeros(nx,ny)
	for i in 1:nx, j in 1:ny
		if (i>nh) & (i<nx-nh) & (j>nh) & (j<ny-nh)
			msk[i,j] = 1
		end
	end

	manifold = Manifold(msk)
	u = ArrayVariable("u")
	v = ArrayVariable("v")
	U = Vector_2D(u,v)

	println(string(flat(U)))
end

#print_lie()
#passive_2_form_transport()
#manifold_test()
conditionals_test()
#interpolation_test()
