include("../src/PlotingUtils.jl")
include("../src/NaiveCoarseness.jl")

using Random

n = 9
println("n = $n")

for seed = 41:100
    rng = MersenneTwister(seed)


    S = rand(rng, n, 2)
    w = rand(rng,[-1,1], n)

    c, Π_opt = coarseness_bf(S, w)
    p = size(Π_opt, 2)

    println("-------------------------
seed   = $seed, 
C(S)   = $c
#Π_opt = $p")

    figs = Array{Plots.Plot}(undef, p)
    fig_size = (200,200)
    
    for i = 1:p
        Π = Π_opt[:,i]
        figs[i] = PlotRBKpointsΠhulls(
            S, 
            w, 
            Π, 
            fig_size = fig_size, 
            marker_size = 3
        )
    end

    fig = plot(
            figs...,
            size = (p*fig_size[1],fig_size[2]),
            layout = (1,p)
        )
    out_path = "figs/temps/FIG_PiPi_seed$seed.pdf"
    savefig(fig, out_path)    
end