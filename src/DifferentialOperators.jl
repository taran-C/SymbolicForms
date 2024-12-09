export exteriorderivative, interiorproduct, liederivative, hodge, sharp, flat, interpx, interpy, interpdiag

"""
Exterior Derivative of a differential form
"""
exteriorderivative(a::Form0_2D) = Form1_2D((a.q[1,0]-a.q[0,0])*mskx, (a.q[0,1]-a.q[0,0])*msky)
exteriorderivative(a::Form1_2D) = Form2_2D(((a.v[1,0]-a.v[0,0]) - (a.u[0,1]-a.u[0,0]))*mskv)
exteriorderivative(a::Expression) = RealValue(0)

"""
Interior Product of two forms TODO check vector placement on grid and interpolations
"""
interiorproduct(X::Vector_2D, a::Expression) = RealValue(0)
interiorproduct(X::Vector_2D, a::Form1_2D) = Form0_2D((a.u * X.u + a.v * X.v)*msk)
interiorproduct(X::Vector_2D, a::Form2_2D) = Form1_2D((-X.v * a.w)*mskx, (X.u * a.w)*msky)

"""
Lie Derivative of a form a transported by a vector field X
"""
liederivative(X::Vector_2D,a::Form) = interiorproduct(X, exteriorderivative(a)) + exteriorderivative(interiorproduct(X,a))

"""
Hodge

hodge star of a form, TODO handle duality and metric, implement all cases
"""
hodge(a::Form2_2D) = Form0_2D(a.q/A)

"""
Inner Product TODO (and decompose some operators in function of others (eg interior product with flat/sharp and inner)
"""

"""
Sharp

1-Form to vector
"""
sharp(u::Form1_2D) = Vector_2D(u.u/dx, u.v/dy)

"""
Flat

Vector to 1-form
"""
flat(X::Vector_2D) = Form1_2D(X.u*dx, X.v*dy)

"""
Interpolations TODO add weno and configurable interpolations
"""
interpx(a::Expression) = 0.5*(a[1,0]+a[0,0])
interpy(a::Expression) = 0.5*(a[0,1]+a[0,0])
interpdiag(a::Expression) = interpx(interpy(a))
