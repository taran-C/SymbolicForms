using SymbolicForms

x = SymbolicForms.ArrayVariable("x")
y = SymbolicForms.ArrayVariable("y")

a0 = SymbolicForms.Form0_2D(x) #a0 = x
a1 = SymbolicForms.Form1_2D(x,y) #a1 = x dx + y dy
a2 = SymbolicForms.Form2_2D(x) #a2 = x dxdy

u = SymbolicForms.ArrayVariable("u")
v = SymbolicForms.ArrayVariable("v")
X = SymbolicForms.Vector_2D("X", u, v)

for a in [a0,a1,a2]
	println(string(SymbolicForms.simplify(SymbolicForms.liederivative(X, a))))
end

nx = 10
ny = 10
xarr = zeros(nx,ny)
yarr = zeros(nx,ny)
for i in 1:nx
	for j in 1:ny
		xarr[i,j] = i
		yarr[i,j] = j
	end
end

nh = 2
outx = zeros(nx,ny)
outy = zeros(nx,ny)
#SymbolicForms.compute(d2f, Dict("x"=>xarr,"y"=>yarr, "i"=>0, "j"=>0), nx, ny, nh, outx)


