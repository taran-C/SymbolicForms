export compute

"""
Computation

computes an expression on a dictionary of arrays
"""
function compute(f::Expression, vals::Dict{String, Any}, manifold::Manifold, out)
	for i in 1+manifold.nh:manifold.nx-manifold.nh
		for j in 1+manifold.nh:manifold.ny-manifold.nh
			forward!(i,j,manifold, vals)
			
			out[i,j] = eval(f, vals) * vals["msk"][i,j]
		end
	end
	return out
end

function compute(f::Form1_2D, vals::Dict{String, Any}, manifold::Manifold, outx, outy)
	for i in 1+manifold.nh:manifold.nx-manifold.nh
		for j in 1+manifold.nh:manifold.ny-manifold.nh
			forward!(i,j,manifold, vals)

			outx[i,j] = eval(f.u, vals)
			outy[i,j] = eval(f.v, vals)
		end
	end
	return outx, outy
end

"""
forward

function to forward mesh arguments etc...
"""
function forward!(i,j,manifold::Manifold, vals::Dict{String, Any})
	vals["i"] = i
	vals["j"] = j

	vals["Lx"] = manifold.Lx
	vals["Ly"] = manifold.Ly

	vals["nx"] = manifold.nx
	vals["ny"] = manifold.ny
	vals["nh"] = manifold.nh

	vals["msk"] = manifold.msk
	vals["mskx"] = manifold.mskx
	vals["msky"] = manifold.msky
	vals["mskv"] = manifold.mskv

	vals["xc"] = manifold.xc
	vals["yc"] = manifold.yc

	vals["dx"] = manifold.dx
	vals["dy"] = manifold.dy
	vals["A"] = manifold.A
end
