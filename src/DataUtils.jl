function readInstance(n, i)
    (n in [10 + 5k for k=0:10]) || throw(ArgumentError("size not in the dataset need n in $([10 + 5k for k=0:10])"))
    (i in 0:29) || throw(ArgumentError("index not in the dataset need i in 0:29)"))
    
    padded = lpad(i,3,"0")
    path = "data/ic_unicamp_instances/r0$n-$padded.inst"
    
    S = zeros(n,2)
    w = zeros(Int,n)
    
    f = open(path)
    readline(f)
    for l = 1:2n
        line = readline(f)
        if l in 1:n
            S[l,:] = [parse(Float64,split(line)[k]) for k = 1:2]
        else
            line == "1" ? w[l-n] = 1 : w[l-n] = -1
        end
    end
    close(f)
    
    return S, w
end

function readSolution(n, i, t)
    (n in [10 + 5k for k=0:10]) || throw(ArgumentError("size not in the dataset need n in $([10 + 5k for k=0:10])"))
    (i in 0:29) || throw(ArgumentError("index not in the dataset need i in 0:29)"))
    (t in 1:2) || throw(ArgumentError("sol type not in range 1:2 soltypes = [-CUT-heuLB, -itUB-CUT-heuLB])"))
    
    soltypes = ["-CUT-heuLB", "-itUB-CUT-heuLB"]
    padded = lpad(i,3,"0")
    path = "data/ic_unicamp_solutions-full/r0$n-$padded-_$(soltypes[t]).isol"
    
    Π = zeros(Int,n)
    
    f = open(path)
    line = readline(f)
    k = parse(Int, split(line," ")[1])
    c = parse(Int, split(line," ")[2])
    for l = 1:k
        line = readline(f)
        line_third = split(line," ")[3]
        k_members = parse.(Int, split(line_third,(',','|'), keepempty=false)) .+ 1
        Π[k_members] .= l
    end
    close(f)
    
    return Π, c, k
end
        
        
    