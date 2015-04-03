require 'open-uri'
require 'json'

class Report

  def report_by_zip_code(zip_code)
    response = JSON.parse(open("https://data.cityofnewyork.us/resource/erm2-nwe9.json?incident_zip=#{zip_code}&$limit=25000").read, symbolize_names: true)
    hashify(response)
  end

  def report_by_descriptor(descriptor)
    response = JSON.parse(open("https://data.cityofnewyork.us/resource/erm2-nwe9.json?descriptor=#{descriptor}&$limit=25000").read, symbolize_names: true)
    hashify(response, :incident_zip)
  end

  def report_any(column, report_on, group_by)
    response = JSON.parse(open("https://data.cityofnewyork.us/resource/erm2-nwe9.json?#{column}=#{report_on}&$limit=25000").read, symbolize_names: true)
    hashify(response, group_by)
  end

  def hashify(input_hash, column = :descriptor)
    count_hash = {}
    input_hash.each do |entry|
      # p entry[column]
      count_hash[entry[column]] == nil ? count_hash[entry[column]] = 1 : count_hash[entry[column]] += 1
    end
    # p count_hash
    count_hash.sort_by(&:last).each do |k, v|
      puts "#{k}: #{v}"
    end
  end

  def jeopardy
    @pid = fork{ exec 'afplay Jeopardy-theme-song.mp3'}
  end

  def kill_jeopardy
    Process.kill "TERM", @pid
  end
end
