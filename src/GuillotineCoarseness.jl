function sorted2midpoints(sorted)
    n = length(sorted)
    midpoints = zeros(n + 1)
    Δ = (sorted[1] + sorted[n])/(n+1)
    midpoints[1] = sorted[1] - Δ
    midpoints[n+1] = sorted[n] + Δ
    midpoints[2:n] = 0.5(sorted[2:n] + sorted[1:n-1])
    return midpoints
end

function coarseness_g(
        S::Matrix{<:Real}, 
        w::Vector{<:Integer}
    )
    
    n = length(w)
    
    # Utils ##################################################################################
    sortperm_x = sortperm(S[:, 1])
    sorted_x = S[sortperm_x, 1]
    midpoints_x = sorted2midpoints(sorted_x)

    sortperm_y = sortperm(S[:, 2])
    sorted_y = S[sortperm_y, 2]
    midpoints_y = sorted2midpoints(sorted_y)

    Disc_pqij(p,q,i,j) = abs(sum(w[intersect(sortperm_x[p:p+i-1],sortperm_y[q:q+j-1])]))
    Count_pqij(p,q,i,j) = length(intersect(sortperm_x[p:p+i-1],sortperm_y[q:q+j-1]))

    # Initialization #########################################################################
    inf = 100
    C = 100*ones(Int,n,n,n,n)
    P = zeros(Int,n,n,n,n)
    D = zeros(Int,n,n,n,n)

    # 0 --> not calculated!
    # 1 --> Discepancy
    # 2 --> Vertical
    # 3 --> Horizontal
    argcuts = zeros(Int,n,n,n,n)

    # 0   --> not calculated! or Discepancy
    # 1:n --> midpoint index of v or h cut
    idxcuts = zeros(Int,n,n,n,n)

    for p = 1:n
        for q = 1:n
            for i = 1:n-p+1
                for j = 1:n-q+1
                    P[p,q,i,j] = Count_pqij(p,q,i,j)
                    D[p,q,i,j] = Disc_pqij(p,q,i,j)
                end
            end
            if P[p,q,1,1] != 0
                C[p,q,1,1] = D[p,q,1,1]
            end
        end
    end
    
    
    for i = 1:n
        for j = 1:n
            if i+j > 2
                for p = 1:n-i+1
                    for q = 1:n-j+1
                        # CREO QUE ESTE IF NO CAMBIA NADA; PERO EVITA HARTO CALCULO TRIVIAL
                        if P[p,q,i,j] != 0

                            # vertical cut
                            if i > 1
                                v_cuts = [[C[p,q,s,j], C[p+s,q,i-s,j]][k] for s=1:i-1, k=1:2]
                                for s=1:i-1
                                    if v_cuts[s,1]==inf || v_cuts[s,2]==inf
                                        v_cuts[s,:] = [-1, -1]
                                    end
                                end
                                v_argmins = argmin(v_cuts, dims=2)
                                v_mins = v_cuts[v_argmins]
                                v_argmax = argmax(v_mins)
                                v_max = v_mins[v_argmax]
                            else
                                v_max = -1
                            end

                            # horizontal cut
                            if j > 1
                                h_cuts =  [[C[p,q,i,t], C[p,q+t,i,j-t]][k] for t=1:j-1, k=1:2]
                                for t=1:j-1
                                    if h_cuts[t,1]==inf || h_cuts[t,2]==inf
                                        h_cuts[t,:] = [-1, -1]
                                    end
                                end
                                h_argmins = argmin(h_cuts, dims = 2)
                                h_mins = h_cuts[h_argmins]
                                h_argmax = argmax(h_mins)
                                h_max = h_mins[h_argmax]
                            else
                                h_max = -1
                            end                    

                            mini = [D[p,q,i,j], v_max, h_max]

                            C[p,q,i,j] = maximum(mini)
                            argcuts[p,q,i,j] = argmax(mini)
                            if argcuts[p,q,i,j] == 2
                                idxcuts[p,q,i,j] = v_argmax[1]
                            elseif argcuts[p,q,i,j] == 3
                                idxcuts[p,q,i,j] = h_argmax[1]
                            end
                        end
                    end
                end
            end
        end
    end

    
    return C, P, D, midpoints_x, midpoints_y, argcuts, idxcuts
