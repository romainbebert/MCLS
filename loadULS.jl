# --------------------------------------------------------------------------- #
# Loading an instance of SPP (format: OR-library)

function loadULS(fname)
    f=open(fname)
    # lecture du nbre de périodes (T)
    T = parse.(Int, readline(f))
    # lecture des m contraintes et reconstruction de la matrice binaire A
    A=zeros(Int, 4, T)
    for i=1:4
        # lecture des indices des elements non nuls sur la contrainte i
		j=1
        for valeur in split(readline(f))
          A[i,j]=parse(Float64, valeur)
		  j+=1
        end
    end
    close(f)
    return A
end
