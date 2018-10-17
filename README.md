# MCLS

Julia implementation of a Branch & Bound algorithm applied to the Multi-product Capacitated Lot Sizing Problem.  
The Uncapacitated Lot Sizing Porblem has been solved using a B&B as a first step in the development.  
  
loadPROBLEMNAME.jl loads the instance from a file and returns all the needed parameters  
setPROBLEMNAME.jl generates the problem using the JuMP package  
bnbPROBLEMNAME.jl implements the bnb for each problem. It could be simplified as one file named bnb.jl by replacing the problem's parameters by a data structure