end


function coarseness_TLg(
        S::Matrix{<:Real}, 
        w::Vector{<:Integer}
    )
    
    n = length(w)

    # Horizontal first #######################################################################
    
    # Utils ##################################################################################
    sortperm_x = sortperm(S[:, 1])
    Cvh = zeros(Int, n)
    H1 = zeros(Int, n, n)
    H2 = zeros(Int, n, n)
    H3 = zeros(Int, n, n)
    
    # H = min(H1,H2,H3) ######################################################################
    for i = 1:n
        for j = i:n
            h_members = sortperm_x[i:j]
            S_h = S[h_members,:]
            w_h = w[h_members]
            n_h = length(w_h) # == j-i+1
            
            H1[i,j] = abs(sum(w_h))
            sortperm_yh = sortperm(S_h[:,2])
            
            sorted_wh = w_h[sortperm_yh] 
            for s = 1:(n_h - 1)
                H2_new = min(
                            abs(sum(sorted_wh[1:s])),
                            abs(sum(sorted_wh[s+1:n_h]))
                            )
                if H2_new > H2[i,j]
                    H2[i,j] = H2_new
                end
            end
        
            for s = 1:(n_h - 2)
                for t = (s + 1):(n_h - 1)
                    H3_new = min(
                                abs(sum(sorted_wh[1:s])),
                                abs(sum(sorted_wh[s+1:t])),
                                abs(sum(sorted_wh[t+1:n_h]))
                                )
                    if H3_new > H3[i,j]
                        H3[i,j] = H3_new
                    end
                end
            end
        end
    end
    H = max.(H1, H2, H3)
    
    # Horizontal DP ########################################################################## 
    Cvh[1] = 1
    Cvh[2:n] = H1[1,2:n]
    for i = 2:n
        for s = 1:(i-1)
            Cvh_new = min(Cvh[s], H[s+1, i])
            if Cvh_new > Cvh[i]
                Cvh[i] = Cvh_new
            end
        end
    end
    
    # Vertical first #########################################################################
    
    # Utils ##################################################################################
    sortperm_y = sortperm(S[:, 2])
    Chv = zeros(Int, n)
    V1 = zeros(Int, n, n)
    V2 = zeros(Int, n, n)
    V3 = zeros(Int, n, n)
    
    # V = min(V1,V2,V3) ######################################################################
    for i = 1:n
        for j = i:n
            v_members = sortperm_y[i:j]
            S_v = S[v_members,:]
            w_v = w[v_members]
            n_v = length(w_v) # == j-i+1
            
            V1[i,j] = abs(sum(w_v))
            sortperm_xv = sortperm(S_v[:,1])
            
            sorted_wv = w_v[sortperm_xv] 
            for s = 1:(n_v - 1)
                V2_new = min(
                            abs(sum(sorted_wv[1:s])),
                            abs(sum(sorted_wv[s+1:n_v]))
                            )
                if V2_new > V2[i,j]
                    V2[i,j] = V2_new
                end
            end
        
            for s = 1:(n_v - 2)
                for t = (s + 1):(n_v - 1)
                    V3_new = min(
                                abs(sum(sorted_wv[1:s])),
                                abs(sum(sorted_wv[s+1:t])),
                                abs(sum(sorted_wv[t+1:n_v]))
                                )
                    if V3_new > V3[i,j]
                        V3[i,j] = V3_new
                    end
                end
            end
        end
    end
    V = max.(V1, V2, V3)

    # Vertical DP ############################################################################ 
    Chv[1] = 1
    Chv[2:n] = V1[1,2:n]
    for i = 2:n
        for s = 1:(i-1)
            Chv_new = min(Chv[s], V[s+1, i])
            if Chv_new > Chv[i]
                Chv[i] = Chv_new
            end
        end
    end
    
    
    
    C_TLg = max(Cvh[n],Chv[n])

    # println("C_TLg = max(Cvh[n],Chv[n]) = max($(Cvh[n]),$(Chv[n])) = $C_TLg")
    # return H1, H2, H3, H, Cvh, V1, V2, V3, V, Chv
    # H1, H2, H3, H, Cvh, V1, V2, V3, V, Chv = coarseness_TLg(S,w)
    
    return C_TLg
end
