mutable struct BinaryNode{T}
    value::T
    
    left::Union{BinaryNode, Nothing}
    right::Union{BinaryNode, Nothing}
    
    BinaryNode(x::T) where T = new{T}(x, nothing, nothing)
end



function sorted2BST(A)
    n = length(A)
    m = n ÷ 2
    
    if n == 1
        return BinaryNode(A[1])
    end
    
    root = BinaryNode(A[m+1])
    
    root.left = sorted2BST(A[1:m])
    
    if m+1 < n
        root.right = sorted2BST(A[m+2:n])
    end
    
    return root
end



function PrintPreOrder(Node)
    print(Node.value, " ")
    
    if !isnothing(Node.left)
        PrintPreOrder(Node.left)
    end
    
    if !isnothing(Node.right)
        PrintPreOrder(Node.right)
    end
end



function PrintLeft(Node)
    print(Node.value, " ")
    
    if !isnothing(Node.left)
        PrintLeft(Node.left)
    else
        print("\n")
    end
end



function PrintRight(Node)
    print(Node.value, " ")
    
    if !isnothing(Node.right)
        PrintRight(Node.right)
    else
        print("\n")
    end
end