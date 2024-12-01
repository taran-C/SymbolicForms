"""
Exterior Derivative of a differential form
"""
exteriorderivative(a::Form0_2D) = Form1_2D(a.q[1,0]-a.q[0,0], a.q[0,1]-a.q[0,0])
exteriorderivative(a::Form1_2D) = Form2_2D((a.v[1,0]-a.v[0,0]) - (a.u[0,1]-a.u[0,0]))
exteriorderivative(a::Expression) = RealValue(0)

"""
Interior Product of two forms TODO check vector placement on grid and interpolations
"""
interiorproduct(X::Vector_2D, a::Expression) = RealValue(0)
interiorproduct(X::Vector_2D, a::Form1_2D) = Form0_2D(interpx(a.u * X.u) + interpy(a.v * X.v))
interiorproduct(X::Vector_2D, a::Form2_2D) = Form1_2D(-X.v * interpy(a.w), X.u * interpx(a.w))

"""
Lie Derivative of a form a transported by a vector field X
"""
liederivative(X::Vector_2D,a::Form) = interiorproduct(X, exteriorderivative(a)) + exteriorderivative(interiorproduct(X,a))

"""
Interpolations TODO add weno and configurable interpolations
"""
interpx(a::Expression) = 0.5*(a[1,0]+a[0,0])
interpy(a::Expression) = 0.5*(a[0,1]+a[0,0])
interpdiag(a::Expression) = interpx(interpy(a))
