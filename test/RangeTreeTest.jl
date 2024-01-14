include("../src/RangeTrees.jl")
    
    
using Random

N = 100
n = 15
A = sort!(randperm(N)[1:n])

r = sorted2BST(A)

PrintLeft(r)
PrintRight(r)

#=
for a in A
    print(a," ")
end

print("\n")

preOrderPrint(r)
=#