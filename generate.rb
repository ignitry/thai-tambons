require 'pry'
require 'csv'
require 'json'
require 'open-uri'

JQUERY_THAILAND_JSON_URL = 'https://raw.githubusercontent.com/earthchie/jquery.Thailand.js/master/jquery.Thailand.js/database/raw_database/raw_database.json'.freeze

def zip_code_data
  @zip_code_data ||= JSON.load(open(JQUERY_THAILAND_JSON_URL)).group_by do |s|
      s['zipcode']
    end.map do |zip, tambons|
      tambons.map do |tambon|
        { tambon['district_code'] => zip }
      end.reduce(&:merge)
    end.reduce(&:merge)
end

@thailand = {}

CSV.foreach('data/tambons.csv', headers:true) do |row|
  if @thailand[row[7]].nil?
    @thailand[row[7]] = {
      info: {
        thai: row[8].gsub(/จ.\s/, ''),
        english: row[9]
      },
      amphoes: {}
    }
  end

  if @thailand[row[7]][:amphoes][row[4]].nil?
    @thailand[row[7]][:amphoes][row[4]] = {
      info: {
        thai: row[5].gsub(/อ.\s|เขต\s/, ''),
        english: row[6]
      },
      tambons: {}
    }
  end

  @thailand[row[7]][:amphoes][row[4]][:tambons][row[1]] = {
    info: {
      thai: row[2].gsub(/ต.\s|แขวง\s/, ''),
      english: row[3],
      zipcode: zip_code_data[row[1].to_i]
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

