function update(x,p=0.5)
  if rand() < p
    return x+one(x)
  else
    return x-one(x)
  end
end

