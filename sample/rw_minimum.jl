N = length(ARGS)>0 ? int(ARGS[1]) : 1024
T = length(ARGS)>1 ? int(ARGS[2]) : 1024
xs = zeros(Float64,N)
for t in 0:T
  println("$t $(mean(xs)) $(var(xs))")
  map!(x->rand()<0.5?x+1:x-1,xs)
end
