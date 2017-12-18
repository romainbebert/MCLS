using JuMP, GLPKMathProgInterface

include("loadULS.jl")
include("setULS.jl")
include("bnbULS.jl")

include("loadMCLS.jl")
include("setMCLS.jl")
include("bnbMCLS.jl")

#=
inst = loadULS("instance.dat")
ip, x, s, y = setULS(GLPKSolverLP(), inst)

println("z = ", getobjectivevalue(bnbULS(ip, y, map(x -> -x, ones(Int8, size(inst,2))), inst)))
=#

D, C, b, h, f, phi, p, v = loadMCLS("instance2.dat")
ip, x, s, y, r = setMCLS(GLPKSolverLP(), D, C, b, h, f, phi, p, v)


solve(ip)

println("z = ", getobjectivevalue(bnbMCLS(ip, y, map(x -> -x, ones(Int8, size(D,1), size(D,2))), D, C, b, h, f, phi, p, v)))

#=println("z=  ", getobjectivevalue(ip))
println("x=  ", getvalue(x))
println("s=  ", getvalue(s))
println("y=  ", getvalue(y))
println("r=  ", getvalue(r))=#
