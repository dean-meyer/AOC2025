f(s,k)=begin n=lastindex(s);r=n-k;st=Int[];sizehint!(st,n)
 @inbounds for i=1:n;d=s[i]-'0'
  while !isempty(st)&&r>0&&st[end]<d;pop!(st);r-=1;end
  push!(st,d)
 end
 while r>0;pop!(st);r-=1;end
 v=0;@inbounds for i=1:k;v=10v+st[i];end;v end
f(s)=f(s,2)

main()=begin L=[strip(l) for l in readlines(joinpath(dirname(@__FILE__),"Day3Data.txt")) if !isempty(strip(l))]
 println("Part 1: ",sum(f(s) for s in L))
 println("Part 2: ",sum(f(s,12) for s in L))
end

main()