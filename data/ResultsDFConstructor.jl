include("../src/NaiveCoarseness.jl")
include("../src/GuillotineCoarseness.jl")
include("../src/DataUtils.jl")

using DataFrames
using CSV

if true && isfile("data/Results_df.csv")
     df = CSV.read("data/Results_df.csv", DataFrame)
end


N = [10,15,20,25,30]
I = 0:29

## base df construction    
if false
    df = baseDF(N,I)

    NIns = size(df,1)

    c_br1 = zeros(Int, NIns)
    k_br1 = zeros(Int, NIns)
    c_br2 = zeros(Int, NIns)
    k_br2 = zeros(Int, NIns)
    Π_br_1eq2 = zeros(Bool, NIns)

    for j = 1:NIns
        i = df.i[j]
        n = df.n[j]

        Π_br1, c_br1[j], k_br1[j] = readSolution(n, i, 1)
        Π_br2, c_br2[j], k_br2[j] = readSolution(n, i, 2)
        Π_br_1eq2[j] = (Π_br1 == Π_br2)
    end

    df.c_br1 = c_br1
    df.c_br2 = c_br2
    df.k_br1 = k_br1
    df.k_br2 = k_br2
    df.Π_br_1eq2 = Π_br_1eq2

    CSV.write("data/Results_df.csv",df)
end


## C(S) brute force for n==10
if false
    NIns = size(df,1)
    c_bf = zeros(Int, NIns)
    k_bf_min = zeros(Int, NIns)
    k_bf_max = zeros(Int, NIns)
    K_bf = zeros(Int, NIns)
    
    for i = 0:29
        println("---------------------------------------\n i = $i")
        S, w = readInstance(10, i)
        c, Π = coarseness_bf(S,w)
        println("c = $c")
        display(Π)
        c_bf[i+1] = c
        k_bf_min[i+1] = min(maximum(Π,dims=1)...)
        k_bf_max[i+1] = max(maximum(Π,dims=1)...)
        K_bf[i+1] = size(Π,2)
    end
    
    df.c_bf = c_bf
    df.k_bf_min = k_bf_min
    df.k_bf_max = k_bf_max
    df.K_bf = K_bf

    CSV.write("data/Results_df.csv",df)
end


## Cg(S) via DP for n=10:5:30
if false
    NIns = size(df,1)
    c_g = zeros(Int, NIns)
    
    for j = 1:5
        n = N[j]
        for i in I
            println("---------------------------------------\ni = $i\nn = $n")
            S, w = readInstance(n, i)
            C, P, D, midpoints_x, midpoints_y, argcuts, idxcuts = coarseness_g(S,w)
            c = C[1,1,n,n]
            println("Cg = $c")
            c_g[30*(j-1)+i+1] = c
        end
    end
    
    df.c_g = c_g
    CSV.write("data/Results_df.csv",df)
end



## C_TLg(S) via DP for n=10:5:30
if true
    NIns = size(df,1)
    c_TLg = zeros(Int, NIns)
    
    for j = 1:5
        n = N[j]
        for i in I
            println("---------------------------------------\ni = $i\nn = $n")
            S, w = readInstance(n, i)
            c = coarseness_TLg(S,w)
            println("C_TLg = $c")
            c_TLg[30*(j-1)+i+1] = c
        end
    end
    
    df.c_TLg = c_TLg
    CSV.write("data/Results_df.csv", df)
end