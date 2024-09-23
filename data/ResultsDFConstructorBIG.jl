include("../src/NaiveCoarseness.jl")
include("../src/GuillotineCoarseness.jl")
include("../src/DataUtils.jl")

using DataFrames
using CSV

if true && isfile("data/ResultsBIG_df.csv")
     df = CSV.read("data/ResultsBIG_df.csv", DataFrame)
end

N = [35,40,45,50,55,60]
I = 0:29

## base df construction    
if false
    df = baseDF(N,I)
    CSV.write("data/ResultsBIG_df.csv",df)
end

## Cg(S) via DP for n=35:5:60
if false
    NIns = size(df,1)
    c_g = zeros(Int, NIns)
    
    for j = 1:6
        n = N[j]
        for i in I
            println("---------------------------------------\ni = $i\nn= $n")
            S, w = readInstance(n, i)
            C, P, D, midpoints_x, midpoints_y, argcuts, idxcuts = coarseness_g(S,w)
            c = C[1,1,n,n]
            println("Cg = $c")
            c_g[30*(j-1)+i+1] = c
        end
    end
    
    df.c_g = c_g
    CSV.write("data/ResultsBIG_df.csv",df)
end

## C_TLg(S) via DP for n=35:5:60
if true
    NIns = size(df,1)
    c_TLg = zeros(Int, NIns)
    
    for j = 1:6
        n = N[j]
        for i in I
            println("---------------------------------------\ni = $i\nn= $n")
            S, w = readInstance(n, i)
            c = coarseness_TLg(S,w)
            println("C_TLg = $c")
            c_TLg[30*(j-1)+i+1] = c
        end
    end
    
    df.c_TLg = c_TLg
    CSV.write("data/ResultsBIG_df.csv", df)
end