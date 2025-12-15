function parse_ranges(path::AbstractString)
    ranges = Tuple{Int,Int}[]
    open(path, "r") do io
        for line in eachline(io)
            s = strip(line)
            isempty(s) && break
            lo, hi = split(s, '-')
            push!(ranges, (parse(Int, lo), parse(Int, hi)))
        end
    end
    return ranges
end

function parse_ranges_and_ids(path::AbstractString)
    ranges = Tuple{Int,Int}[]
    ids    = Int[]
    open(path, "r") do io
        for line in eachline(io)
            s = strip(line)
            isempty(s) && break
            lo, hi = split(s, '-')
            push!(ranges, (parse(Int, lo), parse(Int, hi)))
        end
        for line in eachline(io)
            s = strip(line)
            isempty(s) && continue
            push!(ids, parse(Int, s))
        end
    end
    return ranges, ids
end

function merge_ranges(ranges::Vector{Tuple{Int,Int}})
    sort!(ranges, by = first)
    merged = Tuple{Int,Int}[]
    for (lo, hi) in ranges
        if isempty(merged)
            push!(merged, (lo, hi))
        else
            plo, phi = merged[end]
            if lo > phi + 1
                push!(merged, (lo, hi))
            else
                merged[end] = (plo, max(phi, hi))
            end
        end
    end
    return merged
end

function is_fresh(starts::Vector{Int}, merged::Vector{Tuple{Int,Int}}, x::Int)
    i = searchsortedlast(starts, x)
    if i < 1
        return false
    end
    _, hi = merged[i]
    return x ≤ hi
end

function count_fresh_ids(path::AbstractString)
    ranges, ids = parse_ranges_and_ids(path)
    merged = merge_ranges(ranges)
    starts = first.(merged)
    total = 0
    @inbounds for x in ids
        total += is_fresh(starts, merged, x)
    end
    return total
end

function count_total_fresh_ids(path::AbstractString)
    ranges = parse_ranges(path)
    merged = merge_ranges(ranges)
    total = 0
    @inbounds for (lo, hi) in merged
        total += hi - lo + 1
    end
    return total
end

function main()
    input_path = joinpath(dirname(@__FILE__), "Day5Data.txt")
    part1 = count_fresh_ids(input_path)
    println("Part 1 answer: ", part1)
    part2 = count_total_fresh_ids(input_path)
    println("Part 2 answer: ", part2)
end

main()