def sort_by_to_h(h)
  h.sort_by {|k, v| k}
   .map {|a| Hash[*a]}
   .reduce(&:merge)
end

def sort_by_key(json)
  json.sort_by {|k,v| k}.to_h
end
