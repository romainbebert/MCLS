using JuMP, GLPKMathProgInterface

include("loadULS.jl")
include("setULS.jl")
include("loadMCLS.jl")
include("setMCLS.jl")
include("bnb2.jl")

#=
inst = loadULS("instance.dat")
ip, x, s, y = setULS(GLPKSolverLP(), inst)

println("z = ", getobjectivevalue(bnb(ip, y, map(x -> -x, ones(Int8, size(inst,2))), inst)))
=#

D, C, b, h, f, phi, p = loadMCLS("instance2.dat")
ip, x, s, y, v = setMCLS(GLPKSolverLP(), D, C, b, h, f, phi, p)

println("z=  ", getobjectivevalue(ip))
println("x=  ", getvalue(x))
println("s=  ", getvalue(s))
println("y=  ", getvalue(y))
println("v=  ", getvalue(v))
