# --------------------------------------------------------------------------- #
# Loading an instance of SPP (format: OR-library)

function loadMCLS(fname)
    file=open(fname)
    # lecture du nbre de périodes (T) et du nombre de produits (P)
    T =  parse.(Int, readline(file))
    P =  parse.(Int, readline(file))
    # lecture des m contraintes et reconstruction de la matrice binaire A
    D = zeros(Int, P, T)
    C = zeros(Int, P)
    b = zeros(Int, P)
    h = zeros(Int, P)
    f = zeros(Int, P)
    phi = zeros(Int, P, T)
    p = zeros(Int, P)
	v = ones(Int, P,T)

    i = 1
    j = 1

    for valeur in split(readline(file))
        D[j ,i]=parse(Int64,valeur)

        i += 1
        if(i==T+1)
            i = 1
            j = j+1
        end
    end

    i=1

    for valeur in split(readline(file))
        C[i] = parse(Int64,valeur)
        i += 1
    end

    i=1

    for valeur in split(readline(file))
        b[i] = parse(Int64,valeur)
        i += 1
    end

    i=1

    for valeur in split(readline(file))
        h[i] = parse(Int64,valeur)
        i += 1
    end

    i=1

    for valeur in split(readline(file))
        f[i] = parse(Int64,valeur)
        i += 1
    end
    close(file)

    return D, C, b, h, f, phi, p, v
end
