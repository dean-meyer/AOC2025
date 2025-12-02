r=[parse.(Int,split(p,'-')) for p in split(strip(read(joinpath(@__DIR__,"Day2Data.txt"),String)),',') if !isempty(p)]
lo=minimum(first.(r));hi=maximum(last.(r))
a,b=let L=ndigits(hi);x1=Int[];x2=Int[]
    for l=1:L÷2,d=10^(l-1):10^l-1
        s=string(d)
        for k=2:L÷l
            n=parse(Int,repeat(s,k));n>hi&&break
            n<lo&&continue
            push!(x2,n);k==2&&push!(x1,n)
        end
    end
    sort!(x1);unique!(x1);sort!(x2);unique!(x2);x1,x2
end
g(v,r)=sum((a=t[1];b=t[2];i=searchsortedfirst(v,a);j=searchsortedlast(v,b);i<=j ? sum(@view v[i:j]) : 0) for t in r)
println("Part 1 Answer: ",g(a,r))
println("Part 2 Answer: ",g(b,r))