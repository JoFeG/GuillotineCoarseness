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
if true
    NIns = size(df,1)
    c_g = zeros(Int, NIns)
    c_g_time = zeros(NIns)
    
    # to ensure compilation before timing
    coarseness_g(readInstance(10, 0)...)
    
    for j = 1:6
        n = N[j]
        for i in I
            println("---------------------------------------\ni = $i\nn = $n")
            S, w = readInstance(n, i)
            CS,w)
            c = C[1,1,n,n]
            println("Cg = $c")
            println("T = $t [seg]")
            c_g[30*(j-1)+i+1] = c
            c_g_time[30*(j-1)+i+1] = t
        end
    end
    
    df.c_g = c_g
    df.c_g_time = c_g_time
    CSV.write("data/ResultsBIG_df.csv",df)
end

## C_TLg(S) via DP for n=35:5:60
if true
    NIns = size(df,1)
    c_TLg = zeros(Int, NIns)
    c_TLg_time = zeros(NIns)
    
    # to ensure compilation before timing
    coarseness_TLg(readInstance(10, 0)...)
    
    for j = 1:6
        n = N[j]
        for i in I
            println("---------------------------------------\ni = $i\nn = $n")
            S, w = readInstance(n, i)
            c, t = @timed coarseness_TLg(S,w)
            println("C_TLg = $c")
            println("T = $t [seg]")
            c_TLg[30*(j-1)+i+1] = c
            c_TLg_time[30*(j-1)+i+1] = t
        end
    end
    
    df.c_TLg = c_TLg
    df.c_TLg_time = c_TLg_time
    CSV.write("data/ResultsBIG_df.csv", df)
end