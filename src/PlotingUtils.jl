using Plots
using LazySets

function PlotRBKpoints(
        S::Matrix{<:Real}, 
        w::Vector{<:Integer}; 
        fig_size = (500, 500),
        marker_size = 6
    )
    
    S = Float64.(S)
    red_points = S[w.==1, :]
    blue_points = S[w.==-1, :]
    black_points = S[w.==0, :]

    max_x, max_y = maximum(S, dims = 1)
    min_x, min_y = minimum(S, dims = 1)
    
    range_x = max_x - min_x
    range_y = max_y - min_y
    
    fig = scatter(
        size = fig_size, 
        legend = :none, 
        xlims = (min_x - .2range_x, max_x + .2range_x),
        ylims = (min_y - .2range_y, max_y + .2range_y), 
        axis = 0, 
        framestyle = :none,
        grid = 0,
        color = :white
    )

    scatter!(
        fig, 
        red_points[:, 1], 
        red_points[:, 2], 
        color = :red,
        markerstrokecolor = :red,
        markerstrokewidth = marker_size / 2,
        markersize = marker_size
    )
    
    scatter!(
        fig, 
        blue_points[:, 1], 
        blue_points[:, 2], 
        color = :white, 
        markerstrokecolor = :blue,
        markerstrokewidth = marker_size / 2,
        markersize = marker_size
    )
    
    scatter!(
        fig, 
        black_points[:, 1], 
        black_points[:, 2], 
        color = :black, 
        markerstrokecolor = :black,
        markerstrokewidth = marker_size / 2,
        markersize = marker_size
    )
    
    return fig
end


function PlotRBKpointsΠhulls(
        S::Matrix{<:Real}, 
        w::Vector{<:Integer},
        Π::Vector{<:Integer}; 
        fig_size = (500, 500),
        marker_size = 6
    )
        
    S = Float64.(S)
    red_points = S[w.==1, :]
    blue_points = S[w.==-1, :]
    black_points = S[w.==0, :]

    max_x, max_y = maximum(S, dims = 1)
    min_x, min_y = minimum(S, dims = 1)
    
    range_x = max_x - min_x
    range_y = max_y - min_y
    
    fig = scatter(
        size = fig_size, 
        legend = :none, 
        xlims = (min_x - .2range_x, max_x + .2range_x),
        ylims = (min_y - .2range_y, max_y + .2range_y), 
        axis = 0, 
        framestyle = :none,
        grid = 0,
        color = :white
    )
    
    k = length(unique(Π))
    1:k == sort(unique(Π)) || throw(ArgumentError("assignments vector Π is not of consecutive integer values"))
    for j = 1:k
        j_points = S[Π .== j,:]
        j_set = [j_points[i,:] for i in 1:size(j_points,1)]
        j_hull = convex_hull(j_set)
        plot!(
            fig,
            VPolygon(j_hull), 
            color = :lightgray,
            alpha = 1,
            linecolor = :lightgray,
            linewidth = 2marker_size
        )
    end


    scatter!(
        fig, 
        red_points[:, 1], 
        red_points[:, 2], 
        color = :red,
        markerstrokecolor = :red,
        markerstrokewidth = marker_size / 2,
        markersize = marker_size
    )
    
    scatter!(
        fig, 
        blue_points[:, 1], 
        blue_points[:, 2], 
        color = :white, 
        markerstrokecolor = :blue,
        markerstrokewidth = marker_size / 2,
        markersize = marker_size
    )
    
    scatter!(
        fig, 
        black_points[:, 1], 
        black_points[:, 2], 
        color = :black, 
        markerstrokecolor = :black,
        markerstrokewidth = marker_size / 2,
        markersize = marker_size
    )
    
    return fig
end