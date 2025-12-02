# So we can time
using BenchmarkTools: @btime

# Parse the ranges from our input file
read_ranges(path::AbstractString) = begin
    text  = strip(read(path, String))
    parts = filter(!isempty, split(text, ','))

    [let 
         lo, hi = parse.(Int, split(part, '-'))
         (lo, hi)
     end for part in parts]
end

# Generate all of our possible double numbers, part 1
double_numbers(global_min::Int, global_max::Int) = begin
    len_max = length(string(global_max))
    doubles = Int[]

    for half_len in 1:(len_max ÷ 2)
        let pow10  = 10^half_len,
            factor = pow10 + 1,
            x_start = 10^(half_len - 1),
            x_stop  = min(10^half_len - 1, global_max ÷ factor)

            if x_stop >= x_start
                for x in x_start:x_stop
                    val = x * factor
                    val >= global_min && push!(doubles, val)
                end
            end
        end
    end

    sort!(doubles)
    doubles
end

# Generate all of our possible repeating nubmers, part 2
repeated_numbers(global_min::Int, global_max::Int) = begin
    len_max = length(string(global_max))
    vals    = Int[]

    # block_len is the number of digits in the repeating block
    for block_len in 1:(len_max ÷ 2)
        # Need to avoid leading zeroes 
        let start = 10^(block_len - 1),
            stop  = 10^block_len - 1
            for block in start:stop
                let s = string(block)
                    # Repeat the block k times
                    for k in 2:(len_max ÷ block_len)
                        let rep = repeat(s, k)
                            val = parse(Int, rep)
                            # Stop once we get the global max value
                            val > global_max && break
                            val >= global_min && push!(vals, val)
                        end
                    end
                end
            end
        end
    end

    sort!(vals)
    # Dedupe
    unique!(vals)
    vals
end

# Sum the invalid IDs for part 1
sum_part1(
    ranges::Vector{Tuple{Int,Int}},
    doubles::Vector{Int},
) = begin
    total = 0
    for (lo, hi) in ranges
        let i1 = searchsortedfirst(doubles, lo),
            i2 = searchsortedlast(doubles, hi)

            i1 <= i2 || continue
            total += sum(@view doubles[i1:i2])
        end
    end
    total
end

# Sum the invalid IDs for part 2
sum_part2(
    ranges::Vector{Tuple{Int,Int}},
    invalid_ids::Vector{Int},
) = begin
    total = 0
    for (lo, hi) in ranges
        let i1 = searchsortedfirst(invalid_ids, lo),
            i2 = searchsortedlast(invalid_ids, hi)

            i1 <= i2 || continue
            total += sum(@view invalid_ids[i1:i2])
        end
    end
    total
end

ranges = read_ranges(joinpath(@__DIR__, "Day2Data.txt"))
mins = first.(ranges)
maxs = last.(ranges)
global_min = minimum(mins)
global_max = maximum(maxs)
doubles     = double_numbers(global_min, global_max)
invalid_ids = repeated_numbers(global_min, global_max)

println("\n=== Benchmark sums only (no generation) ===")
@btime begin
    answer1 = sum_part1($ranges, $doubles)
    answer2 = sum_part2($ranges, $invalid_ids)
end

answers() = begin
    ranges = read_ranges(joinpath(@__DIR__, "Day2Data.txt"))
    mins = first.(ranges)
    maxs = last.(ranges)
    global_min = minimum(mins)
    global_max = maximum(maxs)
    doubles     = double_numbers(global_min, global_max)
    invalid_ids = repeated_numbers(global_min, global_max)
    (sum_part1(ranges, doubles), sum_part2(ranges, invalid_ids))
end
@btime answers()