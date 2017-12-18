using JuMP, GLPKMathProgInterface

include("setULS.jl")

function bnb(ip, y, bnb_conds, instance)

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

		ip_left,x_left,s_left,y_left = setULS(GLPKSolverLP(), instance)
		conds_left = copy(bnb_conds)
		conds_left[curr_ind] = 0

		for i = 1:size(conds_left,1)
			if conds_left[i] != -1
				@constraint(ip_left, y_left[i] == conds_left[i])
			end
		end

		ip_right,x_right,s_right,y_right = setULS(GLPKSolverLP(), instance)
		conds_right = copy(bnb_conds)
		conds_right[curr_ind] = 1

		for i = 1:size(conds_right,1)
			if conds_right[i] != -1
				@constraint(ip_right, y_right[i] == conds_right[i])
			end
		end

		status_left = solve(ip_left); status_right = solve(ip_right)

		println("LEFT : x = ", getvalue(x_left)," s = ", getvalue(s_left)," y = ", getvalue(y_left))
		println("RIGHT : x = ", getvalue(x_right)," s = ", getvalue(s_right)," y = ", getvalue(y_right))

		if (isnan(getobjectivevalue(ip_left)) || status_left == :Infeasible) && (isnan(getobjectivevalue(ip_right)) || status_right == :Infeasible)
			println("BOTH FAILED")
			println(getvalue(y))
			return ip
		elseif isnan(getobjectivevalue(ip_left)) || status_left == :Infeasible
			println("LEFT FAILED")
			return bnb(ip_right, y_right, conds_right, instance)
		elseif isnan(getobjectivevalue(ip_right)) || status_right == :Infeasible
			println("RIGHT FAILED")
			return bnb(ip_left, y_left, conds_left, instance)
		else
			println("CONTINUE BOTH")
			res_left = bnb(ip_left, y_left, conds_left, instance)
			res_right = bnb(ip_right, y_right, conds_right, instance)
			return getobjectivevalue(res_left) < getobjectivevalue(res_right) ? res_left : res_right
		end

	else
		println(getvalue(y))
		return ip
	end

end
