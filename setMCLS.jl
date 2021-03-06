# --------------------------------------------------------------------------- #

# Setting an ip model of MCLS
function setMCLS(solverSelected, D, C, b, h, f, phi, p, v)
  M = 100
  m, n = size(D) #n <=> T le nombre de périodes
  ip = Model(solver=solverSelected)

  @variable(ip, x[1:m, 1:n], lowerbound = 0)
  @variable(ip, s[1:m, 1:n], lowerbound = 0)
  @variable(ip, y[1:m, 1:n], lowerbound = 0, upperbound = 1) #Censé être binaire
  @variable(ip, r[1:m, 1:n], lowerbound = 0)

  @objective(ip, Min, sum(x[i,t]*p[i] for t=1:n, i=1:m) + sum(f[i]*y[i,t] for t=1:n, i=1:m) + sum(h[i]*s[i,t] for t=1:n, i=1:m) + sum(b[i]*r[i,t] for t=1:m, i=1:m)) #(3.1)

  @constraint(ip, cte[i=1:m,t=2:n], x[i,t] + r[i,t] - s[i,t] + s[i,t-1] == D[i,t]) #(3.2)
  @constraint(ip, time[t=1:m], sum(v[i,t]*x[i,t] for i=1:n) + sum(phi[i,t]*y[i,t] for i=1:n) <= C[t]) #(3.3)
  @constraint(ip, ctrte[i=1:m,t=1:n], x[i,t] <= y[i,t]*M) #(3.4)
  @constraint(ip, prodtime[i=1:m, t=1:n], r[i,t] <= D[i,t])

  return ip, x, s, y, r
end
