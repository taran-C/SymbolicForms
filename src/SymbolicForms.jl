module SymbolicForms

import Base: +,*,^,-,/,<,>,!, string, getindex

include("Variables.jl")
include("Operators.jl")
include("Conditionals.jl")
include("Manifold.jl")
include("Compute.jl")
include("DifferentialOperators.jl")
include("Simplification.jl")
include("Interpolations.jl")

#TODO
#Bring Simplification and Derivation (and other attributes of each object) under the definition of this object ?
#Or properly separate by definitions and then operation on objects
#Basically make a choice between a OOP or FP code organization*
#
#Maybe have a literal array type ? or a different atomic type altogether ?
#
#"Flattening" successions of operators of same precedence to allow for more simplifications (ex : (x+1)-x = x+1-x = 1)
#Creating a union type for scalar expressions -> easier forwarding of operation in forms
#Implement an elliptic solver (poisson problem) (use breaks for highly coupled problems)
#Platform-Specific automatic optimization (more or less arithmetic intensity)
#Numerical methods modifications
#Jeu d'équation euler2d (fluids2D)

end
