function coarseness_TLg(
        S::Matrix{<:Real}, 
        w::Vector{<:Integer}
    )
    
    n = length(w)

    # Utils ##################################################################################
    sortperm_x = sortperm(S[:, 1])
    sortperm_y = sortperm(S[:, 2])
    
    
    
    Cvh = zeros(Int, n)
    H1 = zeros(Int, n, n)
    H2 = zeros(Int, n, n)
    H3 = zeros(Int, n, n)
    
    
    for i = 1:n
        for j = i:n
            h_members = sortperm_x[i:j]
            S_h = S[h_members,:]
            w_h = w[h_members]
            
            H1[i,j] = abs(sum(w_h))
            sortperm_yh = sortperm(S_h[:,2])
            
            sorted_wh = w_h[sortperm_yh] 
            for s = 1:(j-i) # (j-i+1)-1
                H2_new = min(abs(sum(sorted_wh[1:s])),abs(sum(sorted_wh[s+1:end])))
                if H2_new > H2[i,j]
                    H2[i,j] = H2_new
                end
            end
        end
    end
    
    println("H1 =")
    display(H1)
    println("\n\nH2 =")
    display(H2)
    
    
    #Chv = zeros(Int, n)
    #V1 = zeros(Int, n, n)
    #V2 = zeros(Int, n, n)
    #V3 = zeros(Int, n, n)

end
