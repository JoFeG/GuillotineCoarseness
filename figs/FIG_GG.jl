include("../src/PlotingUtils.jl")
include("../src/NaiveCoarseness.jl")

using Random

n = 10
S = [
 0.511477   0.909896
 0.121374   0.399877
 0.830376   0.927246
 0.0263919  0.404087
 0.935769   0.837092
 0.303712   0.118786
 0.765823   0.230427
 0.428958   0.798144
 0.71403    0.343844
 0.2        0.5   
]

w = zeros(Int,n)

fig_size = (200,200)
Π = [2,3,2,3,2,1,1,2,1,3]
   
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
