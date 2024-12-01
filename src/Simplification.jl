"""
Simplification
"""
function simplify(expr::ComplexValue)
	return ComplexValue(simplify(expr.Re), simplify(expr.Im))
end

function simplify(expr::Addition)
	ls = simplify(expr.left)
	rs = simplify(expr.right)
	
	if ls isa RealValue
		if ls.val == 0
			return rs
		end

		if rs isa RealValue
			return RealValue(ls.val+rs.val)
		end
	end

	if rs isa RealValue
		if rs.val == 0
			return ls
		end
	end

	return ls+rs
end

function simplify(expr::Negative)
	es = simplify(expr.expr)

	if es isa RealValue
		if es.val == 0
			return RealValue(0)
		end
	end
	return - es
end

function simplify(expr::Substraction)
	ls = simplify(expr.left)
	rs = simplify(expr.right)
	
	if ls isa RealValue
		if ls.val == 0
			return - rs
		end

		if rs isa RealValue
			return RealValue(ls.val-rs.val)
		end
	end

	if rs isa RealValue
		if rs.val == 0
			return ls
		end
	end

	return ls-rs
end

function simplify(expr::Multiplication)
	ls = simplify(expr.left)
	rs = simplify(expr.right)
	
	if ls isa RealValue
		if ls.val == 0
			return RealValue(0)
		end
		if ls.val == 1
			return rs
		end

		if rs isa RealValue
			return RealValue(ls.val*rs.val)
		end
	end

	if rs isa RealValue
		if rs.val == 0
			return RealValue(0)
		end
		if rs.val == 1
			return ls
		end
	end

	return ls*rs
end

function simplify(expr::Exponent)
	ls = simplify(expr.left)
	rs = simplify(expr.right)
	
	if rs isa RealValue
		if rs.val == 0
			return RealValue(1)
		end
		if rs.val == 1
			return ls
		end
	end

	return ls ^ rs

end

function simplify(expr::Expression) #Base case
	return expr
end

