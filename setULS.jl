# --------------------------------------------------------------------------- #

# Setting an ip model of ULS
function setULS(solverSelected, A)
  M = 100
  m, n = size(A) #n <=> T le nombre de périodes
  ip = Model(solver=solverSelected)

  @variable(ip, x[1:n], lowerbound = 0)
  @variable(ip, s[1:n], lowerbound = 0)
  @variable(ip, y[1:n], lowerbound = 0, upperbound = 1) #Censé être binaire

  @objective(ip, Min, sum(x[t]*A[2,t]+s[t]*A[3,t]+y[t]*A[4,t] for t=1:n))

  @constraint(ip, x[1] == s[1]+A[1,1])
  @constraint(ip, cte[t=2:n], x[t]+s[t-1] == s[t]+A[1,t])
  @constraint(ip, ctrte[t=1:n], x[t] <= y[t]*M)

  return ip, x, s, y
end
