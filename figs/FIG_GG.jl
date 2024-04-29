include("../src/PlotingUtils.jl")
include("../src/NaiveCoarseness.jl")

using Random

n = 9
seed = 30

rng = MersenneTwister(seed)

S = rand(rng, n, 2)
w = zeros(Int,n)

fig_size = (200,200)
Π = [1,1,1,1,1,1,1,1,1]
   
fig = PlotRBKpointsΠhulls(
    S, 
    w, 
    Π, 
    fig_size = fig_size, 
    marker_size = 3
)

plot_add_lines!(fig, S)

out_path = "figs/temps/FIG_GG.pdf"
savefig(fig, out_path)    
