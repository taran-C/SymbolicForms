"""
Derivation
"""
function deriv(expr::Variable, var::Variable)
	if expr.name == var.name
		return RealValue(1)
	else
		return RealValue(0)
	end
end

function deriv(expr::RealValue, var::Variable)
	return RealValue(0)
end

function deriv(expr::ComplexValue, var::Variable)
	return RealValue(0)
end

function deriv(expr::Addition, var::Variable)
	return deriv(expr.left, var) + deriv(expr.right, var)
end

function deriv(expr::Negative, var::Variable)
	return - deriv(expr.expr, var)
end

function deriv(expr::Substraction, var::Variable)
	return deriv(expr.left, var) - deriv(expr.right, var)
end

function deriv(expr::Multiplication, var::Variable)
	return deriv(expr.left, var) * expr.right + expr.left * deriv(expr.right, var)
end

function deriv(expr::Exponent, var::Variable)
	return deriv(expr.left, var) * expr.right * (expr.left ^ simplify(expr.right-1))
end
