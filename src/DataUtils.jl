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