# Work from the folder with the .jl file so I don't need to mess with changing directories...
cd(@__DIR__)
# Verify where we're running from
println("Running from: ", pwd())

# Read in puzzle data from csv
lines = readlines("Day1Data.csv")

# Convert to singed moved, L is positive and R is negative
moves = map(lines) do s
    s = strip(s)
    dir = s[1]
    val = parse(Int, s[2:end])
    dir == 'R' ? val : -val
end

# Count the times we cross 0, don't forget to start at 50...
# I also want to calculate the total number of moves and what the final dial position is because why not?
function countZeroHits(moves; start = 50)
    before = start
    totalHits = 0
    for m in moves
        after = before + m
        if m > 0
            # positive move, count multiples of 100
            totalHits += fld(after, 100) - fld(before, 100)
        elseif m < 0
            # negative move, count multiples of 100
            totalHits += fld(before - 1, 100) - fld(after - 1, 100)
        end
        before = after
    end
    finalUnwrapped = before
    dialPos = mod(finalUnwrapped, 100)  # 0–99
    return totalHits, finalUnwrapped, dialPos
end

# Display results
totalHits, finalUnwrapped, dialPos = countZeroHits(moves)
println("Total zero hits: ", totalHits)
println("Final unwrapped position: ", finalUnwrapped)
println("Final dial position (0–99): ", dialPos)