using DataFrames
using CSV
using Plots
using StatsPlots
using Statistics
using Measures

df = CSV.read("data/Results_df.csv", DataFrame)

df.RG_cg = (df.c_br1 .- df.c_g) ./ df.c_br1
df.RG_cTLg = (df.c_br1 .- df.c_TLg) ./ df.c_br1


fig = plot(
    margin = 10pt,
    size = (800,300),
    xgrid = false,
    xlabel = "Set size \$n=|S|\$",
    ylabel = "Relative gap of \$\\mathcal{C}_{TLg}(S)\$"
)

boxplot!(
    df.n, 
    df.RG_cTLg, 
    bar_width = 2.5, 
    line = (1.5, :black), 
    fill = :white, 
    markershape =:o, 
    markerstrokewidth = 1.2, 
    markercolor = :black,
    label = false
)

means = [mean(df.RG_cTLg[df.n .== n]) for n=10:5:30]
scatter!(
    10:5:30, 
    means, 
    markershape = :+, 
    markerstrokewidth = 1.2, 
    markercolor = :black,
    label = false
)

out_path = "figs/paperfig_exp_RGboxplot.pdf"
savefig(fig, out_path)