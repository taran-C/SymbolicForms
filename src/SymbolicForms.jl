module SymbolicForms

import Base: +,*,^,-, string, getindex

include("Variables.jl")
include("Operators.jl")
include("Mesh.jl")
include("Compute.jl")
include("DifferentialOperators.jl")
include("Simplification.jl")

#TODO
#Bring Simplification and Derivation (and other attributes of each object) under the definition of this object ?
#Or properly separate by definitions and then operation on objects
#Basically make a choice between a OOP or FP code organization*
#
#Maybe have a literal array type ? or a different atomic type altogether ?
#
#"Flattening" successions of operators of same precedence to allow for more simplifications (ex : (x+1)-x = x+1-x = 1)

end
