struct RTree1dNode{T}
    value::T
    
    left::Union{RTree1dNode, Nothing}
    right::Union{RTree1dNode, Nothing}
end

