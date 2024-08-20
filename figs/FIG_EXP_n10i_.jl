include("../src/PlotingUtils.jl")
include("../src/NaiveCoarseness.jl")
include("../src/GuillotineCoarseness.jl")
include("../src/DataUtils.jl")

n = 10
i = 21

S, w = readInstance(n, i)

c, Π = coarseness_bf(S, w)  ## esto toma ≈1min

## sol i=5 
# c = 4
# Π = [
#  1
#  2
#  1
#  2
#  2
#  1
#  2
#  1
#  1
#  1
#     ]

for k=1:size(Π)[2]
    fig = PlotRBKpointsΠhulls(
                S, 
                w, 
                Π[:,k], 
                fig_size = (300,300), 
                marker_size = 3
            )

    out_path = "figs/temps/FIG_EXP_n$(n)_i$(i)_k$(k).pdf"
    savefig(fig, out_path)
end