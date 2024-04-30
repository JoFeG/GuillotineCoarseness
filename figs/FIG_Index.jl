include("../src/PlotingUtils.jl")
include("../src/NaiveCoarseness.jl")

using Random
seed = 1
rng = MersenneTwister(seed)

S = [
# 0.511477   0.909896
 0.830376   0.927246
 0.0263919  0.404087
 0.935769   0.837092
 0.303712   0.118786
 0.765823   0.230427
 0.428958   0.798144
 0.71403    0.343844
 0.2        0.5   
]

n = size(S,1)
w = rand(rng,[-1,1], n)

fig_size = (400,200)

   
fig = PlotRBKpoints(
    S, 
    w, 
    fig_size = fig_size, 
    marker_size = 3
)

plot_add_lines!(fig, S)

out_path = "figs/temps/FIG_Index.pdf"
savefig(fig, out_path)    
