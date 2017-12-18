using JuMP, GLPKMathProgInterface

include("setMCLS.jl")

function bnbMCLS(ip, y, bnb_conds, D, C, b, h, f, phi, p, v)

	valy = getvalue(y)
	realy = find(!isinteger, valy)

	println()
	println("Real values : ", realy)

	if size(realy,1) != 0

		curr_ind = realy[1]

		#On sélectionne la valeur la plus proche de 0
		#=for ind in realy
			if ind < curr_ind
				curr_ind = ind
			end
		end=#

		ip_left,x_left,s_left,y_left,r_left = setMCLS(GLPKSolverLP(), D, C, b, h, f, phi, p, v)
		conds_left = copy(bnb_conds)
		conds_left[curr_ind] = 0

		println(conds_left)

		for i = 1:size(conds_left,1)
			if conds_left[i] != -1
				@constraint(ip_left, y_left[i] == conds_left[i])
			end
		end

		ip_right,x_right,s_right,y_right,r_right = setMCLS(GLPKSolverLP(), D, C, b, h, f, phi, p, v)
		conds_right = copy(bnb_conds)
		conds_right[curr_ind] = 1

		for i = 1:size(conds_right,1)
			if conds_right[i] != -1
				@constraint(ip_right, y_right[i] == conds_right[i])
			end
		end

		status_left = solve(ip_left); status_right = solve(ip_right)

		#println("LEFT : x = ", getvalue(x_left)," s = ", getvalue(s_left)," y = ", getvalue(y_left))
		#println("RIGHT : x = ", getvalue(x_right)," s = ", getvalue(s_right)," y = ", getvalue(y_right))

		#println("LEFT CONDITIONS : ", conds_left)
		#println("RIGHT CONDITIONS : ", conds_right)

		if (isnan(getobjectivevalue(ip_left)) || status_left == :Infeasible) && (isnan(getobjectivevalue(ip_right)) || status_right == :Infeasible)
			println("BOTH FAILED")
			println(getvalue(y))
			return ip
		elseif isnan(getobjectivevalue(ip_left)) || status_left == :Infeasible
			println("LEFT FAILED")
			return bnbMCLS(ip_right, y_right, conds_right, D, C, b, h, f, phi, p, v)
		elseif isnan(getobjectivevalue(ip_right)) || status_right == :Infeasible
			println("RIGHT FAILED")
			return bnbMCLS(ip_left, y_left, conds_left, D, C, b, h, f, phi, p, v)
		else
			println("CONTINUE BOTH")
			res_left = bnbMCLS(ip_left, y_left, conds_left, D, C, b, h, f, phi, p, v)
			res_right = bnbMCLS(ip_right, y_right, conds_right, D, C, b, h, f, phi, p, v)
			return getobjectivevalue(res_left) < getobjectivevalue(res_right) ? res_left : res_right
		end

	else
		println(getvalue(y))
		return ip
	end

end
