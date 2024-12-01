"""
Generic Expression
"""
abstract type Expression end
getindex(A::Expression, depx, depy) = A

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

"""
Vectors

implemented basically in the same way as forms
"""
abstract type Vector <: Variable end

"""
2D Vector
"""
struct Vector_2D{U<:Expression, V<: Expression} <: Vector
	name::String
	u::U
	v::V
end
Vector_2D(name::String, u::Real, v::Real) = Vector_2D(name, RealValue(u),RealValue(v))
Vector_2D(name::String, u::Expression, v::Real) = Vector_2D(name, u,RealValue(v))
Vector_2D(name::String, u::Real, v::Expression) = Vector_2D(name, RealValue(u),v)
Vector_2D(u,v) = Vector_2D("undefined", u,v)
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
abstract type Form <: Variable end

"""
0-Form in 2D
"""
struct Form0_2D{Q <: Expression} <: Form
	name::String
	q::Q
end
Form0_2D(name::String, q::Real) = Form0_2D(name, RealValue(q))
Form0_2D(q) = Form0_2D("undefined", q)
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
struct Form1_2D{U <: Expression, V <:  Expression} <: Form
	name::String
	u::U
	v::V
end
Form1_2D(name::String, u::Real, v::Real) = Form1_2D(name, RealValue(u),RealValue(v))
Form1_2D(name::String, u::Expression, v::Real) = Form1_2D(name, u,RealValue(v))
Form1_2D(name::String, u::Real, v::Expression) = Form1_2D(name, RealValue(u),v)
Form1_2D(u,v) = Form1_2D("undefined", u,v)
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
struct Form2_2D{W <: Expression} <: Form
	name::String
	w::W
end
Form2_2D(name::String, w::Real) = Form2_2D(name, RealValue(w))
Form2_2D(w) = Form2_2D("undefined", w)
string(expr::Form2_2D) = "($(string(expr.w)))dxdy"
prec(expr::Form2_2D) = 10
function eval(expr::Form2_2D, vals::AbstractDict)
	if !haskey(vals, expr.name)
		return eval(expr.w, vals)
	else
		throw(ErrorException("Direct passing of form not implemented yet"))
	end
end
