# Read in our data and make it a boolean matrix, @ is true and . is false
function read_grid(path::AbstractString)
    lines = readlines(path)
    h = length(lines)
    w = length(lines[1])
    grid = falses(h, w)
    for i in 1:h
        row = lines[i]
        @assert length(row) == w
        for j in 1:w
            grid[i, j] = (row[j] == '@')
        end
    end
    return grid
end

# Generic neighbor offset generator using CartesianIndex
function neighbor_offsets(A::AbstractArray)
    N = ndims(A)
    ranges = ntuple(_ -> -1:1, N)
    offs = CartesianIndices(ranges)
    offsets = CartesianIndex{N}[]
    for δ in offs
        iszero(δ) && continue
        push!(offsets, δ)
    end
    return offsets
end

# Part 1: count rolls with < 4 neighboring rolls
function count_accessible_rolls(grid::AbstractArray{Bool})
    inds = CartesianIndices(grid)
    offsets = neighbor_offsets(grid)
    total = 0
    for I in inds
        grid[I] || continue
        neighbors = 0
        for δ in offsets
            J = I + δ
            checkbounds(Bool, grid, J) || continue
            if grid[J]
                neighbors += 1
                neighbors >= 4 && break
            end
        end
        neighbors < 4 && (total += 1)
    end
    return total
end

# Precompute neighbor counts for all rolls for part 2
function initial_neighbor_counts(grid::AbstractArray{Bool})
    counts = zeros(Int16, size(grid))
    inds = CartesianIndices(grid)
    offsets = neighbor_offsets(grid)
    for I in inds
        grid[I] || continue
        n = 0
        for δ in offsets
            J = I + δ
            checkbounds(Bool, grid, J) || continue
            grid[J] && (n += 1)
        end
        counts[I] = n
    end
    return counts
end

# Part 2: how many rolls can be removed by repeatedly removing rolls with < 4 neighbors?
function total_removable_rolls(grid::AbstractArray{Bool})
    counts = initial_neighbor_counts(grid)
    inds = CartesianIndices(grid)
    offsets = neighbor_offsets(grid)
    queue = CartesianIndex[]
    in_queue = falses(size(grid))
    for I in inds
        if grid[I] && counts[I] < 4
            push!(queue, I)
            in_queue[I] = true
        end
    end
    removed = 0
    while !isempty(queue)
        I = pop!(queue)
        in_queue[I] = false
        grid[I] || continue
        counts[I] < 4 || continue
        grid[I] = false
        removed += 1
        for δ in offsets
            J = I + δ
            checkbounds(Bool, grid, J) || continue
            grid[J] || continue
            counts[J] -= 1
            if counts[J] == 3 && !in_queue[J]
                push!(queue, J)
                in_queue[J] = true
            end
        end
    end
    return removed
end

function main()
    input_path = joinpath(dirname(@__FILE__), "Day4Data.txt")
    grid = read_grid(input_path)
    # Part 1
    accessible_once = count_accessible_rolls(grid)
    println("Part 1: accessible rolls = ", accessible_once)
    # Part 2
    removable = total_removable_rolls(copy(grid))
    println("Part 2: total removable rolls = ", removable)
end

main()