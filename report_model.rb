require 'open-uri'
require 'json'

class Report

  def report_by_zip_code(zip_code)
    response = JSON.parse(open("https://data.cityofnewyork.us/resource/erm2-nwe9.json?incident_zip=#{zip_code}&$limit=25000").read, symbolize_names: true)
    hashify(response)
  end

  def hashify(input_hash)
    count_hash = {}
    input_hash.each do |entry|
     	count_hash[entry[:descriptor]] == nil ? count_hash[entry[:descriptor]] = 1 : count_hash[entry[:descriptor]] += 1
    end
    count_hash.sort_by(&:last).each do |k, v|
      puts "#{k}: #{v}"
    end
  end
end
