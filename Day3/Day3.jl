# Functions again today. Feels better?
function max_bank_joltage(s::AbstractString, k::Integer)
    n = lastindex(s)
    @assert n >= k
    to_remove = n - k
    stack = Int[]
    #sizehint!(stack, n)
    for idx in 1:n
        d = s[idx] - '0'
        while !isempty(stack) && to_remove > 0 && stack[end] < d
            pop!(stack)
            to_remove -= 1
        end
        push!(stack, d)
    end
    while to_remove > 0
        pop!(stack)
        to_remove -= 1
    end
    value = 0
    for i in 1:k
        value = value * 10 + stack[i]
    end
    return value
end

# And let's do a main because i'm tired of fighting with REPL/VSCode...
function main()
    input_path = joinpath(dirname(@__FILE__), "Day3Data.txt")
    part1_total = 0
    part2_total = 0
    open(input_path, "r") do io
        for raw in eachline(io)
            s = strip(raw)
            isempty(s) && continue
            part1_total += max_bank_joltage(s, 2)
            part2_total += max_bank_joltage(s, 12)
        end
    end
    println("Part 1 joltage: ", part1_total)
    println("Part 2 joltage: ", part2_total)
end

main()
