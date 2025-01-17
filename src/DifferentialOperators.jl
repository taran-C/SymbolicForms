export exteriorderivative, interiorproduct, liederivative, hodge, sharp, flat, interpx, interpy, interpdiag
#TODO versions of each operator according to primality
"""
Exterior Derivative of a differential form
"""
exteriorderivative(a::Form0_2D{Primal}) = Form1_2D((a.q[1,0]-a.q[0,0])*mskx, (a.q[0,1]-a.q[0,0])*msky, Primal)
exteriorderivative(a::Form0_2D{Dual}) = Form1_2D((a.q[0,0]-a.q[-1,0])*mskx, (a.q[0,0]-a.q[0,-1])*msky, Dual)

exteriorderivative(a::Form1_2D{Primal}) = Form2_2D(((a.v[1,0]-a.v[0,0]) - (a.u[0,1]-a.u[0,0]))*mskv, Primal)
exteriorderivative(a::Form1_2D{Dual}) = Form2_2D(((a.v[0,0]-a.v[-1,0]) - (a.u[0,0]-a.u[0,-1]))*mskv, Dual)

exteriorderivative(a::Expression) = RealValue(0)

"""
Interior Product of two forms TODO check vector placement on grid and interpolations
"""
#interiorproduct(X::Vector_2D, a::Expression) = RealValue(0)

#interiorproduct(X::Vector_2D{P2}, a::Form1_2D{P}) where {P, P2} = Form0_2D((a.u * X.u + a.v * X.v)*msk, P)
#interiorproduct(X::Vector_2D{P2}, a::Form2_2D{P}) where {P, P2} = Form1_2D((-X.v * a.w)*mskx, (X.u * a.w)*msky, P)
interiorproduct(X::Vector_2D{Dual}, a::Form1_2D{Dual}) = Form0_2D(upwindx(X.u[0,0] + X.v[1,0], X.u * a.u, oxx) + upwindy(X.v[0,0]+X.v[0,1], X.v * a.v, oyy), Dual)

#TODO use avg4pt functions
interiorproduct(X::Vector_2D{Dual}, a::Form2_2D{Dual}) = Form1_2D(-avg4pt(X.v, -1, 1) * upwind(), avg4pt(X.u, 1, -1) * upwind(), Dual)


"""
Lie Derivative of a form a transported by a vector field X
"""
liederivative(X::Vector_2D, a::Form) = interiorproduct(X, exteriorderivative(a)) + exteriorderivative(interiorproduct(X,a))

"""
Hodge

hodge star of a form, TODO handle duality and metric, implement all cases
"""
hodge(a::Form2_2D{P}) where {P} = Form0_2D(a.w/A, P<:Primal ? Dual : Primal)

"""
Inner Product TODO (and decompose some operators in function of others (eg interior product with flat/sharp and inner)
"""

"""
Sharp

1-Form to vector
TODO Separate into dual/primal to account for different edge lengths
"""
sharp(u::Form1_2D{P}) where {P} = Vector_2D(u.u/dx, u.v/dy, P)

"""
Flat

Vector to 1-form
"""
flat(X::Vector_2D{P}) where {P} = Form1_2D(X.u*dx, X.v*dy, P)

