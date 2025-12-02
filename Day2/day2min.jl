r = [(a,b) for p in split(strip(read(joinpath(@__DIR__,"Day2Data.txt"),String)),',')
          if !isempty(p)
          for (a,b) in [parse.(Int,split(p,'-'))]]
lo = minimum(first.(r)); hi = maximum(last.(r))
f(lo,hi) = begin
    L = ndigits(hi); x1 = Int[]; x2 = Int[]
    for l in 1:L÷2, d in 10^(l-1):10^l-1
        s = string(d)
        for k in 2:L÷l
            n = parse(Int, repeat(s,k))
            n > hi && break
            n < lo && continue
            push!(x2,n)
            k == 2 && push!(x1,n)
        end
    end
    sort!(x1); unique!(x1)
    sort!(x2); unique!(x2)
    x1, x2
end
g(v,r) = sum(begin
                 a,b = t
                 i = searchsortedfirst(v,a)
                 j = searchsortedlast(v,b)
                 i <= j ? sum(@view v[i:j]) : 0
             end for t in r)
a,b = f(lo,hi)
println("Part 1 Answer: ", g(a,r))
println("Part 2 Answer: ", g(b,r))