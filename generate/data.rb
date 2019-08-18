DGA_FILE = 'data/tambons.csv'.freeze
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

def tambons_data
  CSV.read(DGA_FILE, headers:true)
end
