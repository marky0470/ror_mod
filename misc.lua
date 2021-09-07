function table_contains(t, val)
	for _, v in ipairs(t) do
		if v == val then
			return true
		end
	end
	return false
end

function table_lookup(t, val)
	for i, v in ipairs(t) do
	  if v == val then
      return i
	  end
	end
end

--create alternate 2d table lookup which begins with the first elements of each table

function table_lookup2(t, val)
	for i, v in ipairs(t) do
	  for j, v in ipairs(t[i]) do
	    if v == val then
        return {i,j}
	    end
	  end
	end
end

function table.clone(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.clone(orig_key)] = table.clone(orig_value)
        end
    else
        copy = orig
    end
    return copy
end