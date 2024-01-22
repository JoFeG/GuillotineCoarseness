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

fig = PlotRBKpointsΠhulls(S, w, Π)

out_path = "figs/testfig.svg"
savefig(fig, out_path)