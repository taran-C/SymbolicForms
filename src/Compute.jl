export compute

"""
Computation

computes an expression on a dictionary of arrays
"""
function compute(f::Expression, vals, nx, ny, nh, out)
	for i in 1+nh:nx-nh
		for j in 1+nh:ny-nh
			vals["i"] = i
			vals["j"] = j
			out[i,j] = eval(f, vals) * vals["msk"][i,j]
		end
	end
	return out
end

function compute(f::Form1_2D, vals, nx, ny, nh, outx, outy)
	for i in 1+nh:nx-nh
		for j in 1+nh:ny-nh
			vals["i"] = i
			vals["j"] = j
			outx[i,j] = eval(f.u, vals)
			outy[i,j] = eval(f.v, vals)
		end
	end
	return outx, outy
end
