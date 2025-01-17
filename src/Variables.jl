export RealValue, ComplexValue
export ScalarVariable, ArrayVariable
export Vector_2D, Form0_2D, Form1_2D, Form2_2D

"""
Generic Expression
"""
abstract type Expression end

getindex(A::Expression, depx, depy) = A
eval(expr::Expression) = eval(expr, Dict())

"""
An atom is a singular element holding a value (Variable or not)
"""
abstract type Atom <: Expression end
prec(expr::Atom) = 10

"""
Literals (literal constant value)
"""
abstract type Literal <: Atom end

struct RealValue <: Literal
	val::Real
end
string(expr::RealValue) = string(expr.val)
eval(expr::RealValue, vals::AbstractDict) = expr.val

#TODO not tested, probably not working
struct ComplexValue <: Literal
	Re::RealValue
	Im::RealValue
end
string(expr::ComplexValue) = "($(string(expr.Re))+$(string(expr.Im))i))"
ComplexValue(a::Real, b::Real) = ComplexValue(RealValue(a),RealValue(b))
eval(expr::ComplexValue, vals::AbstractDict) = expr.Re + im*expr.Im

"""
Variables
"""
abstract type Variable <: Atom end

struct ScalarVariable <: Variable
	name::String
end
string(expr::ScalarVariable) = expr.name
function eval(expr::ScalarVariable, vals::AbstractDict)
	if !haskey(vals, expr.name)
		return expr
	end
	return vals[expr.name]
end

#Array object representing a variable name and a relative position
struct ArrayVariable <: Variable
        name :: String
        depx :: Integer
        depy :: Integer
end
string(expr::ArrayVariable) = "$(expr.name)[$(expr.depx)+i,$(expr.depy)+j]"
ArrayVariable(name :: String) = ArrayVariable(name, 0, 0)
getindex(A::ArrayVariable, depx, depy) = ArrayVariable(A.name, A.depx+depx, A.depy+depy)
function eval(expr::ArrayVariable, vals::AbstractDict)
	if !haskey(vals, expr.name)
		return expr
	end
	if !haskey(vals, "i") | !haskey(vals, "j")
		throw(ErrorException("Can't get an array withour coordinates"))
	end
	return vals[expr.name][vals["i"]+expr.depx, vals["j"]+expr.depy]
end


#TODO separate from here to better isolate variables related to differential geometry

"""
	Primality

(Primal or Dual)
"""
abstract type Primality end
abstract type Primal <: Primality end
abstract type Dual <: Primality end
export Primal, Dual

"""
Vectors

implemented basically in the same way as forms
"""
abstract type Vector{P<:Primality} <: Variable end

"""
2D Vector
"""
struct Vector_2D{P} <: Vector{P}
	name::String
	u::Expression
	v::Expression

	function Vector_2D(name, u, v, P)
		@assert P<:Primality "P must be Primal or Dual"

		return new{P}(name, u, v)
	end
end
Vector_2D(name::String, u::Real, v::Real, P) = Vector_2D(name, RealValue(u),RealValue(v), P)
Vector_2D(name::String, u::Expression, v::Real, P) = Vector_2D(name, u,RealValue(v), P)
Vector_2D(name::String, u::Real, v::Expression, P) = Vector_2D(name, RealValue(u),v, P)
Vector_2D(u,v, P) = Vector_2D("undefined", u,v, P)
#TODO use precedence to handle parentheses here
string(expr::Vector_2D) = "($(string(expr.u)), $(string(expr.v)))"
prec(expr::Vector_2D) = 1
function eval(expr::Vector_2D, vals::AbstractDict)
	if !haskey(vals, expr.name)
		return Vector_2D(eval(expr.u, vals), eval(expr.v, vals))
	else
		throw(ErrorException("Direct passing of vector not implemented yet"))
	end
end


"""
Forms

Need to find a way to directly pass a form an not the arrays contained within it if they are, and to output two arrays/a 1-form if the final result of an expression is a 1-form
"""
abstract type Form{P<:Primality} <: Variable end

"""
0-Form in 2D
"""
struct Form0_2D{P} <: Form{P}
	name::String
	q::Expression

	function Form0_2D(name, q, P)
		@assert P<:Primality "P must be Primal or Dual"

		return new{P}(name, q)
	end
end
Form0_2D(name::String, q::Real, P) = Form0_2D(name, RealValue(q), P)
Form0_2D(q, P) = Form0_2D("undefined", q, P)
string(expr::Form0_2D) = "$(string(expr.q))"
prec(expr::Form0_2D) = 10
function eval(expr::Form0_2D, vals::AbstractDict)
	if !haskey(vals, expr.name)
		return eval(expr.q, vals)
	else
		throw(ErrorException("Direct passing of form not implemented yet"))
	end
end

"""
1-Form in 2D
"""
struct Form1_2D{P} <: Form{P}
	name::String
	u::Expression
	v::Expression

	function Form1_2D(name, u, v, P)
		@assert P<:Primality "P must be Primal or Dual"

		return new{P}(name, u, v)
	end
end
Form1_2D(name::String, u::Real, v::Real, P) = Form1_2D(name, RealValue(u),RealValue(v), P)
Form1_2D(name::String, u::Expression, v::Real, P) = Form1_2D(name, u,RealValue(v), P)
Form1_2D(name::String, u::Real, v::Expression, P) = Form1_2D(name, RealValue(u),v, P)
Form1_2D(u,v, P) = Form1_2D("undefined", u,v, P)
#TODO use precedence to handle parentheses here
string(expr::Form1_2D) = "($(string(expr.u)))dx + ($(string(expr.v)))dy"
prec(expr::Form1_2D) = 1
function eval(expr::Form1_2D, vals::AbstractDict)
	if !haskey(vals, expr.name)
		return Form1_2D(eval(expr.u, vals), eval(expr.v, vals))
	else
		throw(ErrorException("Direct passing of form not implemented yet"))
	end
end

"""
2-Form in 2D
"""
struct Form2_2D{P} <: Form{P}
	name::String
	w::Expression

	function Form2_2D(name, w, P)
		@assert P<:Primality "P must be Primal or Dual"

		return new{P}(name, w)
	end
end
Form2_2D(name::String, w::Real, P) = Form2_2D(name, RealValue(w), P)
Form2_2D(w, P) = Form2_2D("undefined", w, P)
string(expr::Form2_2D) = "($(string(expr.w)))dxdy"
prec(expr::Form2_2D) = 10
function eval(expr::Form2_2D, vals::AbstractDict)
	if !haskey(vals, expr.name)
		return eval(expr.w, vals)
	else
		throw(ErrorException("Direct passing of form not implemented yet"))
	end
end
