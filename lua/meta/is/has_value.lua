return function(a, b)
--  if type(a)=='nil' or type(b)~='table' then return false end
  if type(b)~='table' then return false end
  for _,v in pairs(b) do
    if v==a then return true end
  end
  return false
end