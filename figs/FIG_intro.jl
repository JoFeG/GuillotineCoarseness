include("../src/PlotingUtils.jl")

S = [
    0 0
    1 0.9
    1 1
    1 1.1
    2 2
]

w = [0, 0, -1, 1, 0]
Π = [1, 1, 2, 2, 2]

fig = PlotRBKpointsΠhulls(S, w, Π, fig_size = (650, 150),marker_size = 3)

out_path = "figs/FIG_into.pdf"
savefig(fig, out_path)

