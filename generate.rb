require 'csv'
require 'json'

@thailand = {}

CSV.foreach('data/tambons.csv', headers:true) do |row|
  if @thailand[row[7]].nil?
    @thailand[row[7]] = {
      name: {
        thai: row[8].gsub(/จ.\s/, ''),
        english: row[9]
      },
      amphoes: {}
    }
  end

  if @thailand[row[7]][:amphoes][row[4]].nil?
    @thailand[row[7]][:amphoes][row[4]] = {
      name: {
        thai: row[5].gsub(/อ.\s/, ''),
        english: row[6]
      },
      tambons: {}
    }
  end

  @thailand[row[7]][:amphoes][row[4]][:tambons][row[1]] = {
    name: {
      thai: row[2].gsub(/ต.\s/, ''),
      english: row[3],
    },
    coordinates: {
      lat: row[10],
      lng: row[11]
    }
  }
end

def sort_by_to_h(h)
  h.sort_by {|k, v| k}
   .map {|a| Hash[*a]}
   .reduce(&:merge)
end

@thailand.each do |id, c|
  c[:amphoes].each do |id, a|
    a[:tambons] = sort_by_to_h(a[:tambons])
  end
  c[:amphoes] = sort_by_to_h(c[:amphoes])
end
@thailand = sort_by_to_h(@thailand)


File.open("dist/tree.json", 'w') do |f|
  f.write JSON.pretty_generate(@thailand)
end

