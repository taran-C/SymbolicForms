using SymbolicForms

"""
Integration of RSW equations

	Prognostic :
		u : du/dt = -i(U, ζ* + f*) - d(p + k) : Covariant (transported) velocity -> Dual 1-Form
		h* : dh/dt = Lx(U, h) : Finite-Volume Depth -> Primal 2-Form

	Diagnostic :
		U = u♯ : Contravariant (transportant) velocity -> Vector (Primal/Dual ?, Dual here to allow for a direct sharp, should probably be handled differently)
		k = 0.5 * hodge(innerproduct(u,u)) : Kinetic Energy -> Dual 0-Form
		  = 0.5 * interiorproduct(U,u) ?

		p = *(g(h*+b*)) : Pressure -> Dual 0-form (we can use b*=0 (no bottom topology) and g=1 for simplification, for now)
		ζ* = du -> Dual 2-Form
		f* : Finite-Volume Coriolis -> Dual 2-Form
"""

ux = ArrayVariable("ux")
uy = ArrayVariable("uy")
u = Form1_2D(ux, uy, Dual)

harr = ArrayVariable("h")
h = Form2_2D(harr, Primal)

U = sharp(u)
k = 0.5 * interiorproduct(U,u)
p = hodge(h)
ksi = exteriorderivative(u)
farr = ArrayVariable("f")
f = Form2_2D(farr, Dual)

dudt = -interiorproduct(U, ksi + f) - exteriorderivative(p+k)
dhdt = liederivative(U,h)

println(string(dudt))
