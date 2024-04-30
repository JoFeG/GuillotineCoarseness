include("../src/PlotingUtils.jl")
include("../src/NaiveCoarseness.jl")
include("../src/DataUtils.jl")

n = 10
i = 0

S, w = readInstance(n, i)

c, Π_opt = coarseness_bf(S, w)

p = size(Π_opt, 2)

println("-------------------------
n      = $n
i      = $i 
C(S)   = $c")
display(Π_opt)

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
out_path = "figs/temps/FIG_DATA_n$(n)_i$(i).pdf"
savefig(fig, out_path) 