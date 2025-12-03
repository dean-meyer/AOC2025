# Pick the largest k-digit subsequence from s (keep order)
function max_bank_joltage(s::AbstractString, k::Integer)
    n = lastindex(s)
    @assert n ≥ k
    to_remove = n - k
    stack = Int[]
    sizehint!(stack, n)

    @inbounds for idx in 1:n
        d = s[idx] - '0'
        while !isempty(stack) && to_remove > 0 && stack[end] < d
            pop!(stack); to_remove -= 1
        end
        push!(stack, d)
    end
    while to_remove > 0
        pop!(stack); to_remove -= 1
    end

    value = 0
    @inbounds for i in 1:k
        value = 10 * value + stack[i]
    end
    return value
end

max_bank_joltage(s::AbstractString) = max_bank_joltage(s, 2)

function main()
    lines = [strip(l) for l in readlines(joinpath(dirname(@__FILE__), "Day3Data.txt"))
             if !isempty(strip(l))]

    println("Part 1 joltage: ", sum(max_bank_joltage(s)      for s in lines))
    println("Part 2 joltage: ", sum(max_bank_joltage(s, 12) for s in lines))
end

main()